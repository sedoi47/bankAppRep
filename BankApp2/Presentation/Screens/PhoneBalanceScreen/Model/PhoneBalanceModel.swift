//
//  PhoneBalanceModel.swift
//  BankApp2
//
//  Created by family Sedykh on 02.05.2023.
//

import Foundation
import RealmSwift

class PhoneBalance: Object {
    
    @Persisted var balance: String
    
    convenience init(balance: String) {
        self.init()
        self.balance = balance
    }
}

protocol PhoneBalanceModelInput {
    var output: PhoneBalanceModelOutput? { get set }
    func addBalance(_ value: String)
    func getBalance() -> PhoneBalance?
    func updateBalance(balance: PhoneBalance, _ value: String)
//    func withDrawMoney(balance: PhoneBalance, _ value: String) -> Bool
}

protocol PhoneBalanceModelOutput: AnyObject {
    func didUpdateBalance(with value: String)
}

final class PhoneBalanceModel: PhoneBalanceModelInput {
    
    weak var output: PhoneBalanceModelOutput?
    
    private let realm = try! Realm()
    
    func addBalance(_ value: String) {
        let newBalance = PhoneBalance(balance: value)
        try! realm.write {
            realm.add(newBalance)
        }
        output?.didUpdateBalance(with: value)
    }
    
    func getBalance() -> PhoneBalance? {
        let balance = realm.objects(PhoneBalance.self)
        return balance.first
    }
    
    func updateBalance(balance: PhoneBalance, _ value: String) {
        
        guard let oldBalance = Double(balance.balance),
              let newValue = Double(value) else { return }
        
        let newBalance = String(oldBalance + newValue)
        
        try! realm.write {
            balance.balance = newBalance
        }
        
        output?.didUpdateBalance(with: newBalance)
    }
    
//    func withDrawMoney(balance: PhoneBalance, _ value: String) -> Bool {
//
//        guard let oldBalance = Double(balance.balance),
//              let newValue = Double(value) else { return false }
//
//        if oldBalance < newValue {
//            return false
//        }
//
//        let newBalance = String(oldBalance - newValue)
//        try! realm.write {
//            balance.balance = newBalance
//        }
//        output?.didUpdateBalance(with: newBalance)
//        return true
//    }
}
