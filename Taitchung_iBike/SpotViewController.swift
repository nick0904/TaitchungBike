

import UIKit

class SpotViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating {
    
    private var m_tableView:UITableView?
    private var m_searchController:UISearchController?
    private let m_refresh = UIRefreshControl()
    var m_detailVC:DetailViewController?
    
    private var m_indicator:UIActivityIndicatorView! //下載指示器
    
    var navH:CGFloat!

    let urlStr:String = "http://ybjson01.youbike.com.tw:1002/gwjs.json"
    
    var m_bikeData = [BikeData]()
    var m_searchData = [BikeData]()
    
    
//MARK: - Override Function
//-------------------------
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        (UIApplication.sharedApplication().delegate as? AppDelegate)?.nav?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if m_searchController!.active {
            
            m_searchController?.searchBar.resignFirstResponder()
            m_searchController?.active = false
        }
        
        
    }

//MARK: - Normal Function
//-----------------------
    func refreshWithFrame(frame:CGRect) {
        
        self.view.frame = frame
        self.view.backgroundColor = UIColor.darkGrayColor()
        
        //*****************  m_tableView  ******************
        m_tableView = UITableView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        m_tableView?.backgroundColor = UIColor.darkGrayColor()
        m_tableView?.dataSource = self
        m_tableView?.delegate = self
        m_tableView?.separatorColor = UIColor.clearColor()
        self.view.addSubview(m_tableView!)

        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "啟動搜尋", style: .Plain, target: self, action: #selector(SpotViewController.onBarBtAction(_:)))
        
        //*************  m_indicator(下載指示器)  **************
        m_indicator = UIActivityIndicatorView()
        m_indicator.activityIndicatorViewStyle = .WhiteLarge
        m_indicator.color = UIColor.orangeColor()
        m_indicator.center = self.view.center
        m_indicator.hidesWhenStopped = true
        self.view.addSubview(m_indicator)
        
        //*************** 從網路下載 json 資料  ***************
        self.showActivityIndicator()
        self.loadData()
        
        //*************  m_searchController  **************
        m_searchController = UISearchController(searchResultsController: nil)
        m_searchController?.searchResultsUpdater = self
        m_searchController?.searchBar.placeholder = "請輸入 站名 或 路名 關鍵字"
        m_searchController?.searchBar.barTintColor = UIColor.greenColor()
        m_searchController?.dimsBackgroundDuringPresentation = false
        
        let keyBoardToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height/16))
        let doneBt = UIBarButtonItem(title: "確定", style: .Plain, target: self, action: #selector(SpotViewController.onBarBtAction(_:)))
        let space = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil)
        keyBoardToolBar.setItems([space,doneBt], animated: false)
        m_searchController?.searchBar.inputAccessoryView = keyBoardToolBar
        
        //*************  下拉更新  **************
        m_refresh.tintColor = UIColor.whiteColor()
        let tableVC = UITableViewController()
        tableVC.tableView = self.m_tableView
        tableVC.refreshControl = self.m_refresh
        m_refresh.addTarget(self, action: #selector(SpotViewController.refreshData), forControlEvents: .ValueChanged)
    }

//MARK: - refreshData
//-------------------
    func refreshData() {
    
        if m_searchController!.active {
            //在搜尋模式下,不支援更新動作
            return
        }
        
        self.showActivityIndicator()
        self.loadData()
        self.m_refresh.endRefreshing()
    }
    
//MARK: - showActivityIndicator
//-----------------------------
    func showActivityIndicator() {
        
        m_indicator.startAnimating()
    }
    
    
//MARK: - loadData
//----------------
    func loadData() {
        
        let urlRequest = NSURLRequest(URL: NSURL(string: urlStr)!)
        let urlSession = NSURLSession.sharedSession()
        let task = urlSession.dataTaskWithRequest(urlRequest) { (data, response, error) in
            
            if error != nil {
                
                print("loadError:\(error?.localizedDescription)")
                return
            }
            
            self.m_bikeData = self.parseJSONData(data!)
            
            dispatch_async(dispatch_get_main_queue(), { 
                
                self.m_indicator.stopAnimating()
                self.m_tableView?.reloadData()
            })
        }
        
        task.resume()
    }
    
