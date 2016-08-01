//
//  ActivityCompletionBarView.swift
//  completionist
//
//  Created by Brandon Walker on 7/25/16.
//  Copyright © 2016 Brandon Walker. All rights reserved.
//

import UIKit

class ActivityCompletionBarView: UIView {
    
    var progress: Float = 0.0
    var completionView =  UIView()
    var gradientLayer = CAGradientLayer()
    var cornerRadius: CGFloat = 5.0
    
    var grayBackgroundColor = UIColor(red: 0.900, green: 0.900, blue: 0.900, alpha: 1.000)
    
    func setupView() {
        // Outline
        layer.borderWidth = 0.3
        layer.cornerRadius = cornerRadius
        
        // Background
        backgroundColor = UIColor(red: 0.900, green: 0.900, blue: 0.900, alpha: 1.000)
        backgroundColor = UIColor.whiteColor()
//        backgroundColor = UIColor(red: 0.980, green: 0.980, blue: 0.980, alpha: 1.000)
//        backgroundColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0)
        
        // Completion View
        completionView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: frame.height))
        completionView.backgroundColor = UIColor(red: 0.041, green: 0.920, blue: 0.000, alpha: 1.000)
        completionView.backgroundColor = UIColor.clearColor()
        addSubview(completionView)
        
        
        // Gradient
//        gradientLayer.cornerRadius = 5.5
        updateGradientLayer()
        let color1 = UIColor(red: 0.035, green: 0.781, blue: 0.004, alpha: 1.000).CGColor as CGColorRef
//        let color1 = UIColor(red: 0.036, green: 0.799, blue: 0.004, alpha: 1.000).CGColor as CGColorRef
//        let color1 = UIColor(red: 0.037, green: 0.827, blue: 0.004, alpha: 1.000).CGColor as CGColorRef
        let color2 = UIColor(red: 0.041, green: 0.920, blue: 0.000, alpha: 1.000).CGColor as CGColorRef
        gradientLayer.colors = [color1, color2]
        gradientLayer.locations = [0.0, 0.9]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        completionView.layer.addSublayer(gradientLayer)
    }
    
    
    func updateCompletionView() {
        
        let newWidth: CGFloat = frame.width * CGFloat(progress)
        completionView.frame = CGRect(x: 0.0, y: 0.0, width: newWidth, height: frame.height)
    }
    
    
    func updateGradientLayer() {
        
        if (completionView.bounds.width == 0) {
            // Width 0
            gradientLayer.frame = CGRect(
                x: completionView.bounds.origin.x - CGFloat(gradientLayer.cornerRadius),
                y: completionView.bounds.origin.y,
                width: 0.0,
                height: completionView.bounds.height)
        } else {
            // Normal
            gradientLayer.frame = CGRect(
                x: completionView.bounds.origin.x - CGFloat(gradientLayer.cornerRadius),
                y: completionView.bounds.origin.y,
                width: completionView.bounds.width + 2*gradientLayer.cornerRadius,
                height: completionView.bounds.height)
        }
    }
    
    
    func setProgress(progress: Float, animated: Bool) {
        
        // Set variable
        self.progress = progress
        
        // Update Completion View
        if (animated) {
            UIView.animateWithDuration(1.0, animations: {
                
                self.updateCompletionView()
                
            })
            
            
            CATransaction.begin()
            CATransaction.setAnimationDuration(1.1)
            updateGradientLayer()
            CATransaction.commit()
            
            
        } else {
            updateCompletionView()
        }
    }
    
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        
        // Draw White Background
        let backgroundPath = UIBezierPath(rect: rect)
        UIColor.whiteColor().setFill()
        backgroundPath.fill()
        
        let grayTone: CGFloat = 0.985
        let strokeColor = UIColor(red: grayTone, green: grayTone, blue: grayTone, alpha: 1.000)
        
        // Stroke Properties for drawing slants
        strokeColor.setStroke()
        let lineWidth: CGFloat = 10.0
        let xOffset: CGFloat = 30.0             // Distance between each slant
        let yHeightInset: CGFloat = 2.0        // Distance above/bellow view each slant reaches
        let slantLength: CGFloat = rect.height + 2*yHeightInset
        
        var slantOrigin = CGPoint(x: rect.origin.x - slantLength, y: rect.origin.y + rect.height + yHeightInset)
        
        
        
        // Create path
        let path = UIBezierPath()
        path.lineWidth = lineWidth
        
        while(slantOrigin.x < rect.width) {
            
            path.moveToPoint(slantOrigin)
            path.addLineToPoint( CGPoint(x: slantOrigin.x + slantLength, y: slantOrigin.y - slantLength) )
            
            // Update origin
            slantOrigin = CGPoint(x: slantOrigin.x + xOffset, y: slantOrigin.y)
            
        }
        
        
        // Draw
        path.stroke()
        
    }
    
    
    
}
