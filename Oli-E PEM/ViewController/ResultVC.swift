//
//  ResultVC.swift
//  Oli-E PEM
//
//  Created by Khushali Sorathiya on 14/09/23.
//

import UIKit
struct subject1 {
    var image: String
    var distance: String
    var color : String
}


class ResultVC: UIViewController {

    @IBOutlet var DistanceFromEye: UILabel!
    @IBOutlet var btnSubmit: UIButton!{
        didSet{
            btnSubmit.layer.cornerRadius = 10
        }
    }
    @IBOutlet var clvResult: UICollectionView!
    
   // var arrData = [subject]()
    var subjectName = ""
    let fileName = "Oli-E PEM.csv"
    
    static var storyboardInstance:ResultVC {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ResultVC") as! ResultVC
    }
    
    var arrImage1 : [subject1] = [
                                 subject1(image: "eyetrack", distance: "", color: ""),
                                 subject1(image: "Image1", distance: "", color: ""),
                                 subject1(image: "Image2", distance: "20.00", color: ""),
                                 subject1(image: "Image3", distance: "20.00", color: ""),
                                 subject1(image: "Image4", distance: "20.00", color: ""),
                                 subject1(image: "Image5", distance: "20.00", color: ""),
                                 subject1(image: "Image6", distance: "20.00", color: ""),
                                 subject1(image: "Image7", distance: "20.00", color: ""),
                                 subject1(image: "Image8", distance: "20.00", color: ""),
                                 subject1(image: "Image9", distance: "20.00", color: ""),
                                 subject1(image: "Active 3", distance: "", color: "")]
    override func viewDidLoad() {
        super.viewDidLoad()

        let importButton = UIBarButtonItem(title: "Import", style: .plain, target: self, action: #selector(importButtonTapped))
        navigationItem.rightBarButtonItem = importButton
        
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        
        
        navigationItem.backBarButtonItem = backButton
        
        clvResult.register(UINib(nibName: "ResultCC", bundle: nil), forCellWithReuseIdentifier: "ResultCC")
        DistanceFromEye.text = ""
        //DistanceFromEye.text =  UserDefaults.standard.string(forKey: "savedDistance")!
        //DistanceFromEye.text = Distance from DistanceMesVC.distanceFromEye
        //kriti
        
       // arrImage1[0].distance = (UserDefaults.standard.string(forKey: "savedDistance"))!
        
        
        /*if let savedDistanceString = UserDefaults.standard.string(forKey: "savedDistance"),
           let savedDistance = savedDistanceString {
            arrImage1[0].distance = savedDistance
            print("Saved distance: \(savedDistance)")
            // Use the savedDistance value in this screen as needed
        }*/
     /*   if let savedDistance = UserDefaults.standard.value(forKey: "savedDistance") as? Double {
            arrImage1[0].distance = savedDistance
            var distanceData = ""
           /* for i in arrImage1 {
              //  if i.image == "Image1"{
                    arrImage1[0].distance = savedDistance
                    distanceData = "\(savedDistance) \(String(format: "%.2f", i.distance)) (\(i.color)),"
                //}
               /* if i.image == "Image6" || i.image == "Image8" || i.image == "Image9" {
                    distanceData = "\(distanceData) \(String(format: "%.2f", i.distance)) (\(i.color)),"
                }else {
                    distanceData = "\(distanceData) \(String(format: "%.2f", i.distance)),"
                }*/
            }*/
            
            
            
            print("Saved distance: \(savedDistance)")
            // Use the savedDistance value in this screen as needed
        } else {
            print("No distance data found")
        }*/
        
