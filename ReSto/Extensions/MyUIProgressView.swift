//
//  MyUIProgressView.swift
//  ReSto
//
//  Created by Ivan Ganchev on 15.12.19.
//

import UIKit

class MyUIProgressView: UIProgressView {
    override func layoutSubviews() {
        super.layoutSubviews()

        let maskLayerPath = UIBezierPath(roundedRect: bounds, cornerRadius: 4.0)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskLayerPath.cgPath
        layer.mask = maskLayer
    }
}
