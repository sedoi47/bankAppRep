//
//  MainController.swift
//  BankApp2
//
//  Created by family Sedykh on 29.04.2023.
//

import Foundation
import SnapKit

final class MainViewController: UIViewController {
    
    private var mainView: MainViewInput = MainView()
    private var mainModel: MainModelInput = MainModel()
    
    override func loadView() {
        super.loadView()
        view = mainView as? UIView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        fetchData()
    }
    
    private func setupDelegates() {
        mainView.output = self
        mainModel.output = self
    }
    
    private func fetchData() {
        if let balance = mainModel.getBalance() {
            mainView.setBalance(balance.balance)
        }
    }
}

extension MainViewController: MainViewOutput {
    
    func putCashMoneyDidTap() {
        showAlert(title: "Пополнить баланс депозита", buttonTitle: "Подтвердить") {
            value in
            if let balance = self.mainModel.getBalance() {
                self.mainModel.updateBalance(balance: balance, value)
            } else {
                self.mainModel.addBalance(value)
            }
        }
    }
    
    func withdrawMoneyFromDeposit() {
        showAlert(title: "Снять деньги с депозита", buttonTitle: "Подтвердить") {
            value in
            if let balance = self.mainModel.getBalance() {
                if !self.mainModel.withDrawMoney(balance: balance, value) {
                    self.showAlertError(title: "Недостаточно средств")
                }
            }
        }
    }
 }

extension MainViewController: MainModelOutput {
    
    func didUpdateBalance(with value: String) {
        mainView.setBalance(value)
    }
}

extension MainViewController {
    func showAlertError(title: String) {
        let ac = UIAlertController(title: title, message: "", preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "Закрыть", style: .cancel)
        
        ac.addAction(cancelButton)
        present(ac, animated: true)
    }
    func showAlert(title: String, buttonTitle: String, submitAction: ((String) -> Void)?) {
        
        let ac = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        ac.addTextField()
        
        let submitButton = UIAlertAction(title: buttonTitle, style: .default) { [weak ac] _ in
            guard let value = ac?.textFields?[0].text else { return }
            submitAction?(value)
        }
        
        
        
        let cancelButton = UIAlertAction(title: "Отменить", style: .cancel)
        
        ac.addAction(submitButton)
        ac.addAction(cancelButton)
        
        present(ac, animated: true)
    }
}

