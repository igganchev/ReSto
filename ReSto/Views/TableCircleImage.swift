//
//  TableCircleImage.swift
//  ReSto
//
//  Created by Ivan Ganchev on 29.12.19.
//

import SwiftUI

struct TableCircleImage: View {
    let image: Image
    let size: CGSize
    
    let width: CGFloat
    let height: CGFloat
    
    init(image: UIImage?, width: CGFloat, height: CGFloat) {
        if let image = image {
            self.image = Image(uiImage: image)
            self.size = image.size
        } else {
            self.image = Image("placeholder")
            self.size = CGSize()
        }
        
        self.width = width
        self.height = height
    }
    
    var body: some View {
        let aspect = size.width / size.height
        
        let img = image.resizable()
            .aspectRatio(aspect, contentMode: .fill)
            .frame(width: width, height: height)
            .clipShape(Circle())
            .overlay(
                Circle().stroke(Color.white, lineWidth: 2.5))
            .shadow(radius: 3)
        return img
    }
}

struct TableCircleImage_Preview: PreviewProvider {
    static var previews: some View {
        TableCircleImage(image: nil, width: 80, height: 80)
    }
}


