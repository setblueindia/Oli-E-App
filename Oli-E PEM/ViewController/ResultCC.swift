//
//  ResultCC.swift
//  Oli-E PEM
//
//  Created by Khushali Sorathiya on 14/09/23.
//

import UIKit

class ResultCC: UICollectionViewCell {
    
    @IBOutlet var viewMain: UIView! {
        didSet {
            viewMain.layer.shadowColor = UIColor.lightGray.cgColor
            viewMain.layer.shadowOffset = CGSize(width: -1, height:1)
            viewMain.layer.shadowOpacity = 0.7
            viewMain.layer.shadowRadius = 5
            viewMain.layer.masksToBounds = false
            
            viewMain.layer.cornerRadius = 10
        }
    }
    @IBOutlet var imgUse: UIImageView!
    @IBOutlet var lblDistance: UILabel!
    @IBOutlet var lblColor: UILabel!
    
    @IBOutlet var labelColorInUse: UILabel!
    
    
    var cellData : subject1? {
        didSet {
            setupUI()
        }
    }
    
    
    func setupUI() {
        if let data = cellData {
            imgUse.image = UIImage(named: data.image)
            if data.image == "clock" {
                imgUse.image = UIImage(named: "Image9")
            }
            if data.image == "eyetrack"{
                //lblDistance.text = ImageSliderVC.arrayDistance[0]
                lblDistance.text = (UserDefaults.standard.string(forKey: "savedDistance"))!
                labelColorInUse.text = ""
            }
            if data.image == "Image1"{
                // lblDistance.text = (UserDefaults.standard.string(forKey: "savedDistance1"))!
                //lblDistance.text = ImageSliderVC.arrayDistance[1]
                lblDistance.text = (UserDefaults.standard.string(forKey: "savedDistance0"))!
                labelColorInUse.text = ""
            }
            if data.image == "Image2"{
                // lblDistance.text = (UserDefaults.standard.string(forKey: "savedDistance2"))!
                //lblDistance.text = ImageSliderVC.arrayDistance[2]
                lblDistance.text = (UserDefaults.standard.string(forKey: "savedDistance1"))!
                labelColorInUse.text = ""
            }
            if data.image == "Image3"{
                lblDistance.text = (UserDefaults.standard.string(forKey: "savedDistance8"))!
                labelColorInUse.text = ""
            }
            if data.image == "Image4"{
                lblDistance.text = (UserDefaults.standard.string(forKey: "savedDistance15"))!
                labelColorInUse.text = ""
            }
            if data.image == "Image5"{
                lblDistance.text = (UserDefaults.standard.string(forKey: "savedDistance20"))!
                labelColorInUse.text = ""
            }
            if data.image == "Image6"{
                lblDistance.text = (UserDefaults.standard.string(forKey: "savedDistance27"))!
                if (ImageSliderVC.l > 0){
                    lblColor.text = "red"
                    
                    labelColorInUse.text = "red"
                    
                }
                else{
                    lblColor.text = "green"
                    labelColorInUse.text = "green"
                }
              
                print(lblColor.text)
            }
            if data.image == "Image7"{
                lblDistance.text = (UserDefaults.standard.string(forKey: "savedDistance35"))!
                labelColorInUse.text = ""
            }
            if data.image == "Image8"{
                lblDistance.text = (UserDefaults.standard.string(forKey: "savedDistance40"))!
                //lblColor.text = data.color
                if (ImageSliderVC.l1 > 0){
                    lblColor.text = "red"
                    labelColorInUse.text = "red"
                }
                else{
                    lblColor.text = "green"
                    labelColorInUse.text = "green"
                }
            }
            if data.image == "Image9"{
                //lblDistance.text = (UserDefaults.standard.string(forKey: "savedDistance8"))!
                lblDistance.text = (UserDefaults.standard.string(forKey: "savedDistance45"))!
                labelColorInUse.text = ""
            }
            if data.image == "Active 3"{
                //lblDistance.text = (UserDefaults.standard.string(forKey: "savedDistance8"))!
                var k = 0;
                labelColorInUse.text = ""
               
                if(ClockVC.ActiveNumberArray.count == 3){
                    lblDistance.text = String("\(ClockVC.ActiveNumberArray[0]) ,\(ClockVC.ActiveNumberArray[1]),\(ClockVC.ActiveNumberArray[2]) axes are selected")
                    
                }else if(ClockVC.ActiveNumberArray.count==2){
                    lblDistance.text = String("\(ClockVC.ActiveNumberArray[0]) ,\(ClockVC.ActiveNumberArray[1]) axes are selected")
                }else if(ClockVC.ActiveNumberArray.count==1){
                    lblDistance.text = String("axe : \(ClockVC.ActiveNumberArray[0])")
                }
                else if(ClockVC.ActiveNumberArray.count==0){
                    lblDistance.text = "none axe is selected"
                }
                else if(ClockVC.ActiveNumberArray.count==4){
                    lblDistance.text = String("axes : \(ClockVC.ActiveNumberArray[0]), \(ClockVC.ActiveNumberArray[1]),\(ClockVC.ActiveNumberArray[2]),\(ClockVC.ActiveNumberArray[3])")
                }
                else if(ClockVC.ActiveNumberArray.count==5){
                    lblDistance.text = String("axes : \(ClockVC.ActiveNumberArray[0]),\(ClockVC.ActiveNumberArray[1]),\(ClockVC.ActiveNumberArray[2]),\(ClockVC.ActiveNumberArray[3]),\(ClockVC.ActiveNumberArray[4])")
                }
                else if(ClockVC.ActiveNumberArray.count==6){
                    lblDistance.text = String("axes :\(ClockVC.ActiveNumberArray[0])\(ClockVC.ActiveNumberArray[1]),\(ClockVC.ActiveNumberArray[2]),\(ClockVC.ActiveNumberArray[3]),\(ClockVC.ActiveNumberArray[4]),\(ClockVC.ActiveNumberArray[5])")
                   
                }
                else if(ClockVC.ActiveNumberArray.count==7){
                    lblDistance.text = String("axes :\(ClockVC.ActiveNumberArray[0]),\(ClockVC.ActiveNumberArray[1]),\(ClockVC.ActiveNumberArray[2]),\(ClockVC.ActiveNumberArray[3]),\(ClockVC.ActiveNumberArray[4]),\(ClockVC.ActiveNumberArray[5]),\(ClockVC.ActiveNumberArray[6])")
                }else if(ClockVC.ActiveNumberArray.count==8){
                    lblDistance.text = String("axes :\(ClockVC.ActiveNumberArray[0]),\(ClockVC.ActiveNumberArray[1]),\(ClockVC.ActiveNumberArray[2]),\(ClockVC.ActiveNumberArray[3]),\(ClockVC.ActiveNumberArray[4]),\(ClockVC.ActiveNumberArray[5]),\(ClockVC.ActiveNumberArray[6]),\(ClockVC.ActiveNumberArray[7])")
                    if (ImageSliderVC.l1 > 0){
                        lblColor.text = "red"
                    }
                    else{
                        lblColor.text = "green"
                    }
                }else if(ClockVC.ActiveNumberArray.count==9){
                    lblDistance.text = String("axes :\(ClockVC.ActiveNumberArray[0]),\(ClockVC.ActiveNumberArray[1]),\(ClockVC.ActiveNumberArray[2]),\(ClockVC.ActiveNumberArray[3]),\(ClockVC.ActiveNumberArray[4]),\(ClockVC.ActiveNumberArray[5]),\(ClockVC.ActiveNumberArray[6]),\(ClockVC.ActiveNumberArray[7]),\(ClockVC.ActiveNumberArray[8])")
                }
                else if(ClockVC.ActiveNumberArray.count==10){
                    lblDistance.text = String("axes :\(ClockVC.ActiveNumberArray[0]),\(ClockVC.ActiveNumberArray[1]),\(ClockVC.ActiveNumberArray[2]),\(ClockVC.ActiveNumberArray[3]),\(ClockVC.ActiveNumberArray[4]),\(ClockVC.ActiveNumberArray[5]),\(ClockVC.ActiveNumberArray[6]),\(ClockVC.ActiveNumberArray[7]),\(ClockVC.ActiveNumberArray[8]),\(ClockVC.ActiveNumberArray[9])")
                }
                else if(ClockVC.ActiveNumberArray.count==11){
                    lblDistance.text = String("axes :\(ClockVC.ActiveNumberArray[0]),\(ClockVC.ActiveNumberArray[1]),\(ClockVC.ActiveNumberArray[2]),\(ClockVC.ActiveNumberArray[3]),\(ClockVC.ActiveNumberArray[4]),\(ClockVC.ActiveNumberArray[5]),\(ClockVC.ActiveNumberArray[6]),\(ClockVC.ActiveNumberArray[7]),\(ClockVC.ActiveNumberArray[8]),\(ClockVC.ActiveNumberArray[9]),\(ClockVC.ActiveNumberArray[10])")
                }
                else if(ClockVC.ActiveNumberArray.count==12){
                    lblDistance.text = String("axes :\(ClockVC.ActiveNumberArray[0]),\(ClockVC.ActiveNumberArray[1]),\(ClockVC.ActiveNumberArray[2]),\(ClockVC.ActiveNumberArray[3]),\(ClockVC.ActiveNumberArray[4]),\(ClockVC.ActiveNumberArray[5]),\(ClockVC.ActiveNumberArray[6]),\(ClockVC.ActiveNumberArray[7]),\(ClockVC.ActiveNumberArray[8]),\(ClockVC.ActiveNumberArray[9]),\(ClockVC.ActiveNumberArray[10]),\(ClockVC.ActiveNumberArray[11]),\(ClockVC.ActiveNumberArray[12])")
                }
            }
                
              
                if data.color != "" {
                    lblColor.text = "Color : \(data.color)"
                    lblColor.isHidden = false
                    
                    if data.image == "clock" {
                        lblColor.text = "Line No : \(data.color)"
                    }
                }else {
                    lblColor.isHidden = true
                }
            }
        }
        
    
    
}
