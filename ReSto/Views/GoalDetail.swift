//
//  GoalView.swift
//  ReSto
//
//  Created by Ivan Ganchev on 15.12.19.
//

import SwiftUI

struct GoalDetail: View {
    let goal: Goal?
    
    var name: String?
    var currentSum: Int?
    var goalSum: Int?
    var percentage: Float?
    var image: UIImage?

    init(goal: Goal?) {
        self.goal = goal
        
        if let name = goal?.name {
            self.name = name
        }
        
        if let goalSum = goal?.goalSum, let currentSum = goal?.currentSum, let image = goal?.image {
            self.currentSum = currentSum
            self.goalSum = goalSum
            self.percentage = Float(currentSum) / Float(goalSum)
            self.image = image
        }
    }
    
    @State var progressBarValue:CGFloat = 0
    
    var body: some View {
        VStack {
            MapView(coordinates: "")
                .edgesIgnoringSafeArea(.top)
                .frame(height: 300)

            CircleImage(image: image, width: 250, height: 250)
                .offset(y: -130)
                .padding(.bottom, -130)
            
            CircleProgressBar(percentage: percentage ?? 0, width: 250, height: 250, lineWidth: 8)
                .offset(y: -260)

            VStack(alignment: .leading) {
                Text(name ?? "Goal name")
                    .font(.headline)
                HStack(alignment: .top) {
                    Text("$\(String(currentSum ?? 0)) of $\(String(goalSum ?? 0))")
                        .font(.title).bold()
                    Spacer()
                    Text("\(Int((percentage ?? 0)*100))%")
                        .font(.title).bold()
                }
            }
            .padding().offset(y: -260)
            
            Button(action: {
                // What to perform
            }) {
                Text("Mark as complete")
                    .fontWeight(.medium)
                    .frame(width: 250, height: 10)
                    .font(.headline)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(40)
                    .foregroundColor(.white)
                    .padding(4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(Color.green, lineWidth: 3))
            }.offset(y: -150).padding(.bottom, 10)
            
            Button(action: {
                // What to perform
            }) {
                Text("Delete")
                    .fontWeight(.medium)
                    .frame(width: 250, height: 10)
                    .font(.headline)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(40)
                    .foregroundColor(.white)
                    .padding(4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(Color.red, lineWidth: 3))
            }.offset(y: -150).padding(.bottom, 10)

            Spacer()
        }
    }
}

struct GoalView_Preview: PreviewProvider {
    static var previews: some View {
        GoalDetail(goal: nil)
    }
}
