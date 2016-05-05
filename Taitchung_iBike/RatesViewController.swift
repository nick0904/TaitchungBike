//
//  RatesViewController.swift
//  Taitchung_iBike
//
//  Created by 曾偉亮 on 2016/5/3.
//  Copyright © 2016年 TSENG. All rights reserved.
//

import UIKit

class RatesViewController: UIViewController {
    
    
//MARK: - Override Function
//-------------------------
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        (UIApplication.sharedApplication().delegate as? AppDelegate)?.nav?.setNavigationBarHidden(false, animated: true)
    }


    func refreshWithFrame(frame:CGRect) {
        
        self.view.frame = frame
        self.view.backgroundColor = UIColor.whiteColor()
    }


}
