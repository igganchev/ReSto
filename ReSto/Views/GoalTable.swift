//
//  GoalTable.swift
//  ReSto
//
//  Created by Ivan Ganchev on 29.12.19.
//

import SwiftUI

struct GoalTable: View {
    var goals: [Goal] = []
    
    var body: some View {
        NavigationView {
            List(goals) { goal in
                GoalCell(goal: goal)
            }.navigationBarTitle(Text("Goals"))
        }
    }
}

struct GoalTable_Previews: PreviewProvider {
    static var previews: some View {
        GoalTable()
    }
}

struct GoalCell : View {
    let goal: Goal
    
    var body: some View {
        return NavigationLink(destination: GoalView(goal: goal)) {
            TableCircleImage(image: goal.image, width: 100, height: 100)
            
            CircleProgressBar(percentage: Float(goal.currentSum) / Float(goal.goalSum), width: 100, height: 100, lineWidth: 5).offset(x: -108).padding(.trailing, -95)
            
            VStack(alignment: .leading) {
                Text(goal.name)
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .padding(.bottom)
                    .lineLimit(1)
                Text(String("$\(String(goal.currentSum)) / $\(String(goal.goalSum))"))
                    .font(.headline)
                    .fontWeight(.black)
                    .foregroundColor(.primary)
                    .lineLimit(2)
            }.layoutPriority(100)
            
            Spacer()
                    
            VStack(alignment: .trailing) {
                Text("\(String(Int(Float(goal.currentSum) / Float(goal.goalSum)*100)))%")
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
        }
    }
}
