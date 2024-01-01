//
//  VC.swift
//  Oli-E PEM
//
//  Created by Khushali Sorathiya on 05/12/23.
//

import UIKit

class VC: UIViewController {
    
    static var storyboardInstance: VC{
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VC") as! VC
        //self.navigationController?.pushViewController(vc, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(screenTapped))
                self.view.addGestureRecognizer(tapGesture)
        /*let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let vc = storyboard.instantiateViewController(withIdentifier: "LiveFeedVC") ; // MySecondSecreen the storyboard ID
         self.navigationController?.pushViewController(vc, animated: false)*/
        
     
    }
    @objc func screenTapped() {
            performSegue(withIdentifier: "ToLiveFeedVC", sender: self)
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
