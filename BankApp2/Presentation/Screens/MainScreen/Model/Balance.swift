//
//  Balance.swift
//  BankApp2
//
//  Created by family Sedykh on 01.05.2023.
//

import Foundation
import RealmSwift

class Balance: Object {
    
    @Persisted var balance: String
    
    convenience init(balance: String) {
        self.init()
        self.balance = balance
    }
}