        clvResult.reloadData()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(screenTapped))
                self.view.addGestureRecognizer(tapGesture)
        
        
       
    }
    @objc func screenTapped() {
            //performSegue(withIdentifier: "ToClockVC", sender: self)
        }
        
    
    
    @objc func importButtonTapped() {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
            let fileURL = dir.appendingPathComponent(fileName)
             
            self.openfile(path: fileURL)
            
//            let objectsToShare = [fileURL] as [Any]
//            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
//            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
//            
//            if UIDevice.current.userInterfaceIdiom == .pad {
//                activityVC.popoverPresentationController?.sourceView = self.view
//                activityVC.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY,width: 0,height: 0)
//            }
//            
//            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnSubmitAction(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Subject Name", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Subject Name"
        }
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            let name = firstTextField.text ?? ""
            
            if !name.trimmingCharacters(in: .whitespaces).isEmpty {
                self.subjectName = name
                self.saveDataOnFile()
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func saveDataOnFile() {
       var csvText = "Name, Image1, Image2, Image3, Image4, Image5, Image6, Image7, Image8, Image9, Create at\n" // CSV header
        
        var distanceData = ""
       /* for i in arrImage1 {
            if i.image == "Image6" || i.image == "Image8" || i.image == "Image9" {
                distanceData = "\(distanceData) \(String(format: "%.2f", i.distance)) (\(i.color)),"
            }else {
                distanceData = "\(distanceData) \(String(format: "%.2f", i.distance)),"
            }
        }*/
        
        let csvLine = "\(subjectName), \(distanceData) \(Date().convertToLocal()!)\n"
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
            let fileURL = dir.appendingPathComponent(fileName)
            
            do {
                if FileManager.default.fileExists(atPath: fileURL.path) {
                    print("CSV file exists at: \(fileURL)")
                    var existingCSVText = try String(contentsOf: fileURL, encoding: .utf8)
//
//                    existingCSVText.append(csvLine)  //Add data on last
//                    try existingCSVText.write(to: fileURL, atomically: true, encoding: .utf8)
                    
                    var lines = existingCSVText.components(separatedBy: "\n")  //Add data on frist
                    lines.insert(csvLine, at: 1)
                    let updatedContent = lines.joined(separator: "\n")
                    try updatedContent.write(to: fileURL, atomically: true, encoding: .utf8)
                   
                } else {
                    csvText.append(csvLine)
                    
                    try csvText.write(to: fileURL, atomically: true, encoding: .utf8)
                    print("CSV file saved at: \(fileURL)")
                }
                
            } catch {
                print("Error writing CSV file: \(error)")
            }
        } else {
            print("Error locating the documents directory.")
        }
    }
   
}

//MARK: Collectionview Delegate
extension ResultVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImage1.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = clvResult.dequeueReusableCell(withReuseIdentifier: "ResultCC", for: indexPath) as! ResultCC
        //arrImage1[0].distance = (UserDefaults.standard.string(forKey: "savedDistance"))!
        cell.cellData = arrImage1[indexPath.row]
        if(indexPath.row == 6)
        {
            
            if (ImageSliderVC.l > 0){
               // lblColor.text = "red"
                arrImage1[5].image == "red"
            }
            else{
                //lblColor.text = "green"
                arrImage1[5].image == "green"
            }
        }
       // cell.cellData?.distance = arrImage1[indexPath.row].distance
        //cell.cellData?.image = arrImage1[indexPath.row].image
        return cell
    }
    
    
    //MARK: UICollectionViewDelegateFlowLayout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:UIScreen.main.bounds.size.width/2 - 30 , height: 120)
    }
   
   
}


extension ResultVC : UIDocumentInteractionControllerDelegate {
    func openfile(path: URL) {
         var documentController: UIDocumentInteractionController?
            
            documentController = UIDocumentInteractionController(url: path)
            documentController?.delegate = self
            
            if let controller = documentController {
                controller.presentPreview(animated: true)
            }
        }
        
        func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
            return self
        }
}


extension Date {
    func convertToLocal() -> String? {
        let dateFormator = DateFormatter()
        dateFormator.dateFormat = "yyyy/MM/dd HH:mm"
        dateFormator.timeZone = .current
        return dateFormator.string(from: self)
    }
}
