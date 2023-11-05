//
//  ViewController.swift
//  Swift_SRP
//
//  Created by Shivyan System on 05/11/23.
//

import UIKit
import Foundation

/*
 1.Each class should encapsulate a single functionality or aspect of the application,
 such as data management, business logic, or user interface interactions.
 2. Avoid "kitchen sink" classes that try to do too much and violate the SRP by having multiple responsibilities.
 3. When a class adheres to SRP, it's more testable, as each responsibility can be tested in isolation.
 4. SRP helps in collaboration among team members by providing clear roles and responsibilities for each class.
 */


//The ViewController handles user interactions and updates the UI based on the ViewModel.

class ViewController: UIViewController {
    var sourceAccountViewModel: BankAccountViewModel!
    var destinationAccountViewModel: BankAccountViewModel!
    
    let transferService = TransferService()
    
    @IBOutlet weak var sourceAccountBalanceLabel: UILabel!
    @IBOutlet weak var destinationAccountBalanceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create source and destination accounts with initial balances
        let sourceAccount = BankAccount(initialBalance: 1000.0)
        let destinationAccount = BankAccount(initialBalance: 500.0)
        
        // Create ViewModels for the accounts
        sourceAccountViewModel = BankAccountViewModel(account: sourceAccount)
        destinationAccountViewModel = BankAccountViewModel(account: destinationAccount)
        
        // Deposit and withdraw through the ViewModels
        sourceAccountViewModel.deposit(amount: 200.0)

        print("Source account balance after depoist:=>   \(sourceAccountViewModel.accountBalance)")
        print("Destination account initial balance:=>  \(destinationAccountViewModel.accountBalance)")

        sourceAccountViewModel.withdraw(amount: 100.0)
        print("Source account balance after withdraw:=> \(sourceAccountViewModel.accountBalance)")

        
        // Transfer money through the TransferService
        let transferAmount = 200.0
        transferService.transfer(from: sourceAccount, to: destinationAccount, amount: transferAmount)
        
        print("Source bank account balance after transffer:=> \(sourceAccountViewModel.accountBalance)")
        print("Destination bank account aalance after deposit:=> \(destinationAccountViewModel.accountBalance)")

    }
    
    //This class represent multiple responsibilities within a single class.
    //Managing account balance.
    //Handling deposits and withdrawals.
    //Facilitating money transfers between accounts.
    //Generating and displaying account statements.
    
    class Bank {
        var balance: Double
        
        init(initialBalance: Double) {
            self.balance = initialBalance
        }
        
        func deposit(amount: Double) {
            // Deposit money into the account
            balance += amount
        }
        
        func withdraw(amount: Double) {
            // Withdraw money from the account
            balance -= amount
        }
        
        func transfer(to account: Bank, amount: Double) {
            // Transfer money from this account to another account
            if balance >= amount {
                balance -= amount
                account.balance += amount
            }
        }
        
        func getAccountStatement() {
            // Retrieve and display the account statement
            print("Account Balance: $\(balance)")
            // ... other statement details
        }
    }
    
    // BankAccount.swift
    // BankAccount class complies with the Single Responsibility Principle (SRP)
    // by managing individual bank account data and transactions.
    
    class BankAccount {
        var balance: Double
        
        init(initialBalance: Double) {
            self.balance = initialBalance
        }
        
        func deposit(amount: Double) {
            balance = balance + amount
        }
        
        func withdraw(amount: Double) {
            balance = balance - amount
        }
    }
    
    //TransferService.swift
    //Demonstrates adherence to SRP by exclusively handling fund transfers between accounts.
    class TransferService {
        func transfer(from sourceAccount: BankAccount, to destinationAccount: BankAccount, amount: Double) {
            if sourceAccount.balance >= amount {
                sourceAccount.withdraw(amount: amount)
                destinationAccount.deposit(amount: amount)
            }
        }
    }
    
    // BankAccountViewModel.swift
    //Functions as an intermediary between the BankAccount model and the `ViewController.
    struct BankAccountViewModel {
        private var account: BankAccount
        
        init(account: BankAccount) {
            self.account = account
        }
        
        var accountBalance: String {
            return "$\(account.balance)"
        }
        
        mutating func deposit(amount: Double) {
            account.deposit(amount: amount)
        }
        
        mutating func withdraw(amount: Double) {
            account.withdraw(amount: amount)
        }
        
        func getAccountStatement() {
            // Retrieve and display the account statement
            print("Account Balance: $\(account.balance)")
            // ... other statement details
        }
    }
}
