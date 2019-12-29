//
//  TransactionTable.swift
//  ReSto
//
//  Created by Ivan Ganchev on 29.12.19.
//

import SwiftUI

struct TransactionTable: View {
    var transactions: [Transaction] = []
    
    var body: some View {
        NavigationView {
            List(transactions) { transaction in
                TransactionCell(transaction: transaction)
            }.navigationBarTitle(Text("Transactions"))
        }
    }
}

struct TransactionTable_Previews: PreviewProvider {
    static var previews: some View {
        TransactionTable()
    }
}

struct TransactionCell : View {
    let transaction: Transaction
    var body: some View {
        return NavigationLink(destination: TransactionDetail(name: transaction.name, date: transaction.date, sum: String(transaction.sum))) {
                VStack(alignment: .leading) {
                    Text(transaction.name)
                    Text(transaction.date)
                        .font(.subheadline)
                }
        }
    }
}
