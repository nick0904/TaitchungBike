
//台中市iBike_App
//資料來源:http://ybjson01.youbike.com.tw:1002/gwjs.json
/*
 "sno",         //站編號
 "sna",         //站名
 "tot",         //場站總停車格
 "sbi",         //場站目前車輛數量
 "sarea",       //區域
 "mday",        //資料更新時間
 "lat",         //緯度
 "lng",         //經度
 "ar",          //地點敘述
 "sareaen",     //英文區域
 "snaen",       //英文站名
 "aren",        //英文地點敘述
 "bemp",        //空位數量
 "act”          //全站禁用狀態
 */

import UIKit

class ViewController: UIViewController {
    
    
//MARK: - Override Function
//-------------------------
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        (UIApplication.sharedApplication().delegate as? AppDelegate)?.nav?.setNavigationBarHidden(true, animated: false)
    }
    
//MARK: - refreshWithFrame
//------------------------
    func refreshWithFrame(frame:CGRect) {
        
        self.view.frame = frame
        self.view.backgroundColor = UIColor.blackColor()
        
        //*************  bt_logo  *************
        let bt_logo = UIButton(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.width))
        bt_logo.center = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        bt_logo.setImage(UIImage(named: "ibike_logo"), forState: .Normal)
        bt_logo.addTarget(self, action: #selector(ViewController.showHomePageVC(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(bt_logo)
        self.addshadow(bt_logo)
        
    }
    
//MARK: - addshadow
//-----------------
    func addshadow(theView:UIView) {
        
        theView.layer.shadowColor = UIColor.blackColor().CGColor
        theView.layer.shadowOffset = CGSizeMake(3.0, 6.0)
        theView.layer.shadowOpacity = 0.88
    }
    
//MARK: - showHomePageVC
//----------------------
    func showHomePageVC(sender:UIButton) {
        
        let homepageVC = HomePageViewController()
        homepageVC.refreshWithFrame(self.view.frame)
        self.navigationController?.pushViewController(homepageVC, animated: true)
    }

}

