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
        print("here")
        saved = 15
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
                self?.dispatchGroup.leave()
            } catch {
                print("Could not parse response")
            }
        }
    }
    
    func loadData() {
        loadTransactions { [weak self] in
            if let transactionList = self?.transactionList {
                if let transactions = self?.transactions, transactionList.ids.containsSameElements(as: transactions.map {$0.id}) {
                    self?.rootView = TransactionTable(transactions: transactions)
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
}
