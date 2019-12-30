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
        return NavigationLink(destination: TransactionDetail(transaction: transaction)) {
            HStack {
                VStack(alignment: .leading) {
                    Text(transaction.name)
                        .font(.headline)
                        .lineLimit(2)
                    Text(transaction.getDate() ?? "no date")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }.padding(.bottom).padding(.top)
                
                Spacer()
                Divider()
                
                VStack(alignment: .trailing) {
                    Text("- \(transaction.getAmount() ?? "$0")")
                        .foregroundColor(.red)
                        .fontWeight(.thin)
                    
                    Text("saved \(transaction.getSaved() ?? "$0")")
                        .foregroundColor(.green)
                        .fontWeight(.bold)
                }
            }
        }
    }
}
