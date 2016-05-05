

import UIKit

class EquipmentViewController: UIViewController {
    
    var m_scrollView:UIScrollView?
    var ary_titleLabels = [UILabel]()
    var ary_descriptionLabels = [UILabel]()
    
//MARK: - Override Function
//-------------------------    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        (UIApplication.sharedApplication().delegate as? AppDelegate)?.nav?.setNavigationBarHidden(false, animated: true)
    }
    
//MARK: - refreshWithFrame
//-------------------------
    func refreshWithFrame(frame:CGRect) {
        
        self.view.frame = frame
        self.view.backgroundColor = UIColor.whiteColor()
        let navH = ((UIApplication.sharedApplication().delegate as? AppDelegate)?.nav?.navigationBar.frame.size.height)!
        let statusBarHeight = (UIApplication.sharedApplication().statusBarFrame.size.height)
        let spaceH = navH + statusBarHeight
     
        //*************   m_scrollView   *************
        m_scrollView = UIScrollView(frame: CGRect(x: 0, y:spaceH, width:frame.size.width, height: frame.size.height - spaceH))
        m_scrollView?.showsHorizontalScrollIndicator = true
        m_scrollView?.showsVerticalScrollIndicator = true
        m_scrollView?.contentSize = CGSize(width: frame.size.width * 6, height: m_scrollView!.frame.size.height - spaceH)
        m_scrollView?.pagingEnabled = true
        m_scrollView?.bounces = false
        self.view.addSubview(m_scrollView!)
        
        
        let imgView_height = frame.size.width
        let imagView_width = frame.size.width
        
        for index in 0 ... 5 {
            
            //*************  imgView  *************
            let imgView = UIImageView(frame: CGRect(x: imagView_width * CGFloat(index), y: 0-spaceH, width: imagView_width, height: imgView_height))
            imgView.contentMode = .ScaleAspectFit
            imgView.clipsToBounds = true
            imgView.image = UIImage(named: "e\(index+4).png")
            self.m_scrollView?.addSubview(imgView)
        
            //*************  title_label   *************
            let title_label = UILabel(frame: CGRect(x: imagView_width * CGFloat(index), y: imgView.frame.size.height - spaceH, width: imagView_width, height: (m_scrollView!.frame.size.height - imgView.frame.size.height)/2))
            title_label.backgroundColor = UIColor.cyanColor()
            title_label.textAlignment = .Center
            title_label.font = UIFont.boldSystemFontOfSize(title_label.frame.size.height/3)
            title_label.adjustsFontSizeToFitWidth = true
            m_scrollView?.addSubview(title_label)
            self.ary_titleLabels.append(title_label)
            
            //*************   description_label   *************
            let description_label = UILabel(frame: CGRect(x: imagView_width * CGFloat(index), y: imgView.frame.size.height - spaceH + title_label.frame.size.height, width: imagView_width, height: (m_scrollView!.frame.size.height - imgView.frame.size.height)/2))
            description_label.backgroundColor = UIColor.yellowColor()
            description_label.textAlignment = .Center
            description_label.font = UIFont.boldSystemFontOfSize(title_label.frame.size.height/5)
            description_label.adjustsFontSizeToFitWidth = true
            m_scrollView?.addSubview(description_label)
            self.ary_descriptionLabels.append(description_label)
        }
        
        ary_titleLabels[0].text = "全車外觀"
        ary_descriptionLabels[0].text = "鮮明的橘黃色搭配、舒適輕巧好操控"
        
        ary_titleLabels[1].text = "變速"
        ary_descriptionLabels[1].text = "內變三段變速系統、簡單實用"
        
        ary_titleLabels[2].text = "車鎖"
        ary_descriptionLabels[2].text = "兩用車鎖，車柱鎖與臨停鎖"
        
        ary_titleLabels[3].text = "前燈"
        ary_descriptionLabels[3].text = "前輪驅動發亮LED頭燈、讓您行得安全"
        
        ary_titleLabels[4].text = "後燈"
        ary_descriptionLabels[4].text = "一體式嵌入、中途停靠可維持不滅60~90秒"
        
        ary_titleLabels[5].text = "座墊"
        ary_descriptionLabels[5].text = "抗菌、防水、耐磨、可調整高度的高級座墊"

    }
    
    
}//end class
