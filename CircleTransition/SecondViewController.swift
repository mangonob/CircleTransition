//
//  SecondViewController.swift
//  CircleTransition
//
//  Created by Trinity on 16/7/10.
//  Copyright © 2016年 Trinity. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UINavigationControllerDelegate {
    private var percentTransition: UIPercentDrivenInteractiveTransition?
    private var displayLink: CADisplayLink?
    private var curr_progress: CGFloat = 0.0
    private var beginTiming: CFTimeInterval = 0.0
    private var invertTransition: DWInvertTransition?
    
    // MARK: - UIViewDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(edgePanAction(_:)))
        edgePan.edges = [.Left]
        self.view.addGestureRecognizer(edgePan)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.delegate = self
    }
    
    @IBAction func backButtonAction(button: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - NavigationController
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .Pop {
            if let to = toVC as? ViewController {
                let a = DWInvertTransition()
                a.keyRect = CGRect(origin: to.pushButton.center, size: CGSizeZero)
                invertTransition = a
                return a
            }
        }
        return nil
    }
    
    func navigationController(
        navigationController: UINavigationController, interactionControllerForAnimationController
        animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return percentTransition
    }
    
    // MARK: - Action
    func edgePanAction(ep: UIScreenEdgePanGestureRecognizer)
    {
        let p = ep.translationInView(self.view)
        let progress = max(min(p.x / self.view.bounds.width, 1), 0)
        
        switch ep.state {
        case .Began:
            percentTransition = UIPercentDrivenInteractiveTransition()
            self.navigationController?.popViewControllerAnimated(true)
        case .Changed:
            percentTransition?.updateInteractiveTransition(progress)
        case .Ended, .Failed, .Cancelled:
            if progress > 0.3 {
                curr_progress = progress
                beginTiming = CACurrentMediaTime()
                displayLink = CADisplayLink(target: self, selector: #selector(displayLinkAction(_:)))
                displayLink?.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
            } else {
                percentTransition?.cancelInteractiveTransition()
                percentTransition = nil
            }
        default: break
        }
    }
    
    func displayLinkAction(dp: CADisplayLink)
    {
        var duration: CGFloat = 0
        if let invertTransition = invertTransition {
            duration = CGFloat(invertTransition.transitionDuration(nil))
        }
        
        if CACurrentMediaTime() > beginTiming + CFTimeInterval(duration) {
            percentTransition?.finishInteractiveTransition()
            percentTransition = nil
            displayLink?.removeFromRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
            displayLink?.invalidate()
            displayLink = nil
        } else {
            let progress = (curr_progress * duration + CGFloat(CACurrentMediaTime() - beginTiming)) / duration
            percentTransition?.updateInteractiveTransition(progress)
        }
    }
}



















































