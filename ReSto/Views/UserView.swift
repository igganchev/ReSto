//
//  UserView.swift
//  ReSto
//
//  Created by Ivan Ganchev on 30.12.19.
//

import SwiftUI

struct UserView: View {
    let user: User?
    
    var name: String?
    @State var frequency = 0
    @State var roundingUp = 0
    var savedTotal: String?
    var numberOfTransactions: String?
    var image: UIImage?
    
    init(user: User?) {
        self.user = user
        
        if let name = user?.name, let frequency = user?.frequency, let roundingUp = user?.roundingUp, let numberOfTransactions = user?.numberOfTransactions, let image = user?.image {
            self.name = name
            self._frequency = State(initialValue: frequency)
            self._roundingUp = State(initialValue: roundingUp)
            self.numberOfTransactions = String(numberOfTransactions)
            self.image = image
        }
        
        if let savedTotal = user?.savedTotal {
            self.savedTotal = CurrencyFormatter.formatAsEuro(double: savedTotal) ?? "$0"
        }
    }
    
    var frequencyOptions = ["Daily", "Weekly", "Monthly"]
    var roundingUpOptions = ["1", "5", "10"]
    
    var body: some View {
        VStack {
            CircleImage(image: image, width: 120, height: 120).padding(.top)
            
            VStack(alignment: .center) {
                Text(name ?? "First Last")
                    .font(.title)
                    .fontWeight(.bold)
                Text("planins@gmail.com")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .fontWeight(.light)
                
                Divider()
                
                HStack(alignment: .center) {
                    VStack(alignment: .leading) {
                        
                        VStack(alignment: .leading) {
                            Text("Total amount of money saved:")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            Text(savedTotal ?? "$0")
                                .font(.title)
                                .fontWeight(.black)
                                .foregroundColor(.primary)
                                .lineLimit(3)
                        }.padding(.bottom, 35)
                        
                        VStack(alignment: .leading) {
                            Text("Total number of transactions:")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            Text(numberOfTransactions ?? "0")
                                .font(.title)
                                .fontWeight(.black)
                                .foregroundColor(.primary)
                                .lineLimit(3)
                        }
                    }
                    
                    Spacer()
                    Divider()
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        
                        VStack(alignment: .leading) {
                            Text("Rounding-up to:")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            Picker(selection: $roundingUp, label: Text("")) {
                                ForEach(0 ..< roundingUpOptions.count) {
                                    Text(self.roundingUpOptions[$0])
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle()).padding(.bottom, 35)
                            .onReceive([self.roundingUp].publisher.first()) { (value) in
                                NetworkManager.add(descriptor: "addsettings", parameters: ["frequency": self.frequency, "roundingUp": value]) {_ in }
                                NetworkManager.loadUser()
                            }
                            
                            Text("Payout frequency:")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            Picker(selection: $frequency, label: Text("")) {
                                ForEach(0 ..< frequencyOptions.count) {
                                    Text(self.frequencyOptions[$0])
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .onReceive([self.frequency].publisher.first()) { (value) in
                                NetworkManager.add(descriptor: "addsettings", parameters: ["frequency": value, "roundingUp": self.roundingUp]) {_ in }
                                NetworkManager.loadUser()
                            }
                        }
                    }
                }.padding()
            }.padding()
            
            Spacer()
        }.navigationBarTitle("Profile")
    }
}

struct UserView_Preview: PreviewProvider {
    static var previews: some View {
        UserView(user: nil)
    }
}

