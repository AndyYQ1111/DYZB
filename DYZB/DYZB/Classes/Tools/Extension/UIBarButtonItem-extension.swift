//
//  UIBarButtonItem-extension.swift
//  DYZB
//
//  Created by YueAndy on 2017/10/20.
//  Copyright © 2017年 YueAndy. All rights reserved.
//

import Foundation
import UIKit

extension UIBarButtonItem{
    convenience init(imageName:String,highImageName:String = "",size:CGSize = CGSize.zero) {
        let btn = UIButton()
        btn.setImage(UIImage(named:imageName), for: .normal)
        if(highImageName != ""){
            btn.setImage(UIImage(named:highImageName), for: .highlighted)
        }
        if(size == CGSize.zero){
            btn.sizeToFit()
        }else{
            btn.frame = CGRect(origin: CGPoint.zero, size: size)
        }
        self.init(customView: btn)
    }
}
