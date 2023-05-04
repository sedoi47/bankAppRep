//
//  MainView.swift
//  BankApp2
//
//  Created by family Sedykh on 29.04.2023.
//

import Foundation
import UIKit
import SnapKit

protocol MainViewInput {
    var output: MainViewOutput? { get set }
    func setBalance(_ value: String)
}

protocol MainViewOutput: AnyObject {
    func putCashMoneyDidTap()
    func withdrawMoneyFromDeposit()
}

final class MainView: UIView {
    
    weak var output: MainViewOutput?
    
    private let balanceLabel: UILabel = {
        let label = UILabel()
        label.text = "0.00 ₽"
        label.font = .systemFont(ofSize: 48, weight: .bold)
        label.textAlignment = .center
        
     
        return label
    }()
    
    private lazy var withdrawMoneyButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("Снять деньги с депозита", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .green
        button.layer.cornerRadius = 16
        button.titleLabel?.font = .systemFont(ofSize: 25)
        button.addTarget(self, action: #selector (withdrawMoney), for: .touchUpInside)
        return button
    }()
    
    private lazy var putMoneyFromCashButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("Пополнить баланс наличными", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .green
        button.layer.cornerRadius = 16
        button.titleLabel?.font = .systemFont(ofSize: 25)
        button.addTarget(self, action: #selector(putCashMoney), for: .touchUpInside)
        return button
    }()
    
    private lazy var putMoneyOnPhoneButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("Пополнить баланс телефона", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .green
        button.layer.cornerRadius = 16
        button.titleLabel?.font = .systemFont(ofSize: 25)
        return button
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [withdrawMoneyButton, putMoneyFromCashButton, putMoneyOnPhoneButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }
    
    private func setupLayout() {
        
        backgroundColor = .white
        
        addSubview(balanceLabel)
        addSubview(buttonsStackView)
        
        balanceLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leadingMargin.equalToSuperview().offset(10)
            make.topMargin.equalToSuperview().offset(140)
            
        }
        
        buttonsStackView.snp.makeConstraints { make in
            make.top.equalTo(balanceLabel.snp.bottom).offset(140)
            make.leadingMargin.trailingMargin.equalToSuperview()
            make.height.equalTo(124)
        }
    }
    
    @objc private func putCashMoney() {
        output?.putCashMoneyDidTap()
    }
    
    @objc private func withdrawMoney() {
        output?.withdrawMoneyFromDeposit()
    }
}

extension MainView: MainViewInput {
    
    func setBalance(_ value: String) {
        balanceLabel.text = value
    }
}
