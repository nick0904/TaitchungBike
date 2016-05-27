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

class BikeData: NSObject {
    
    var spotName:String = ""  //站名
    var area:String = ""  //地點描述
    var unRentNumber:String = ""  //尚餘幾輛
    var capacityNumber:String = ""  //空位數量
    var longitude:String = ""  //經度
    var latitude:String = ""  //緯度
}
