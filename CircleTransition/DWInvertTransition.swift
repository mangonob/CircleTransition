//
//  InvertTransition.swift
//  CircleTransition
//
//  Created by Trinity on 16/7/10.
//  Copyright © 2016年 Trinity. All rights reserved.
//

import UIKit

class DWInvertTransition: NSObject, UIViewControllerAnimatedTransitioning {
    var keyRect: CGRect = CGRectZero
    var tContext: UIViewControllerContextTransitioning?
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        tContext = transitionContext
        
        let from = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! SecondViewController
        let to = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! ViewController
        let contain = transitionContext.containerView()!
        
        contain.addSubview(from.view)
        contain.insertSubview(to.view, belowSubview: from.view)
        
        let endPath = UIBezierPath(ovalInRect: keyRect)
        let len = CGFloat(sqrt(pow(contain.bounds.width, 2) + pow(contain.bounds.height, 2)))
        let startPath = UIBezierPath(ovalInRect: CGRectInset(keyRect, -len, -len))
        
        let masklayer = CAShapeLayer()
        masklayer.path = endPath.CGPath
        from.view.layer.mask = masklayer
        
        let ani = CABasicAnimation(keyPath: "path")
        ani.duration = transitionDuration(transitionContext)
        ani.fromValue = startPath.CGPath
        ani.toValue = endPath.CGPath
        ani.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        ani.delegate = self
        
        masklayer.addAnimation(ani, forKey: "\(arc4random())")
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if let tContext = tContext {
            tContext.completeTransition(!tContext.transitionWasCancelled())
            if let vc = tContext.viewControllerForKey(UITransitionContextFromViewControllerKey) {
                vc.view.layer.mask = nil
            }
        }
    }
}
