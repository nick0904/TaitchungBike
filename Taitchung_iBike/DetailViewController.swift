

import UIKit
import MapKit
import CoreLocation


class DetailViewController: UIViewController, MKMapViewDelegate {

    private var m_map:MKMapView!
    private var m_locationManager:CLLocationManager!
    private var m_annotation:MKPointAnnotation! //大頭針的標示訊息
    private var peopleBt:UIButton!
    private var navBt:UIButton!
    var directionRequest:MKDirectionsRequest! //方位
    var m_route:MKRoute? //路徑
    var m_detailData:BikeData!

    
    func refreshWithFrame(frame:CGRect,navH:CGFloat) {
        
        self.view.frame = frame
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "一般地圖", style: .Plain, target: self, action: #selector(DetailViewController.onBarBtAction(_:)))
        
        let openBt = UIButton(frame: CGRect(x: 0, y: 0, width: frame.size.width/2, height: navH - UIApplication.sharedApplication().statusBarFrame.size.height))
        openBt.setTitle("開啟導航", forState: .Normal)
        openBt.setTitleColor(UIColor.blueColor(), forState: .Normal)
        openBt.addTarget(self, action: #selector(DetailViewController.showAlert), forControlEvents: .TouchUpInside)
        self.navigationItem.titleView = openBt
        
        //**************  m_locationManager  ***********
        m_locationManager = CLLocationManager()
        if (UIDevice.currentDevice().systemVersion as NSString).floatValue >= 8.0 {
         //取得認證要求
            m_locationManager.requestWhenInUseAuthorization()
        }
        
        //***************  m_map  ***************
        m_map = MKMapView(frame: CGRect(x: 0, y: navH, width: frame.size.width, height: frame.size.height - navH))
        m_map.delegate = self
        m_map.mapType = .Standard//一般地圖
        self.view.addSubview(m_map)
        
        //***************  m_annotation  ***************
        m_annotation = MKPointAnnotation()
        
        
        //****************  navBt  *****************
        let btSize:CGFloat = 50
        navBt = UIButton(frame: CGRect(x: CGRectGetMaxX(self.view.frame) - btSize, y: CGRectGetMaxY(self.view.frame) - 2*btSize, width: btSize, height:btSize))
        navBt.setBackgroundImage(UIImage(named: "people04.png"), forState: .Normal)
        navBt.addTarget(self, action: #selector(DetailViewController.showDirection), forControlEvents: .TouchUpInside)
        self.view.addSubview(navBt)
        
        //****************  peopleBt  *****************
        peopleBt = UIButton(frame: CGRect(x: CGRectGetMinX(navBt.frame), y: CGRectGetMinY(navBt.frame) - 1.5*btSize, width: btSize, height:btSize))
        peopleBt.setBackgroundImage(UIImage(named: "people03.png"), forState: .Normal)
        peopleBt.addTarget(self, action: #selector(DetailViewController.showMyLocation), forControlEvents: .TouchUpInside)
        self.view.addSubview(peopleBt)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.showAnnotationInfomation()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        m_map.removeAnnotation(m_annotation)
        
        if let theRoute = m_route {
            
            self.m_map.removeOverlay(theRoute.polyline)
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//MARK: - showDirection
//---------------------
    func showDirection() {

        self.showMyLocation()
        
        directionRequest = MKDirectionsRequest()
        
        //路徑起點
        let beginCoordinate = CLLocationCoordinate2D(latitude: m_locationManager.location!.coordinate.latitude, longitude: m_locationManager.location!.coordinate.longitude)
        let beginMark = MKPlacemark(coordinate: beginCoordinate, addressDictionary: nil)
        directionRequest.source = MKMapItem(placemark: beginMark)
        
        //路徑終點
        let finalCoordinate = CLLocationCoordinate2DMake( CLLocationDegrees(self.m_detailData.latitude)!, CLLocationDegrees(self.m_detailData.longitude)!)
        let finalMark = MKPlacemark(coordinate: finalCoordinate, addressDictionary: nil)
        directionRequest.destination = MKMapItem(placemark: finalMark)
        
        //交通工具
        directionRequest.transportType = .Walking
        
        //方位計算
        let directions = MKDirections(request: directionRequest)
        directions.calculateDirectionsWithCompletionHandler { (routeResponse, routeError) in
            
            if routeError != nil {
                
                print("routeError:\(routeError?.localizedDescription)")
            }
            
            //設定路線
            self.m_route = routeResponse?.routes[0] as MKRoute!
            self.m_map.removeOverlays(self.m_map.overlays)
            self.m_map.addOverlay(self.m_route!.polyline, level: MKOverlayLevel.AboveRoads)
            
            //設定 map 視圖自動符合導航路徑範圍
            let rect = self.m_route!.polyline.boundingMapRect
            self.m_map.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
    
    }
    
//MARK: - MapView Delegate
//------------------------
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        //導行路線覆蓋在 map 上
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.redColor()
        renderer.lineWidth = 3.0
        
        return renderer
        
    }
    
    
//MARK: - showAnnotationInfomation
//--------------------------------
    func showAnnotationInfomation() {
        
        let lat = CLLocationDegrees(m_detailData.latitude)
        let long = CLLocationDegrees(m_detailData.longitude)
        
        //設定annotation的經緯度
        m_annotation.coordinate.latitude = lat!
        m_annotation.coordinate.longitude = long!
        
        //設定annotation的title
        m_annotation.title = m_detailData.spotName

        //設定annotation的subtitle
        m_annotation.subtitle = m_detailData.area
        
        //顯示annotation
        m_map.showAnnotations([m_annotation], animated: true)
        m_map.selectAnnotation(m_annotation, animated: true)
        
    }
    
//MARK: - showMyLocation
//----------------------
    func showMyLocation() {//顯示使用者目前位置
        
        if let locationManager = m_locationManager {
            
            let center = CLLocationCoordinate2DMake(locationManager.location!.coordinate.latitude, locationManager.location!.coordinate.longitude)
            let longDelta:CLLocationDegrees = 0.1
            let latDelta:CLLocationDegrees = 0.1
            let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
            let region:MKCoordinateRegion = MKCoordinateRegion(center: center, span: span)
            m_map.setRegion(region, animated: true)
            m_map.showsUserLocation = true //顯示使用者位置(藍色標誌)
            m_map.userTrackingMode = .FollowWithHeading //地圖Follow使用者正面方位
            m_locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation //設定精準度
            m_map.userLocation.title = "您的目前位置"
            m_locationManager.startUpdatingHeading()
            self.coordinateToAddresss(m_locationManager.location!, myMap: self.m_map)
        }

    }
    
//MARK: - onBarBtAction
//---------------------
    func onBarBtAction(sender:UIBarButtonItem) {
        
        if sender.title == "衛星地圖" {
            sender.title = "一般地圖"
            m_map.mapType = .Standard
        }
        else if sender.title == "一般地圖" {
            sender.title = "3D地圖"
            m_map.mapType = .HybridFlyover
        }
        else if sender.title == "3D地圖" {
            sender.title = "衛星地圖"
            m_map.mapType = .Hybrid
        }
    }
    
//MARK: - openMap
//---------------
    func openMap() {
        
        //路徑起點
        let beginCoordinate = CLLocationCoordinate2D(latitude: m_locationManager.location!.coordinate.latitude, longitude: m_locationManager.location!.coordinate.longitude)
        let beginMark = MKPlacemark(coordinate: beginCoordinate, addressDictionary: nil)
        let beginItem = MKMapItem(placemark: beginMark)
        beginItem.name = "您的目前位置"
        
        //路徑終點
        let finalCoordinate = CLLocationCoordinate2DMake( CLLocationDegrees(self.m_detailData.latitude)!, CLLocationDegrees(self.m_detailData.longitude)!)
        let finalMark = MKPlacemark(coordinate: finalCoordinate, addressDictionary: nil)
        let finalItem = MKMapItem(placemark: finalMark)
        finalItem.name = self.m_detailData.spotName
        
        let theRoute = [beginItem,finalItem]
        
        let options = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeWalking]
        
        //開啟地圖導航
        MKMapItem.openMapsWithItems(theRoute, launchOptions: options)
    }
    
    
//MARK: - showAlert
//-----------------
    func showAlert() {
        
        let alert = UIAlertController(title:"導航模式", message: "您要開啟地圖進行導航模式嗎 ?", preferredStyle:.Alert)
        //apple Map
        alert.addAction(UIAlertAction(title: "開啟Apple地圖", style: .Default, handler: { (appleAction) in
            
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(2.0/10.0 * Double(NSEC_PER_SEC)))
            dispatch_after(time, dispatch_get_main_queue(), {
                
                self.openMap()
            })
            
        }))
        
        //Google Map
        alert.addAction(UIAlertAction(title: "開啟Google地圖", style: .Default, handler: { (googleAction) in
            
    
            let urlString = NSURL(string: String(format: "comgooglemaps://?daddr=%f,%f&saddr=%f,%f&mrsp=0&ht=it&ftr=0",CLLocationDegrees(self.m_detailData.latitude)!,CLLocationDegrees(self.m_detailData.longitude)!,self.m_locationManager.location!.coordinate.latitude,self.m_locationManager.location!.coordinate.longitude))
            
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(2.0/10.0 * Double(NSEC_PER_SEC)))
            dispatch_after(time, dispatch_get_main_queue(), {
                
                UIApplication.sharedApplication().openURL(urlString!)
            })
            
        }))
        
        alert.addAction(UIAlertAction(title: "取消", style: .Destructive, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
//MARK: - coordinateToAddresss
//----------------------------
    func coordinateToAddresss(currentLocation:CLLocation,myMap:MKMapView) {
        
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(currentLocation) { (placeMarks, error) in
            
            if error != nil {
                
                print("GeoCoderReverseError:\(error?.localizedDescription)")
            }
            
            if let thePlaceMarks = placeMarks {
                
                let placeMark = thePlaceMarks[0]
                let city:String = placeMark.administrativeArea as String!
                let locality:String = placeMark.locality as String!
                let street:String = placeMark.thoroughfare as String!
                let streetNum:String = placeMark.subThoroughfare as String!
                myMap.userLocation.subtitle = city + locality + street + streetNum
            }
       
        }
        
    }
    

}//end class
