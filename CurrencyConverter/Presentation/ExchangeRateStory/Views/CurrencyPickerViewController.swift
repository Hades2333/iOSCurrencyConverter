//
//  CurrencyPickerViewController.swift
//  CurrencyConverter
//
//  Created by Mikalai Bekliamishchau on 03/02/2025.
//

import UIKit
import SnapKit

class CurrencyPickerViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = ExchangeRateViewConstants.placeholderSearchCurrency
        return searchBar
    }()
    
    private let viewModel: CurrencyPickerViewModel
    
    var onCurrencySelected: ((CurrencyModel?) -> Void)?
    
    init(viewModel: CurrencyPickerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubviews()
        makeConstraints()
        bindViewModel()
    }
    
    private func bindViewModel() {
        let filteredCurrenciesCancellable = viewModel.$filteredCurrencies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
                
            }
        
        let errorCancellable = viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                self?.showAlert(message: errorMessage)
            }
        
        viewModel.addCancellable(filteredCurrenciesCancellable)
        viewModel.addCancellable(errorCancellable)
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
        view.addSubview(searchBar)
    }
    
    private func makeConstraints() {
        searchBar.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    
}

// MARK: - UITableView Delegate & DataSource

extension CurrencyPickerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        let currency = viewModel.currency(at: indexPath.row)
        cell.textLabel?.text = currency?.code
        cell.detailTextLabel?.text = currency?.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currency = viewModel.currency(at: indexPath.row)
        onCurrencySelected?(currency)
        dismiss(animated: true)
    }
}

// MARK: - UISearchBar Delegate

extension CurrencyPickerViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterCurrencies(by: searchText)
    }
}
