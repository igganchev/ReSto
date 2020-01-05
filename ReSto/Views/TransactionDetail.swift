//
//  TransactionDetail.swift
//  ReSto
//
//  Created by Ivan Ganchev on 29.12.19.
//

import SwiftUI

struct TransactionDetail: View {
    let transaction: Transaction?
    
    var name: String?
    var date: String?
    var amount: String?
    var card: String?
    var latitude: String?
    var longitude: String?

    init(transaction: Transaction?) {
        self.transaction = transaction
        
        if let name = transaction?.name, let date = transaction?.date, let card = transaction?.card, let latitude = transaction?.latitude, let longitude = transaction?.longitude {
            self.name = name
            self.date = date
            self.card = card
            self.latitude = latitude
            self.longitude = longitude
        }
        
        if let amount = transaction?.sum {
            self.amount = CurrencyFormatter.formatAsEuro(double: amount) ?? "$0"
        }
    }
    
    @State var progressBarValue:CGFloat = 0
    
    var body: some View {
        VStack {
            MapView(latitudeString: latitude, longitudeString: longitude)
                .edgesIgnoringSafeArea(.top)
                .frame(height: 300)

            CircleImage(image: UIImage(named: "placeholder"), width: 250, height: 250)
                .offset(y: -130)
                .padding(.bottom, -130)
            
            CircleProgressBar(percentage: 1, width: 250, height: 250, lineWidth: 8)
                .offset(y: -260)

            VStack(alignment: .leading) {
                Text(name ?? "Transaction name")
                    .font(.headline)
                HStack(alignment: .top) {
                    Text(amount ?? "$0")
                        .font(.title).bold()
                    Spacer()
                    Text(card ?? "*789")
                        .font(.title).bold()
                }
            }
            .padding().offset(y: -260)
            
            Spacer()
        }
    }
}

struct TransactionView_Preview: PreviewProvider {
    static var previews: some View {
        TransactionDetail(transaction: nil)
    }
}

