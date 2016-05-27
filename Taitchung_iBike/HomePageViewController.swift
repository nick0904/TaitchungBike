

import UIKit

class HomePageViewController: UIViewController {
    
    var ary_bt = [UIButton]()
    var connectionBt:UIButton!
    
    //其它頁面
    var equipmentVC:EquipmentViewController?
    var ratesVC:RatesViewController?
    var rentVC:RentViewController?
    var spotVC:SpotViewController?
    
//MARK: - Override Function
//-------------------------
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        (UIApplication.sharedApplication().delegate as? AppDelegate)?.nav?.setNavigationBarHidden(true, animated: false)
        
        for index in 0 ..< ary_bt.count {
            ary_bt[index].transform = CGAffineTransformMakeScale(1.0, 1.0)
        }

    }

    
//MARK: - refreshWithFrame
//------------------------
    func refreshWithFrame(frame:CGRect) {
        
        self.view.frame = frame
        self.view.backgroundColor = UIColor.whiteColor()
        
        let bt_size = frame.size.width/2.5 //設定 bt 大小
        let btOriginX = (frame.size.width - 2*bt_size)/2
        let btOringinY = (frame.size.height - 2*bt_size)/3
        
        for row in 0 ... 1 {
            
            for column in 0 ... 1 {
                
                let bt = UIButton(frame: CGRect(x: 0, y: 0, width: bt_size, height: bt_size))
                bt.center = CGPoint(x: btOriginX + bt_size/2 * (CGFloat(2*column)+1), y: btOringinY + bt_size/2 * (CGFloat(2*row)+1))
                bt.layer.cornerRadius = bt.frame.size.width/2
                bt.titleLabel?.font = UIFont.boldSystemFontOfSize(bt.frame.size.width/6)
                self.view.addSubview(bt)
                bt.alpha = 0.75
                bt.addTarget(self, action: #selector(HomePageViewController.onBtAction(_:)), forControlEvents: .TouchUpInside)
                ary_bt.append(bt)
            }
            
        }
        
        //*************  設備介紹  *************
        ary_bt[0].setTitle("設備介紹", forState: .Normal)
        ary_bt[0].backgroundColor = UIColor.greenColor()
        
        //*************  費率說明  *************
        ary_bt[1].setTitle("費率說明", forState: .Normal)
        ary_bt[1].backgroundColor = UIColor.orangeColor()
        ary_bt[1].center = CGPoint(x: ary_bt[1].center.x - 10, y: ary_bt[1].center.y + 20)
        
        //*************  租借說明  *************
        ary_bt[2].setTitle("租借說明", forState: .Normal)
        ary_bt[2].backgroundColor = UIColor.purpleColor()
        ary_bt[2].center = CGPoint(x: ary_bt[2].center.x + 15, y: ary_bt[2].center.y - 25)
        
        //*************  據點查詢  *************
        ary_bt[3].setTitle("據點查詢", forState: .Normal)
        ary_bt[3].backgroundColor = UIColor.redColor()
        
        //*************  官網連結  *************
        let connectionBtWidth = frame.size.width * 0.8
        connectionBt = UIButton(frame: CGRect(x: frame.size.width/2 - connectionBtWidth/2, y: frame.size.height - 1.5*(connectionBtWidth/3), width:connectionBtWidth, height:connectionBtWidth/3))
        connectionBt.setBackgroundImage(UIImage(named: "connectBt.png"), forState: .Normal)
        connectionBt.addTarget(self, action: #selector(HomePageViewController.onConnectionBtAction(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(connectionBt)
        
    }
    
//MARK:- onBtAction
//-----------------
    func onBtAction(sender:UIButton) {
         
        self.animationWhenTouch(sender)
        self.performSelector(#selector(HomePageViewController.pushOtherViewcontroller(_:)), withObject: sender, afterDelay: 0.38)
    }
    
//MARK: - pushOtherViewcontroller
//-------------------------------
    func pushOtherViewcontroller(sender:UIButton) {
        
        switch sender {
        case ary_bt[0]:
            if equipmentVC == nil {
                
                equipmentVC = EquipmentViewController()
                equipmentVC?.refreshWithFrame(self.view.frame)
                equipmentVC?.title = "設備介紹"
            }
            self.navigationController?.pushViewController(equipmentVC!, animated: true)
            
        case ary_bt[1]:
            if ratesVC == nil {
                
                ratesVC = RatesViewController()
                ratesVC?.refreshWithFrame(self.view.frame)
                ratesVC?.title = "費率說明"
            }
            self.navigationController?.pushViewController(ratesVC!, animated: true)
        case ary_bt[2]:
            if rentVC == nil {
                
                rentVC = RentViewController()
                rentVC?.refreshWithFrame(self.view.frame)
                rentVC?.title = "租借說明"
            }
             self.navigationController?.pushViewController(rentVC!, animated: true)
        case ary_bt[3]:
            if spotVC == nil {
                
                spotVC = SpotViewController()
                spotVC?.refreshWithFrame(self.view.frame)
                spotVC?.title = "據點查詢"
                spotVC?.navH = self.navigationController!.navigationBar.frame.size.height + UIApplication.sharedApplication().statusBarFrame.height
            }
            self.navigationController?.pushViewController(spotVC!, animated: true)
        default:
            return
        }

        
    }
    
//MARK: - onConnectionBtAction
//----------------------------
    func onConnectionBtAction(sender:UIButton) {
        
        UIApplication.sharedApplication().openURL(NSURL(string: "http://i.youbike.com.tw/cht/index.php")!)
    }
    
//MARK: - animationWhenTouch
//--------------------------
    func animationWhenTouch(sender:UIButton) {
        
        UIView.animateWithDuration(0.36, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            
            sender.transform = CGAffineTransformMakeScale(2.5, 2.5)

            }, completion: nil)
        
    }
    

}//end class
