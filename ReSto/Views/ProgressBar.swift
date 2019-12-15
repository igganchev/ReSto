//
//  ProgressBar.swift
//  ReSto
//
//  Created by Ivan Ganchev on 15.12.19.
//

import SwiftUI

struct ProgressBar: View {
    
    let percentage: Float
    
    init(percentage: Float) {
        self.percentage = percentage
    }
    
    @State var spinCircle = false
    
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: CGFloat(percentage))
                .stroke(Color.green, lineWidth: 8)
                .frame(width: 250, height: 250)
                .rotationEffect(.degrees(spinCircle ? -90 : -270), anchor: .center)
                .animation(Animation.linear(duration: 0.5))
        }
        .onAppear {
            self.spinCircle = true
        }
    }
}
