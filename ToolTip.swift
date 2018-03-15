//
//  ToolTip.swift
//  
//
//  Created by Jennifer Diederich on 3/15/18.
//

import UIKit
import CAShapeLayer

class ToolTip: UIView, NSObject {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    
    @IBInspectable var arrowTopLeft: Bool = false
    @IBInspectable var arrowTopCenter: Bool = true
    @IBInspectable var arrowTopRight: Bool = false
    @IBInspectable var arrowBottomLeft: Bool = false
    @IBInspectable var arrowBottomCenter: Bool = false
    @IBInspectable var arrowBottomRight: Bool = false
    
    @IBInspectable var fillColor: UIColor = UIColor.white
    
    @IBInspectable var borderColor: UIColor = UIColor(red:0, green:0, blue:0, alpha:0.05)
    @IBInspectable var borderRadius: CGFloat = 18
    @IBInspectable var borderWidth: CGFloat = 1
    
    @IBInspectable var shadowColor: UIColor = UIColor(red:0, green:0, blue:0, alpha:0.14)
    @IBInspectable var shadowOffsetX: CGFloat = 0
    @IBInspectable var shadowOffsetY: CGFloat = 2
    @IBInspectable var shadowBlur: CGFloat = 10
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    // Define Bubble Shape
    let bubblePath = UIBezierPath()
    
    // Top left corner
    bubblePath.move(to: topLeft(0, borderRadius))
    bubblePath.addCurve(to: topLeft(borderRadius, 0), controlPoint1: topLeft(0, borderRadius / 2), controlPoint2: topLeft(borderRadius / 2, 0))
    
    // Top right corner
    bubblePath.addLine(to: topRight(borderRadius, 0))
    bubblePath.addCurve(to: topRight(0, borderRadius), controlPoint1: topRight(borderRadius / 2, 0), controlPoint2: topRight(0, borderRadius / 2))
    
    // Bottom right corner
    bubblePath.addLine(to: bottomRight(0, borderRadius))
    bubblePath.addCurve(to: bottomRight(borderRadius, 0), controlPoint1: bottomRight(0, borderRadius / 2), controlPoint2: bottomRight(borderRadius / 2, 0))
    
    // Bottom left corner
    bubblePath.addLine(to: bottomLeft(borderRadius, 0))
    bubblePath.addCurve(to: bottomLeft(0, borderRadius), controlPoint1: bottomLeft(borderRadius / 2, 0), controlPoint2: bottomLeft(0, borderRadius / 2))
    bubblePath.close()
    
    // Shadow Layer
    let shadowShape = CAShapeLayer()
    shadowShape.path = bubblePath.cgPath
    shadowShape.fillColor = fillColor.cgColor
    shadowShape.shadowColor = shadowColor.cgColor
    shadowShape.shadowOffset = CGSize(width: CGFloat(shadowOffsetX), height: CGFloat(shadowOffsetY))
    shadowShape.shadowRadius = CGFloat(shadowBlur)
    shadowShape.shadowOpacity = 0.8
    
    // Border Layer
    let borderShape = CAShapeLayer()
    borderShape.path = bubblePath.cgPath
    borderShape.fillColor = fillColor.cgColor
    borderShape.strokeColor = borderColor.cgColor
    borderShape.lineWidth = CGFloat(borderWidth*2)
    
    // Fill Layer
    let fillShape = CAShapeLayer()
    fillShape.path = bubblePath.cgPath
    fillShape.fillColor = fillColor.cgColor
    
    // Add Sublayers
    self.layer.insertSublayer(shadowShape, at: 0)
    self.layer.insertSublayer(borderShape, at: 0)
    self.layer.insertSublayer(fillShape, at: 0)
    view.raw
        
    }
}
