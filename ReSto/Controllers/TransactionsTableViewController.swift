//
//  TransactionsTableViewController.swift
//  ReSto
//
//  Created by Ivan Ganchev on 14.12.19.
//

import UIKit
import Alamofire

class TransactionsTableViewController: UITableViewController {
    
    var transactions: TransactionList?

    override func viewWillAppear(_ animated: Bool) {
        loadTransactions { [unowned self] in
            self.reloadData()
        }
    }
    
    func loadTransactions(completion: @escaping () -> Void) {
        NetworkManager.getAll(descriptor: "transactions") { [unowned self] json in
            do {
                self.transactions = try TransactionList(json)
            } catch {
                print("Could not parse response")
            }
            completion()
        }
    }
    
    func loadTransaction(id: Int, completion: @escaping () -> Void) {
        NetworkManager.getByID(descriptor: "transaction", byID: id) { json in
            do {
                let transaction = try Transaction(json)
                
                cachedTransactions = cachedTransactions.filter { $0.id != transaction.id }
                cachedTransactions.append(transaction)
            } catch {
                print("Could not parse response")
            }
            completion()
        }
    }
    
    func reloadData() {
        guard let ids = transactions?.ids else { return }
        for id in ids {
            if let indexToReload = cachedTransactions.firstIndex(where: { $0.id == id }) {
                reloadCell(index: indexToReload)
            } else {
                loadTransaction(id: id) { [unowned self] in
                    self.reloadCell(index: ids.firstIndex(of: id)!)
                }
            }
        }
    }
    
    func reloadCell(index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        
        DispatchQueue.main.async { [unowned self] in
            if self.lastItemsInSection == (self.transactions?.ids.count ?? 0) {
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            } else {
                self.tableView.reloadSections([0], with: .automatic)
            }
            
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    var lastItemsInSection = 0

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        lastItemsInSection = transactions?.ids.count ?? 0
        return lastItemsInSection
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "transactionCell", for: indexPath) as! TransactionCell
        
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale(identifier: "de_DE")
        
        if let t = transactions {
            let transaction = cachedTransactions.first(where: {$0.id == t.ids[indexPath.row]})
            
            if let name = transaction?.name, let date = transaction?.date, let sum = transaction?.sum {
                
                
                cell.name.text = name
                
                let dateArr = date.split(separator: " ")
                cell.date.text = String(dateArr[0])
                
                let nextValue = min(next$(a: sum, n: 5), next$(a: sum, n: 10))
                let priceStringSaved = currencyFormatter.string(from:  NSNumber(value: nextValue - sum))
                cell.saved.text = "+\(priceStringSaved ?? "0") (saved)"
                
                let priceStringSum = currencyFormatter.string(from: NSNumber(value: sum))
                cell.sum.text = "-\(priceStringSum ?? "0")"
            }
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func next$(a: Double, n: Double) -> Double {
        return ceil(a/n) * n;
    }
    
    // MARK: - Navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let indexPath = tableView.indexPathForSelectedRow{
//            let transactionID = transactions?.ids[indexPath.row]
//            if let goalVC = segue.destination as? GoalViewController {
//                goalVC.goalID = goalID
//            }
//        }
//    }
}
