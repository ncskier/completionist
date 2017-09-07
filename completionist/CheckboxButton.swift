//
//  CheckboxButton.swift
//  completionist
//
//  Created by Brandon Walker on 7/21/16.
//  Copyright © 2016 Brandon Walker. All rights reserved.
//

import UIKit

class CheckboxButton: UIButton {
    
    let circleColor: UIColor = UIColor(red: 0.041, green: 0.920, blue: 0.000, alpha: 1.00)
    let checkColor: UIColor = UIColor.white
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        // Draw Circle
        let circleLineWidth: CGFloat = 2
        let circleDiameter: CGFloat = frame.width - 2*circleLineWidth
        let circleBoundingRect: CGRect = CGRect(x: rect.midX-circleDiameter/2, y: rect.midY-circleDiameter/2, width: circleDiameter, height: circleDiameter)
        
        let circlePath = UIBezierPath(ovalIn: circleBoundingRect)
        circlePath.lineWidth = circleLineWidth
        
        // Set stroke color
        circleColor.setStroke()
        
        // Draw Circle
        circlePath.stroke()
        
        // Draw Checkmark
        if (state == UIControlState.selected) {
            let checkmarkLineWidth: CGFloat = circleLineWidth
            
            let checkmarkPath = UIBezierPath()
            checkmarkPath.lineWidth = checkmarkLineWidth
            
            checkmarkPath.move(to: CGPoint(
                x: circleBoundingRect.minX + circleDiameter/4,
                y: circleBoundingRect.minY + circleDiameter*(7/12)))
            
            checkmarkPath.addLine(to: CGPoint(
                x: circleBoundingRect.minX + circleDiameter/2,
                y: circleBoundingRect.minY + circleDiameter*(3/4)))
            
            checkmarkPath.addLine(to: CGPoint(
                x: circleBoundingRect.minX + circleDiameter*(3/4),
                y: circleBoundingRect.minY + circleDiameter*(1/4)))
            
            // Set colors
            circleColor.setFill()
            checkColor.setStroke()
            
            // Draw
            circlePath.fill()
            checkmarkPath.stroke()
        }
        
    }
 
    
}
