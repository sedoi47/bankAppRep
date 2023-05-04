//
//  MainModel.swift
//  BankApp2
//
//  Created by family Sedykh on 29.04.2023.
//

import Foundation
import RealmSwift

protocol MainModelInput {
    var output: MainModelOutput? { get set }
    func addBalance(_ value: String)
    func getBalance() -> Balance?
    func updateBalance(balance: Balance, _ value: String)
    func withDrawMoney(balance: Balance, _ value: String) -> Bool
}

protocol MainModelOutput: AnyObject {
    func didUpdateBalance(with value: String)
}

final class MainModel: MainModelInput {
    
    weak var output: MainModelOutput?
    
    private let realm = try! Realm()
    
    func addBalance(_ value: String) {
        let newBalance = Balance(balance: value)
        try! realm.write {
            realm.add(newBalance)
        }
        output?.didUpdateBalance(with: value)
    }
    
    func getBalance() -> Balance? {
        let balance = realm.objects(Balance.self)
        return balance.first
    }
    
    func updateBalance(balance: Balance, _ value: String) {
        
        guard let oldBalance = Double(balance.balance),
              let newValue = Double(value) else { return }
        
        let newBalance = String(oldBalance + newValue)
        
        try! realm.write {
            balance.balance = newBalance
        }
        
        output?.didUpdateBalance(with: newBalance)
    }
    
    func withDrawMoney(balance: Balance, _ value: String) -> Bool {
        
        guard let oldBalance = Double(balance.balance),
              let newValue = Double(value) else { return false }
        
        if oldBalance < newValue {
            return false
        }
       
        let newBalance = String(oldBalance - newValue)
        try! realm.write {
            balance.balance = newBalance
        }
        output?.didUpdateBalance(with: newBalance)
        return true
    }
}
