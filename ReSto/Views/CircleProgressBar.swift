//
//  ProgressBar.swift
//  ReSto
//
//  Created by Ivan Ganchev on 15.12.19.
//

import SwiftUI

struct CircleProgressBar: View {
    
    let percentage: Float
    
    let width: CGFloat
    let height: CGFloat
    let lineWidth: CGFloat
    
    init(percentage: Float, width: CGFloat, height: CGFloat, lineWidth: CGFloat) {
        self.percentage = percentage
        self.width = width
        self.height = height
        self.lineWidth = lineWidth
    }
    
    @State var spinCircle = false
    
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: CGFloat(percentage))
                .stroke(Color.green, lineWidth: lineWidth)
                .frame(width: width, height: height)
                .rotationEffect(.degrees(spinCircle ? -90 : -270), anchor: .center)
                .animation(Animation.linear(duration: 0.5))
        }
        .onAppear {
            self.spinCircle = true
        }
    }
}
