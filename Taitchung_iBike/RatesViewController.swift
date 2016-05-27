

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
        self.view.backgroundColor = UIColor.grayColor()
        let navH = ((UIApplication.sharedApplication().delegate as? AppDelegate)?.nav?.navigationBar.frame.size.height)!
        let statusBarHeight = (UIApplication.sharedApplication().statusBarFrame.size.height)
        let spaceH = navH + statusBarHeight
        let labelHeight:CGFloat = (frame.size.height - spaceH)/2
        
        
        //*****************  底圖  *****************
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        imgView.image = UIImage(named: "bottom.png")
        imgView.contentMode = .ScaleAspectFill
        imgView.clipsToBounds = true
        self.view.addSubview(imgView)
        
        //*****************  信用卡  *****************
        let label01 = UILabel(frame: CGRect(x: 0, y: spaceH , width:frame.size.width/6, height: labelHeight))
        label01.text = "信\n" + "用\n" + "卡"
        label01.backgroundColor = UIColor.redColor()
        label01.textColor = UIColor.whiteColor()
        label01.textAlignment = .Center
        label01.numberOfLines = 0
        label01.font = UIFont.boldSystemFontOfSize(label01.frame.size.width * 0.5)
        self.view.addSubview(label01)
        
        let textViewWidth = frame.size.width - label01.frame.size.width
        
        
        var theView = UIView(frame: CGRect(x: label01.frame.size.width, y: CGRectGetMinY(label01.frame), width: textViewWidth, height: labelHeight))
        self.buttomView(theView, color: UIColor.redColor())
        
        
        let textView01 = UITextView(frame: CGRect(x: label01.frame.size.width, y: CGRectGetMinY(label01.frame), width: textViewWidth, height: labelHeight))
        textView01.layer.cornerRadius = 10.0
        textView01.backgroundColor = UIColor.clearColor()
        textView01.textColor = UIColor.whiteColor()
        textView01.font = UIFont.systemFontOfSize(textView01.frame.size.width/15)
        textView01.textAlignment = .Center
        textView01.editable = false
        textView01.text = "\n=====付費方式 =====\n請使用Visa、JCB、Master等國際組織發行之信用卡\n\n\n===== 註冊方式 =====\n各站點KIOSK機台申辦\n\n\n===== 使用費率 =====\n使用4小時內每30分鐘10元\n4小時～8小時每30分鐘20元\n超過8小時以上每30分鐘40元"
        self.view.addSubview(textView01)
        
        //*****************  電子票證  *****************
        let label02 = UILabel(frame: CGRect(x: 0, y: spaceH + labelHeight, width:frame.size.width/6, height: labelHeight))
        label02.text = "電\n" + "子\n" + "票\n" + "證"
        label02.backgroundColor = UIColor.blueColor()
        label02.textColor = UIColor.whiteColor()
        label02.textAlignment = .Center
        label02.numberOfLines = 0
        label02.font = UIFont.boldSystemFontOfSize(label01.frame.size.width * 0.5)
        self.view.addSubview(label02)
        
        theView = UIView(frame: CGRect(x: label02.frame.size.width, y: CGRectGetMinY(label02.frame), width: textViewWidth, height: labelHeight))
        self.buttomView(theView, color: UIColor.blueColor())
        
        
        let textView02 = UITextView(frame: CGRect(x: label02.frame.size.width, y: CGRectGetMinY(label02.frame), width: textViewWidth, height: labelHeight))
        textView02.backgroundColor = UIColor.clearColor()
        textView02.textColor = UIColor.whiteColor()
        textView02.font = UIFont.systemFontOfSize(textView01.frame.size.width/15)
        textView02.textAlignment = .Center
        textView02.editable = false
        textView02.text = "\n=====付費方式 =====\n悠遊卡、一卡通\n\n\n===== 註冊方式 =====\n服務中心申辦\n官方網站申辦\n官方APP申辦\n各站點KIOSK機台申辦\n\n\n===== 使用費率 =====\n使用前30分鐘免費\n4小時內每30分鐘10元\n4小時～8小時每30分鐘20元\n超過8小時以上每30分鐘40元"
        self.view.addSubview(textView02)
        
    }
    
    func buttomView(theView:UIView,color:UIColor) {
        
        theView.backgroundColor = color
        theView.alpha = 0.68
        self.view.addSubview(theView)
        
    }


}
