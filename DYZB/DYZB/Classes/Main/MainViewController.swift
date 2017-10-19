//
//  MainViewController.swift
//  DYZB
//
//  Created by YueAndy on 2017/10/19.
//  Copyright © 2017年 YueAndy. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChildVc(name: "Home")
        addChildVc(name: "Live")
        addChildVc(name: "Follow")
        addChildVc(name: "Profile")
        
    }
    
    private func addChildVc(name:String){
        let childVc = UIStoryboard.init(name: name, bundle: nil).instantiateInitialViewController()!
        addChildViewController(childVc)
    }
}
