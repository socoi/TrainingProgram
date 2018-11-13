//
//  UIViewControllerExtension.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 1/19/15.
//  Copyright (c) 2015 Yuji Hato. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func setNavigationBarItem() {
        self.addLeftBarButtonWithImage(UIImage(named: "ic_menu_black_24dp")!)
        //self.addRightBarButtonWithImage(UIImage(named: "ic_notifications_black_24dp")!)
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        self.slideMenuController()?.addLeftGestures()
        self.slideMenuController()?.addRightGestures()
    }
    
    func removeNavigationBarItem() {
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
    }
    
    func addReturnButton(_ buttonImage: UIImage) {
        let leftButton: UIBarButtonItem = UIBarButtonItem(image: buttonImage, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.clickNavigation))
        navigationItem.leftBarButtonItem = leftButton
    }
    
    func clickNavigation(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let subContentsVC = storyboard.instantiateViewController(withIdentifier: "MNReadViewController") as! MNReadViewController
        self.navigationController?.pushViewController(subContentsVC, animated: true)
    }
    
    public func addImageNavigation(){
        self.addReturnButton(UIImage(named: "return")!)
    }
}
