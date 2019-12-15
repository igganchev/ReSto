//
//  CircleImage.swift
//  ReSto
//
//  Created by Ivan Ganchev on 15.12.19.
//

import SwiftUI

struct CircleImage: View {
    let image: Image
    let size: CGSize
    
    init(image: UIImage?) {
        if let image = image {
            self.image = Image(uiImage: image)
            self.size = image.size
        } else {
            self.image = Image("placeholder")
            self.size = CGSize()
        }
    }
    
    var body: some View {
        let aspect = size.width / size.height
        
        let img = image.resizable()
            .aspectRatio(aspect, contentMode: .fill)
            .frame(width: 250, height: 250)
            .clipShape(Circle())
            .overlay(
                Circle().stroke(Color.white, lineWidth: 4))
            .shadow(radius: 10)
        return img
    }
}

struct CircleImage_Preview: PreviewProvider {
    static var previews: some View {
        CircleImage(image: nil)
    }
}
