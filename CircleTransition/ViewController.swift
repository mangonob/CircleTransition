//
//  ViewController.swift
//  CircleTransition
//
//  Created by Trinity on 16/7/10.
//  Copyright © 2016年 Trinity. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate {
    @IBOutlet weak var pushButton: UIButton!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.delegate = self
    }
    
    func navigationController(
        navigationController: UINavigationController, animationControllerForOperation
        operation: UINavigationControllerOperation, fromViewController
        fromVC: UIViewController, toViewController
        toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .Push {
            let a = DWTransition()
            a.keyRect = CGRect(origin: pushButton.center, size: CGSizeZero)
            return a
        } else {
            return nil
        }
    }
}

