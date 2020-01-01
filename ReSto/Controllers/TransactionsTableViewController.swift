//
//  TransactionsTableViewController.swift
//  ReSto
//
//  Created by Ivan Ganchev on 14.12.19.
//

import Alamofire
import SwiftUI

class TransactionsTableViewController: UIHostingController<TransactionTable> {
    
    let dispatchGroup = DispatchGroup()
    
    var transactionList: TransactionList?
    var transactions: [Transaction] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: TransactionTable())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        loadData()
    }
    
    func loadTransactions(completion: @escaping () -> Void) {
        NetworkManager.getAll(descriptor: "transactions") { [weak self] json in
            do {
                self?.transactionList = try TransactionList(json)
            } catch {
                print("Could not parse response")
            }
            completion()
        }
    }
    
    func loadTransaction(id: Int) {
        dispatchGroup.enter()
        
        NetworkManager.getByID(descriptor: "transaction", byID: id) { [weak self] json in
            do {
                let transaction = try Transaction(json)
                
                cachedTransactions = cachedTransactions.filter { $0.id != transaction.id }
                cachedTransactions.append(transaction)
                
                self?.transactions.append(transaction)
                
                
                NetworkManager.getAll(descriptor: "savedtransactionids") { [weak self] (json) in
                    let savedTransactionIDs = self?.extractSavedTransactionIDs(from: json)
                    if !(savedTransactionIDs?.contains(transaction.id))! {
                        self?.addSaved(transaction: transaction)
                    }
                }
                
                self?.dispatchGroup.leave()
            } catch {
                print(error)
            }
        }
    }
    
    func loadData() {
        loadTransactions { [weak self] in
            if let transactionList = self?.transactionList {
                if let transactions = self?.transactions, transactionList.ids.containsSameElements(as: transactions.map {$0.id}) {
                    self?.rootView = TransactionTable(transactions: transactions)
                } else if let transactions = self?.transactions {
                    let difference = transactionList.ids.difference(from: transactions.map {$0.id})
                    
                    for transactionID in difference {
                        self?.loadTransaction(id: transactionID)
                    }
                    
                    self?.dispatchGroup.notify(queue: .main) { [weak self] in
                        if let transactions = self?.transactions {
                            self?.rootView = TransactionTable(transactions: transactions)
                        }
                    }
                } else {
                    self?.transactions = []
                    
                    for transactionID in transactionList.ids {
                        self?.loadTransaction(id: transactionID)
                    }
                    
                    self?.dispatchGroup.notify(queue: .main) { [weak self] in
                        if let transactions = self?.transactions {
                            self?.rootView = TransactionTable(transactions: transactions)
                        }
                    }
                }
            }
        }
    }
    
    func addSaved(transaction: Transaction) {
        let saved = transaction.next$(a: transaction.sum, n: 5) - transaction.sum
        NetworkManager.add(descriptor: "addsaved", parameters: ["saved": saved, "transactionID": transaction.id]) {_ in }
        savedChanged = true
    }
    
    func extractSavedTransactionIDs(from json: String) -> [Int] {
        if let data = json.data(using: .utf8) {
            do {
                let myJson = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as Any
                
                if let dict = myJson as? [[String: Int]] {
                    return dict.map {($0.first?.value ?? 0)}
                }
            } catch {
                print(error)
            }
        }
        
        return [Int]()
    }
}
