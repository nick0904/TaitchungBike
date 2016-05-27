

import UIKit

class RentViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    private var m_tableView:UITableView?
    
    private var m_rentDescription = [
        "租車流程":[
        "使用者可持電子票證(悠遊卡、一卡通)與手機,透過KIOSK機台申請成為iBike會員。",
        "任選一臺自行車，持註冊後的電子票證(悠遊卡、一卡通)放置於停車柱感應區感應。",
        "當綠色指示燈開始閃爍並發出短鳴聲，便可取車。",
        "將單車車頭擺正並以雙手向後拉出，完成取車。"],
        "還車步驟":[
            "選定亮藍燈的空車柱，輪胎壓齊地上白線、對準卡槽，車頭擺正往前推入到底。",
            "將車輛插入卡槽聽到一聲喀，並稍微前後拉動，再次確認是否上鎖。",
            "刷卡藍燈閃爍發出短鳴聲，持電子票證(悠遊卡、一卡通)放置於停車柱感應區扣款，待燈號跳回綠燈時，即完成還車程序。"]]
    
    private var m_imageName = [
        "租":["r1.png","r2.png","r3.png","r4.png"],
        "還":["r5.png","r6.png","r7.png"]]
    
    
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
        
        //===========   m_tableView   ============
        m_tableView = UITableView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        m_tableView?.dataSource = self
        m_tableView?.delegate = self
        m_tableView?.bounces = false
        self.view.addSubview(m_tableView!)
        
    }
    
//MARK: - UITableView DataSource
//------------------------------
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return self.m_rentDescription.keys.count
    }
    
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        
//        let allkeys:[String] = [String](m_rentDescription.keys)
//        
//        return allkeys[section]
//    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        /*
        取值過程
        let allkeys:[String] = [String](m_rentDescription.keys)
        var key = allkeys[section]
        var _count = m_rentDescription[key]?.count
        */
        return m_rentDescription[[String](m_rentDescription.keys)[section]]!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell_id:String = "CELL_ID"
        var cell = tableView.dequeueReusableCellWithIdentifier(cell_id) as UITableViewCell!
        if cell == nil {
            
            cell = UITableViewCell(style: .Default, reuseIdentifier: cell_id)
            cell.selectionStyle = .None
            cell.textLabel?.font = UIFont.systemFontOfSize(cell.frame.size.height * 0.35)
        }
        
        /*
        取值過程
        let allkeys:[String] = [String](m_rentDescription.keys)
        var key = allkeys[indexPath.section]
        var value = m_rentDescription[key]![indexPath.row]
        */
        
        cell.textLabel?.text = m_rentDescription[[String](m_rentDescription.keys)[indexPath.section]]![indexPath.row]
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.numberOfLines = 0
        cell.imageView?.image = UIImage(named: m_imageName[[String](m_imageName.keys)[indexPath.section]]![indexPath.row])
        
        return cell
    }
    
//MARK: - UITableView Delegate
//------------------------------
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return self.view.frame.size.height/5
    }
    
    var headerHeight:CGFloat = 0

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        headerHeight = self.view.frame.size.height/10
        return headerHeight
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let allkeys:[String] = [String](m_rentDescription.keys)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: headerHeight))
        label.textAlignment = .Center
        label.text = allkeys[section]
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.boldSystemFontOfSize(label.frame.size.height * 0.5)
        label.adjustsFontSizeToFitWidth = true
        
        switch section {
        case 0:
            label.backgroundColor = UIColor.orangeColor()
        case 1:
            label.backgroundColor = UIColor.blueColor()
        default:
            break
        }
        
        return label
    }
}//end class