//MARK: - parseJSONData
//---------------------
    func parseJSONData(theData: NSData) -> [BikeData] {
        
        var bikeData = [BikeData]()
        var parseData = [AnyObject]()
        
        
        do {
            
            //parseFirst
            let parseFirst = try NSJSONSerialization.JSONObjectWithData(theData, options: .MutableContainers) as? NSDictionary
            //parseSecond
            let parseSecond = parseFirst?.objectForKey("retVal") as? NSDictionary
            
            for theKey in 3001 ... 3090 {
                
                let keyStr = String(theKey)
                let dic = parseSecond?.objectForKey(keyStr) as? NSDictionary
                
                if let _dic = dic {
                    
                    parseData.append(_dic)
                }
            }
            
        } catch {
            
            let parseError = error as NSError
            print("parseError:\(parseError.localizedDescription)")
        }
        
        for index in 0 ..< parseData.count {
            
            let dic = parseData[index] as? NSDictionary
            let _bikeData = BikeData()
            _bikeData.spotName = dic?.objectForKey("sna") as! String
            _bikeData.area = dic?.objectForKey("ar") as! String
            _bikeData.unRentNumber = dic?.objectForKey("sbi") as! String
            _bikeData.capacityNumber = dic?.objectForKey("bemp") as! String
            _bikeData.longitude = dic?.objectForKey("lng") as! String
            _bikeData.latitude = dic?.objectForKey("lat") as! String
            
            bikeData.append(_bikeData)
            
        }
        
        return bikeData
        
    }
    
//MARK: - onBarBtAction
//---------------------
    func onBarBtAction(sender:UIBarButtonItem) {
        
        if sender.title == "啟動搜尋" {
            
            if m_searchController == nil {
                
                m_searchController = UISearchController(searchResultsController: nil)
            }
            
            m_searchController?.searchBar.hidden = false
            m_tableView?.setContentOffset(CGPointMake(0, 0 - navH), animated: true)
            m_tableView?.tableHeaderView = m_searchController!.searchBar
            sender.title = "關閉搜尋"
        }
        else if sender.title == "關閉搜尋" {
            
            m_tableView?.tableHeaderView = nil
            sender.title = "啟動搜尋"
        }
        else if sender.title == "確定" {
            
            m_searchController?.searchBar.resignFirstResponder()
        }
    }
    
//MARK: - UISearchResultsUpdating Delegate
//----------------------------------------
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        if let searchText = m_searchController!.searchBar.text {
            
            self.filterForSearchText(searchText)
            self.m_tableView?.reloadData()
        }
    }
    
//MARK: - filterForSearchText
//---------------------------
    func filterForSearchText(theText:String) {
        
        self.m_searchData = m_bikeData.filter({(bikeData:BikeData) -> Bool in
        
            let spotName = bikeData.spotName.rangeOfString(theText, options: .CaseInsensitiveSearch, range: nil, locale: nil)
            let areaName = bikeData.area.rangeOfString(theText, options: .CaseInsensitiveSearch, range: nil, locale: nil)
            
            return spotName != nil || areaName != nil
        })
    }
    
//MARK: - UITableView DataSource & Delegate
//-----------------------------------------
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if m_searchController!.active {
            
            return m_searchData.count
        }
        else {
            
            return m_bikeData.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell_id = "bike_cell_id"
        var cell = tableView.dequeueReusableCellWithIdentifier(cell_id) as! SpotTableViewCell!
        
        if cell == nil {
            
            cell = SpotTableViewCell()
            cell.refreshWithFrame(CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height/6))
            cell.accessoryType = .DisclosureIndicator
            cell.selectionStyle = .None
        }
        
        let cellData = self.m_searchController!.active ? m_searchData : m_bikeData
        cell.spotName_label.text = cellData[indexPath.row].spotName
        cell.location_label.text = cellData[indexPath.row].area
        cell.unRent_label.text = "目前尚餘: " + "\(cellData[indexPath.row].unRentNumber)" + " 輛"
        cell.capacity_label.text = "空位數量: " + "\(cellData[indexPath.row].capacityNumber)" + " 個"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if m_detailVC == nil {
            
            m_detailVC = DetailViewController()
            m_detailVC?.refreshWithFrame(self.view.frame,navH:self.navigationController!.navigationBar.frame.size.height + UIApplication.sharedApplication().statusBarFrame.size.height)
        }
        
        let cellData = self.m_searchController!.active ? m_searchData : m_bikeData
        m_detailVC?.m_detailData = cellData[indexPath.row]
        
        self.navigationController?.pushViewController(m_detailVC!, animated: true)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return self.view.frame.size.height/6
    }
    

}
