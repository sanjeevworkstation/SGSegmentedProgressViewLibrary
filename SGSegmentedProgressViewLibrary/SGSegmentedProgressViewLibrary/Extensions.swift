//
//  Extensions.swift
//  SGSegmentedProgressViewLibrary
//
//  Created by Sanjeev Gautam on 07/11/20.
//

import Foundation
import UIKit

extension UIView {
    func borderAndCorner(cornerRadious: CGFloat, borderWidth: CGFloat, borderColor: UIColor?) {
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadious
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor?.cgColor
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
