//
//  iChange.swift
//  CurrencyConverter
//
//  Created by Mikalai Bekliamishchau on 03/02/2025.
//

import UIKit
import SnapKit
import Combine
import Metal
import MetalKit

enum ExchangeRateViewConstants {
    static let labelTitle = "Currency Converter"
    static let sourceTitle = "Source"
    static let targetTitle = "Source"
    
    static let alertErrorTitle = "Error"
    static let alertButtonTitleOK = "OK"
    static let placeholderSearchCurrency = "Search currency"
}

class ExchangeRateViewController: UIViewController {
    private let viewModel: ExchangeRateViewModel
    private var cancellables = Set<AnyCancellable>()

    private let exchangeRateLabel = UILabel()
    private let errorLabel = UILabel()
    
    private let gradientLayer = CAGradientLayer()
    
    private var coinView = CoinView()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = ExchangeRateViewConstants.labelTitle
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.textColor = .darkGray
        return label
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .lightGray
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var sourceCurrencyView: CurrencyView = {
        let view = CurrencyView()
        view.setTitle(ExchangeRateViewConstants.sourceTitle)
        view.delegate = self
        return view
    }()
    
    private lazy var targetCurrencyView: CurrencyView = {
        let view = CurrencyView()
        view.setTitle(ExchangeRateViewConstants.targetTitle)
        view.delegate = self
        return view
    }()
    
    private lazy var borderView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.3)
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.backgroundColor = .white
        stackView.layer.cornerRadius = 20
        stackView.clipsToBounds = true
        return stackView
    }()
    
    // MARK: Initialization
    
    init(viewModel: ExchangeRateViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        configureSubviews()
        addSubviews()
        makeConstraints()
        
        Task {
            await setDefaultValues()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.startUpdatingExchangeRate()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.cancelUpdateTask()
    }
    
    // MARK: - Methods
    
    private func bindViewModel() {
        viewModel.$targetExchangeRate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] rate in
                // here
                self?.targetCurrencyView.setAmount(String(self!.viewModel.targetAmount ?? 0.0))
            }
            .store(in: &cancellables)
        
        viewModel.$targetAmount
            .receive(on: DispatchQueue.main)
            .sink { [weak self] rate in
                // here
                self?.targetCurrencyView.setAmount(String(self!.viewModel.targetAmount ?? 0.0))
            }
            .store(in: &cancellables)
        

        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.errorLabel.text = error
                self?.errorLabel.isHidden = error == nil
            }
            .store(in: &cancellables)
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                
                self?.errorLabel.text = String()
                self?.errorLabel.isHidden = true
                
                self?.coinView.toggleState(isLoading: isLoading)
            }
            .store(in: &cancellables)
    }
    
    private func configureSubviews() {
        setGradientBackground()
        targetCurrencyView.disableInput()
        view.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action:#selector(tapDidTouch)))
        coinView.backgroundColor = UIColor.clear
    }
    
    private func addSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(stackView)
        view.addSubview(activityIndicator)
        view.addSubview(coinView)
        
        stackView.addArrangedSubview(sourceCurrencyView)
        stackView.addArrangedSubview(borderView)
        stackView.addArrangedSubview(targetCurrencyView)
    }
    
    private func makeConstraints() {
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        sourceCurrencyView.backgroundColor = .white
        
        sourceCurrencyView.snp.makeConstraints {
            $0.height.equalTo(120)
        }
        
        borderView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        targetCurrencyView.snp.makeConstraints {
            $0.height.equalTo(120)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
            $0.left.right.equalToSuperview().inset(20).priority(.high)
            $0.width.lessThanOrEqualTo(388).priority(.required)
        }
        
        coinView.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(100)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.9)
            $0.height.equalTo(coinView.snp.width)
        }
    }
    
    private func setDefaultValues() async {
        sourceCurrencyView.currency = viewModel.fetchFromCurreny()
        sourceCurrencyView.setAmount(String(format: "%.2f", viewModel.fetchAmount()))
        targetCurrencyView.currency = viewModel.fetchToCurrency()
        await convert()
    }
    
    
    private func convert() async {
        await viewModel.fetchExchangeRate(
            fromAmount: self.sourceCurrencyView.getAmount(),
            fromCurrency: self.sourceCurrencyView.currency,
            toCurrency: self.targetCurrencyView.currency
        )
    }

    
    private func setGradientBackground() {
        
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.white.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = view.bounds
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    @objc func tapDidTouch() {
        view.endEditing(true)
    }
}

// MARK: - CurrencyViewProtocol

extension ExchangeRateViewController: CurrencyViewProtocol {
    
    func selectCurrencyPressed(sender: CurrencyView) {
        let client: HTTPClient = HTTPClient()
        let repository: CurrenciesRepository = .init(client: client)
        let excahngeUseCase = GetCurrenciesListUseCase(repository: repository)
        let viewModel = CurrencyPickerViewModel(currenciesUseCase: excahngeUseCase)
        let vc = CurrencyPickerViewController(viewModel: viewModel)
        
        self.present(vc, animated: true)

        vc.onCurrencySelected = { [weak self] currency in
            guard let self = self, let currency = currency else { return }
            Task {
                await MainActor.run {
                    sender.currency = currency
                }
                await self.convert()
            }
        }
    }
    
    func didChangeAmount(to amount: Double?) async {
        await convert()
    }
}
