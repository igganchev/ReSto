//
//  RectangleImage.swift
//  ReSto
//
//  Created by Ivan Ganchev on 30.12.19.
//

import SwiftUI

struct RectangleImage: View {
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
            .clipShape(Rectangle())
            .shadow(radius: 10)
        return img
    }
}

struct RectangleImage_Preview: PreviewProvider {
    static var previews: some View {
        RectangleImage(image: nil, width: 250, height: 250)
    }
}

