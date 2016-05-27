

import UIKit

class SpotTableViewCell: UITableViewCell {
    
    var spotName_label:UILabel! //站名
    var unRent_label:UILabel! //尚餘幾輛
    var capacity_label:UILabel! //空位數量
    var location_label:UILabel! //地點描述
    
    func refreshWithFrame(frame:CGRect) {
        
        self.frame = frame
        self.backgroundColor = UIColor.whiteColor()
        
        let frameW = frame.size.width
        let frameH = frame.size.height
        
        //************  cell_background  ************
        let cell_background = UIImageView(frame: CGRect(x: 0, y: 0, width: frameW, height: frameH))
        cell_background.image = UIImage(named: "cellSample.png")
        cell_background.contentMode = .ScaleToFill
        cell_background.clipsToBounds = true
        self.addSubview(cell_background)
        
        //************  spotName_label  *************
        spotName_label = UILabel(frame: CGRect(x: 0, y: 0, width: frameW , height: frameH/3))
        spotName_label.textColor = UIColor.whiteColor()
        spotName_label.font = UIFont.boldSystemFontOfSize(spotName_label.frame.size.height * 0.68)
        spotName_label.textAlignment = .Center
        self.addSubview(spotName_label)
        
        //************  location_label  *************
        location_label = UILabel(frame: CGRect(x: 0, y: CGRectGetMaxY(spotName_label.frame), width: frameW, height: frameH/3))
        location_label.textColor = UIColor.whiteColor()
        location_label.textAlignment = .Center
        self.addSubview(location_label)
        
        //************  unRent_label  ***************
        unRent_label = UILabel(frame: CGRect(x: 0, y: CGRectGetMaxY(location_label.frame), width: frameW/2, height: frameH/3))
        unRent_label.backgroundColor = UIColor.blueColor()
        unRent_label.textColor = UIColor.whiteColor()
        unRent_label.textAlignment = .Center
        unRent_label.alpha = 0.8
        self.addSubview(unRent_label)
        
        //************  capacity_label  *************
        capacity_label = UILabel(frame: CGRect(x: CGRectGetMaxX(unRent_label.frame), y: CGRectGetMaxY(location_label.frame), width: frameW/2, height: frameH/3))
        capacity_label.backgroundColor = UIColor.redColor()
        capacity_label.textColor = UIColor.whiteColor()
        capacity_label.textAlignment = .Center
        capacity_label.alpha = unRent_label.alpha
        self.addSubview(capacity_label)
        
    }
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
