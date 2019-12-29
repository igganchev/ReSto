//
//  TransactionDetail.swift
//  ReSto
//
//  Created by Ivan Ganchev on 29.12.19.
//

import SwiftUI

struct TransactionDetail: View {
    var name: String
    var date: String
    var sum: String
    
    var body: some View {
        VStack {
            Image(name)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color.orange, lineWidth: 4)
            )
                .shadow(radius: 10)
            Text(name)
                .font(.title)
            Text(date)
                .font(.subheadline)
            Divider()
            Text(sum)
                .font(.headline)
                .multilineTextAlignment(.center)
                .lineLimit(50)
        }.padding().navigationBarTitle(Text(name), displayMode: .inline)
    }
}

struct TransactionDetail_Previews: PreviewProvider {
    static var previews: some View {
        TransactionDetail(name: "Transaction", date: "12.12.2019", sum: "15")
    }
}
