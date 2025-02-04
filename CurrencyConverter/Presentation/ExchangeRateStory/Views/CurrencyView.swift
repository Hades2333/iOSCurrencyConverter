//
//  CurrencyView.swift
//  CurrencyConverter
//
//  Created by Mikalai Bekliamishchau on 03/02/2025.
//

import UIKit
import SnapKit

protocol CurrencyViewProtocol: AnyObject {
    func selectCurrencyPressed(sender: CurrencyView)
    func didChangeAmount(to amount: Double?) async
}

class CurrencyView: UIView {
    var currency: CurrencyModel {
        didSet {
            currencyLabel.text = currency.code
            Task {
                await currencyImageView.setFlagImage(by: currency.countryCode)
            }
        }
    }
    weak var delegate: CurrencyViewProtocol?

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .lightGray.withAlphaComponent(0.7)
        return label
    }()
    
    private lazy var currencyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var dropdownImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down")
        imageView.tintColor = .lightGray
        return imageView
    }()
    
    private lazy var currencyLabel: UILabel = {
        let label = UILabel()
        label.text = currency.name
        label.font = .monospacedSystemFont(ofSize: 18, weight: .semibold)
        label.textColor = .darkGray
        return label
    }()
    
    private lazy var amountTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 4
        textField.backgroundColor = .lightGray.withAlphaComponent(0.3)
        textField.textColor = .black
        textField.setPadding(left: 10, right: 10)
        textField.textAlignment = .right
        textField.keyboardType = .decimalPad
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return textField
    }()
    
    private lazy var selectCurrencyButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(selectCurrencyPressed), for: .touchUpInside)
        return button
    }()
    
    init(currency: CurrencyModel = CurrencyModel(name: "", code: "", country: "", countryCode: "")) {
        self.currency = currency
        super.init(frame: .zero)
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(titleLabel)
        addSubview(currencyImageView)
        addSubview(currencyLabel)
        addSubview(amountTextField)
        addSubview(selectCurrencyButton)
        addSubview(dropdownImageView)
    }
    
    private func makeConstraints() {
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(20)
            $0.top.equalTo(20)
        }
        
        currencyImageView.snp.makeConstraints {
            $0.left.equalTo(20)
            $0.top.equalTo(titleLabel.snp.bottom).offset(14)
            $0.width.equalTo(60)
            $0.height.equalTo(40)
        }
        
        currencyLabel.snp.makeConstraints {
            $0.left.equalTo(currencyImageView.snp.right).offset(14)
            $0.centerY.equalTo(currencyImageView)
            $0.width.equalTo(40)
        }
        
        dropdownImageView.snp.makeConstraints {
            $0.width.equalTo(16)
            $0.height.equalTo(20)
            $0.left.equalTo(currencyLabel.snp.right)
            $0.centerY.equalTo(currencyLabel)
        }
        
        selectCurrencyButton.snp.makeConstraints {
            $0.left.equalTo(currencyImageView.snp.left)
            $0.right.equalTo(dropdownImageView.snp.right)
            $0.height.equalTo(currencyImageView.snp.height)
            $0.centerY.equalTo(currencyImageView)
        }
        
        amountTextField.snp.makeConstraints {
            $0.height.equalTo(45)
            $0.left.equalTo(dropdownImageView.snp.right).offset(16)
            $0.right.equalToSuperview().offset(-20)
            $0.centerY.equalTo(currencyLabel)
        }
    }
    
    @objc private func selectCurrencyPressed() {
        self.delegate?.selectCurrencyPressed(sender: self)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text, let value = Double(text) else {
            Task {
                await delegate?.didChangeAmount(to: nil)
            }
            return
        }
        Task {
            await delegate?.didChangeAmount(to: value)
        }
    }
    
    func setTitle(_ title:String) {
        titleLabel.text = title
    }
    
    func setAmount(_ amount: String) {
        amountTextField.text = amount
    }
    
    func getAmount() -> Double {
        return Double(amountTextField.text ?? "") ?? 0
    }
    
    func disableInput() {
        amountTextField.isUserInteractionEnabled = false
    }
}

extension CurrencyView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let allowedCharacters = CharacterSet(charactersIn: "0123456789.,")
        if string.rangeOfCharacter(from: allowedCharacters.inverted) != nil {
            return false
        }
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        let decimalSeparators = [".", ","]
        
        for separator in decimalSeparators {
            if newText.components(separatedBy: separator).count > 2 {
                return false
            }
        }
        
        if string == "," {
            textField.text = textField.text! + "."
            return false
        }
        return true
   }
}
