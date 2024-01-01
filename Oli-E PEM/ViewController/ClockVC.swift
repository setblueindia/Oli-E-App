//
//  ClockVC.swift
//  Oli-E PEM
//
//  Created by Khushali Sorathiya on 12/12/23.
//

import UIKit
//import UIKit
import ARKit
import SceneKit
import Foundation

class ClockVC: UIViewController {
    static var ActiveNumberArray : [Int]=[]
    @IBOutlet var imageview: UIImageView!
    var activeNumber = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        imageview.isUserInteractionEnabled = true
        let tapGestureClock = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        imageview.addGestureRecognizer(tapGestureClock)
        // Do any additional setup after loading the view.
        //
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        //if currentIndex == 8 {
            let location = sender.location(in: imageview)
            let angle = angleForPoint(location, in: imageview)
            let number = numberForAngle(angle)
        ClockVC.ActiveNumberArray.append(number)
            activeNumber = number
            imageview.image = UIImage(named: "Active \(number)")
       // }
    }
    func angleForPoint(_ point: CGPoint, in view: UIView) -> CGFloat {
        let center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        let deltaX = point.x - center.x
        let deltaY = point.y - center.y
        return atan2(deltaY, deltaX)
    }
    
    func numberForAngle(_ angle: CGFloat) -> Int {
        let degrees = angle * 180.0 / CGFloat.pi
        let normalizedDegrees = (degrees + 360.0).truncatingRemainder(dividingBy: 360.0)
        let hour = Int((normalizedDegrees / 30.0).rounded()) + 3
        return hour <= 12 ? hour : hour - 12
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
