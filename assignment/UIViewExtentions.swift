//
//  UIViewExtentions.swift
//  assignment
//
//  Created by Paul Lau on 9/1/2022.
//

import UIKit

@IBDesignable extension UIView {
    @IBInspectable var shadowRadius: CGFloat {
        get { return layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }
    @IBInspectable var shadowOffset : CGSize{
        get { return layer.shadowOffset }
        set{ layer.shadowOffset = newValue }
    }
    @IBInspectable var shadowColor : UIColor{
        get { return UIColor.init(cgColor: layer.shadowColor!) }
        set { layer.shadowColor = newValue.cgColor }
    }
    @IBInspectable var shadowOpacity : Float {
        get { return layer.shadowOpacity }
        set { layer.shadowOpacity = newValue }
    }
}
