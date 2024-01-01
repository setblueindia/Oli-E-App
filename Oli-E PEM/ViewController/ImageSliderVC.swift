//
//  ImageSliderVC.swift
//  Oli-E PEM
//
//  Created by Khushali Sorathiya on 14/09/23.
//

import UIKit
import ARKit
import SceneKit
import Foundation

//Model for data store
struct subject {
    var image: String
    var distance: Double
    var color : String
}

class ImageSliderVC: UIViewController,UIGestureRecognizerDelegate {
    
    @IBOutlet var scrollImage: UIScrollView!
    @IBOutlet var imgUse: UIImageView!
    @IBOutlet var lblDistance: UILabel!
    @IBOutlet var sceneView: ARSCNView!{
        didSet {
            sceneView.layer.cornerRadius = 10
        }
    }
    var isShowingFirstImage = true
   var  isShowingSecondImage = true
    var  isShowingThirdImage = true
    var  isShowingFourthImage = true
    var  isShowingFifthImage = true
    var  isShowingSixthImage = true
    var  isShowingSeventhImage = true
    var  isShowingEighthImage = true
    
    static  var arrayDistance : [String] = []
    
    var array = [String]()
    var arr = [String]()
    var k = 0
    var count = 0
    static var l = 0;
    static var r = 0;
    static var l1 = 0;
    static var r1 = 0;
    
    @IBOutlet var nextBtnoutlet: UIButton!
    @IBOutlet var btnPrevious: UIButton!{
        didSet {
            btnPrevious.isEnabled = true
        }
    }
    @IBOutlet var btnReset: UIButton!
    @IBOutlet var btnNext: UIButton!{
        didSet{
            btnNext.isEnabled = true
        }
    }
    
    var currentDistance = 0.0
    var lastBlinkTimestamp: TimeInterval = 0
    var isRealface = false
    var faceIdentifier = ""
    var distance = 20.0  
    var currentIndex = 0
    var timer: Timer?
    var activeNumber = Int()
    let imageArray: [UIImage?] = [UIImage(named: "Image1"), UIImage(named: "Image2"), UIImage(named: "Image3"),
                                  UIImage(named: "Image4"),
                                  UIImage(named: "Image5"),
                                  UIImage(named: "Image6"),
                                  UIImage(named: "Image7"),
                                  UIImage(named: "Image8"),
                                  UIImage(named: "Image9")]

    var arrImage : [subject] = [subject(image: "Image1", distance: 20.00, color: ""),
                                 subject(image: "Image2", distance: 20.00, color: ""),
                                 subject(image: "Image3", distance: 20.00, color: ""),
                                 subject(image: "Image4", distance: 20.00, color: ""),
                                 subject(image: "Image5", distance: 20.00, color: ""),
                                 subject(image: "Image6", distance: 20.00, color: "N/A"),
                                 subject(image: "Image7", distance: 20.00, color: ""),
                                 subject(image: "Image8", distance: 20.00, color: "N/A"),
                                 subject(image: "Image9", distance: 20.00, color: "0") ]
    
   // var faceAnchorsAndContentControllers: [ARFaceAnchor: VirtualContentController] = [:]
    
    static var storyboardInstance:ImageSliderVC {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ImageSliderVC") as! ImageSliderVC
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIApplication.shared.isIdleTimerDisabled = true
    
        resetTracking()
        btnPrevious.isEnabled = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        for anchor in faceAnchorsAndContentControllers.keys {
        //            let contentController = TransformVisualization()
        //            if let node = sceneView.node(for: anchor),
        //               let contentNode = contentController.renderer(sceneView, nodeFor: anchor) {
        //                node.addChildNode(contentNode)
        //                faceAnchorsAndContentControllers[anchor] = contentController
        //            }
        //        }
        
        imgUse.image = UIImage(named: arrImage[0].image)
        
        sceneView.delegate = self
        sceneView.session.delegate = self
        sceneView.automaticallyUpdatesLighting = true
        
        let finishButton = UIBarButtonItem(title: "Finish", style: .plain, target: self, action: #selector(finishButtonTapped))
        navigationItem.rightBarButtonItem = finishButton
        
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        
        /*let tapGesture = UITapGestureRecognizer(target: self, action: #selector(screenTapped))
         self.view.addGestureRecognizer(tapGesture)*/
        imgUse.isUserInteractionEnabled = true
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imgTapped))
        imgUse.addGestureRecognizer(tapGesture)
        
        // Show the initial image
        updateImage()
        
        /*let button = UIButton(type: .system)
                
                // Set button's properties
                button.setTitle("Press Me", for: .normal)
                button.setTitleColor(.white, for: .normal)
                button.backgroundColor = .blue
                
                // Add action (selector) to the button
                button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
                
                // Set button's frame
                button.frame = CGRect(x: 50, y: 100, width: 200, height: 50)
                
                // Add the button to the view
                view.addSubview(button)*/
       
        /*let tappGesture = UITapGestureRecognizer(target: self, action: #selector(screenTapped))
                self.view.addGestureRecognizer(tappGesture)*/
        
      // kriti removed
//        let tapppGesture = UITapGestureRecognizer(target: self, action: #selector(screenTappped))
                //self.view.addGestureRecognizer(tapppGesture)
        
        addgesturetoLastImage()
        if(currentIndex == 8){
            let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
            doubleTapGesture.numberOfTapsRequired = 2
            
            // Add the double tap gesture recognizer to the image view
            imgUse.addGestureRecognizer(doubleTapGesture)
        }
        /*if currentIndex == 9 {
            let tapGestureClock = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            imgUse.addGestureRecognizer(tapGestureClock)
            /*let tappGesture = UITapGestureRecognizer(target: self, action: #selector(screenTapped))
             self.view.addGestureRecognizer(tapGesture)
             self.view.addGestureRecognizer(tappGesture)*/
            // AddGesture()
            
        }*/
        
        //imageView.image = UIImage(named: "Image9") // Replace with your image
        /*if(imgUse.image == UIImage(named: "Image9"))*/
        if(currentIndex == 8){
            let imageView = UIImageView(frame: CGRect(x: 50, y: 50, width: 200, height: 200))
            imageView.image = UIImage(named: "Image9")
            // Enable user interaction for the image view
            imageView.isUserInteractionEnabled = true
            
            // Create a UITapGestureRecognizer for double tap
            let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
            doubleTapGesture.numberOfTapsRequired = 2
            
            // Add the double tap gesture recognizer to the image view
            imageView.addGestureRecognizer(doubleTapGesture)
        }
                
                // Add the image view to the main view
                //self.view.addSubview(imageView)
    }
    
    @objc func buttonAction(_ sender: UIButton) {
           // print("Button was pressed!")
        /*dataUpdate()
        
        self.sceneView.session.pause()
        self.timer?.invalidate()*/
        
        let vc = ResultVC.storyboardInstance
        //vc.arrData = arrImage
        self.navigationController?.pushViewController(vc, animated: false)
            // Add your desired functionality here
        }

@objc func screenTapped() {
        performSegue(withIdentifier: "ToClockVC", sender: self)
    }
    
    /*@objc func screenTappped() {
            performSegue(withIdentifier: "ToCClockVC", sender: self)
        }*/
    
    func addgesturetoLastImage(){
        if(currentIndex == 8){
            let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
            longPressGesture.delegate = self
            
            // Set properties for the long press gesture recognizer
            longPressGesture.minimumPressDuration = 0.5 // Customize the minimum press duration
            
            // Add the long press gesture recognizer to the view
            imgUse.addGestureRecognizer(longPressGesture)
        }
    }
    @objc func handleLongPress(_ sender: UILongPressGestureRecognizer) {
            if sender.state == .began {
                print("Long press recognized!")
                
                let location = sender.location(in: imgUse)
                let angle = angleForPoint(location, in: imgUse)
                let number = numberForAngle(angle)
                activeNumber = number
                imgUse.image = UIImage(named: "Active \(number)")
                // Perform actions specific to the long press
            }
        }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            // Allow simultaneous recognition with other gestures (if needed)
            return true
        }
    @objc func handleDoubleTap(_ sender: UITapGestureRecognizer) {
            // Perform actions when a double tap is detected
        if(currentIndex == 8){
            if sender.state == .recognized {
                print("Double tap recognized!")
                let location = sender.location(in: imgUse)
                let angle = angleForPoint(location, in: imgUse)
                let number = numberForAngle(angle)
                activeNumber = number
                imgUse.image = UIImage(named: "Active \(number)")
                // Add your code to perform actions on double tap
            }
        }
        }
        @objc func handleTap(_ sender: UITapGestureRecognizer) {
            if currentIndex == 8 {
                let location = sender.location(in: imgUse)
                let angle = angleForPoint(location, in: imgUse)
                let number = numberForAngle(angle)
                activeNumber = number
                ClockVC.ActiveNumberArray.append(number)
                imgUse.image = UIImage(named: "Active \(number)")
            }
        }
    /*@objc func screenTapped() {
            performSegue(withIdentifier: "ToDistanceMesVC", sender: self)
        }*/
    
    
    var currentImageIndex = 0
    @objc func imgTapped() {
            // Increment the current index and display the next image
            currentImageIndex += 1
            if currentImageIndex >= imageArray.count {
                // Reset to the first image when reaching the end of the array
                //currentImageIndex = 0
                return
            }
            updateImage()
        }

        func updateImage() {
            // Update the image displayed in the imageView based on the current index
            imgUse.image = imageArray[currentImageIndex]
            addgesturetoLastImage()
            if(currentIndex == 8){
                //let imageView = UIImageView(frame: CGRect(x: 50, y: 50, width: 200, height: 200))
                imgUse.image = UIImage(named: "Image9")
                // Enable user interaction for the image view
                imgUse.isUserInteractionEnabled = true
                
                // Create a UITapGestureRecognizer for double tap
                let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
                doubleTapGesture.numberOfTapsRequired = 2
                
                // Add the double tap gesture recognizer to the image view
                imgUse.addGestureRecognizer(doubleTapGesture)
            }
        }
   
    
    
    @IBAction func nextButtonAct(_ sender: Any) {
       
        if (currentIndex == 5 || currentIndex == 7) && (imgUse.image == UIImage(named: "Image6") || imgUse.image == UIImage(named: "Image8")) {
            
            let Alert = UIAlertController(title: "Alert", message: "Please select color", preferredStyle: .alert)
            Alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(Alert, animated: true)
            
            
        }else {
//            btnPrevious.isEnabled = false
//            btnNext.isEnabled = false
            dataUpdate()
        
        if currentIndex < arrImage.count - 1 {
            currentIndex += 1
        }else if currentIndex == arrImage.count - 1 {
            //currentIndex = 0
        }
        imgUse.image = UIImage(named: arrImage[currentIndex].image)
        AddGesture()
        
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 5.00) {
            if self.distance < fareDistance {
                let Alert = UIAlertController(title: "Distance is Close", message: "Please set subject \(fareDistance) feet away from screen.", preferredStyle: .alert)
                Alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(Alert, animated: true)
            }
        }
    }
       
    }
    //MARK: Image Tap Actions
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        
        if currentIndex == 5 {
            let location = sender.location(in: imgUse)
            let halfWidth = imgUse.bounds.size.width / 2
            
            if location.x < halfWidth {
                imgUse.image = UIImage(named: "Image6L")
                ImageSliderVC.l = ImageSliderVC.l + 1;
                UserDefaults.standard.setValue("Image6L", forKey: "image6l")
            } else {
                imgUse.image = UIImage(named: "Image6R")
                ImageSliderVC.r = ImageSliderVC.r + 1;
                UserDefaults.standard.setValue("Image6R", forKey: "image6r")
            }
        }else if currentIndex == 7 {
            let location = sender.location(in: imgUse)
            let halfWidth = imgUse.bounds.size.width / 2
            
            if location.x < halfWidth {
                imgUse.image = UIImage(named: "Image8L")
                ImageSliderVC.l1 = ImageSliderVC.l1 + 1;
                UserDefaults.standard.setValue("Image8L", forKey: "image8l")
            } else {
                ImageSliderVC.r1 = ImageSliderVC.r1 + 1;
                imgUse.image = UIImage(named: "Image8R")
                UserDefaults.standard.setValue("Image8R", forKey: "image8r")
            }
        }
        else if(currentIndex == 8){
            //let imageView = UIImageView(frame: CGRect(x: 50, y: 50, width: 200, height: 200))
            imgUse.image = UIImage(named: "Image9")
            // Enable user interaction for the image view
            imgUse.isUserInteractionEnabled = true
            
            // Create a UITapGestureRecognizer for double tap
            let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
            doubleTapGesture.numberOfTapsRequired = 2
            
            // Add the double tap gesture recognizer to the image view
            imgUse.addGestureRecognizer(doubleTapGesture)
        }
           if currentIndex == 9{
               self.navigationController?.pushViewController(ResultVC.storyboardInstance, animated: false)
               /*let tapGestureClock = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
               imgUse.addGestureRecognizer(tapGestureClock)*/
               /*let tappGesture = UITapGestureRecognizer(target: self, action: #selector(screenTapped))
                self.view.addGestureRecognizer(tapGesture)
                self.view.addGestureRecognizer(tappGesture)*/
               // AddGesture()
               
           }
        
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
    
    @IBAction func summarise(_ sender: Any) {
        //dataUpdate()
        
        //self.sceneView.session.pause()
        //self.timer?.invalidate()
        
        let vc = ResultVC.storyboardInstance
        //vc.arrData = arrImage
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func AddGesture() {
       if currentIndex == 5 || currentIndex == 7  {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
            imgUse.addGestureRecognizer(tapGesture)
        }else if currentIndex == 8 {
            let tapGestureClock = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            imgUse.addGestureRecognizer(tapGestureClock)
        }else {
            if let gestureRecognizers = imgUse.gestureRecognizers {
                for gestureRecognizer in gestureRecognizers {
                    imgUse.removeGestureRecognizer(gestureRecognizer)
                }
            }
        }
    }
   
    //MARK: IBButton Action
    @objc func finishButtonTapped() {
        dataUpdate()
        
        self.sceneView.session.pause()
        self.timer?.invalidate()
        
        let vc = ResultVC.storyboardInstance
       // vc.arrData = arrImage
        self.navigationController?.pushViewController(vc, animated: false)
    }

    @IBAction func btnPreviousAction(_ sender: UIButton) {
        
        if (currentIndex == 5 || currentIndex == 7) && (imgUse.image == UIImage(named: "Image6") || imgUse.image == UIImage(named: "Image8")) {
            
            let Alert = UIAlertController(title: "Alert", message: "Please select color", preferredStyle: .alert)
            Alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(Alert, animated: true)
            
            
        }else {
            
//            btnPrevious.isEnabled = false
//            btnNext.isEnabled = false
            dataUpdate()
            
            if currentIndex > 0 {
                currentIndex -= 1
            }else if currentIndex == 0 {
                //currentIndex = arrImage.count - 1
            }
            imgUse.image = UIImage(named: arrImage[currentIndex].image)
            AddGesture()
            
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 5.00) {
                if self.distance < fareDistance {
                    let Alert = UIAlertController(title: "Distance is Close", message: "Please set subject \(fareDistance) feet away from screen.", preferredStyle: .alert)
                    Alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(Alert, animated: true)
                }
            }
        }
    }
    
    @IBAction func btnNextAction(_ sender: UIButton) {
        if (currentIndex == 5 || currentIndex == 7) && (imgUse.image == UIImage(named: "Image6") || imgUse.image == UIImage(named: "Image8")) {
            
            let Alert = UIAlertController(title: "Alert", message: "Please select color", preferredStyle: .alert)
            Alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(Alert, animated: true)
            
            
        }else {
//            btnPrevious.isEnabled = false
//            btnNext.isEnabled = false
            dataUpdate()
        
        if currentIndex < arrImage.count - 1 {
            currentIndex += 1
        }else if currentIndex == arrImage.count - 1 {
            //currentIndex = 0
        }
        imgUse.image = UIImage(named: arrImage[currentIndex].image)
        AddGesture()
        
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 5.00) {
            if self.distance < fareDistance {
                let Alert = UIAlertController(title: "Distance is Close", message: "Please set subject \(fareDistance) feet away from screen.", preferredStyle: .alert)
                Alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(Alert, animated: true)
            }
        }
    }
       
    }
    
    @IBAction func btnResetAction(_ sender: Any) {
        resetTracking()
        // imgUse.image = UIImage(named: arrImage[0].image)
    }
    
    
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
    }
    
    @objc func timerFired() {
        print("Timer fired!")
        if Date.timeIntervalSinceReferenceDate - lastBlinkTimestamp >= 10 {
            faceNotDetectAlert()
        }
    }
    
    func dataUpdate() {
        arrImage[currentIndex].distance = distance
        if currentIndex == 5 {
            if imgUse.image == UIImage(named: "Image6L") {
                arrImage[currentIndex].color = "red"
            }else if imgUse.image == UIImage(named: "Image6R") {
                arrImage[currentIndex].color = "green"
            }
        }else if currentIndex == 7 {
            if imgUse.image == UIImage(named: "Image8L") {
                arrImage[currentIndex].color = "red"
            }else if imgUse.image == UIImage(named: "Imadege8R") {
                arrImage[currentIndex].color = "green"
            }
        }
        else if currentIndex == 8 {
            arrImage[currentIndex].color = "\(activeNumber)"
        }
       else if currentIndex == 9{
            self.navigationController?.pushViewController(ResultVC.storyboardInstance, animated: false)
           
            
        }
    }
    
    
    // - Tag: ARFaceTrackingSetup
    func resetTracking() {
        guard ARFaceTrackingConfiguration.isSupported else { return }
        let configuration = ARFaceTrackingConfiguration()
        configuration.isWorldTrackingEnabled = true
        if #available(iOS 13.0, *) {
            configuration.maximumNumberOfTrackedFaces =  ARFaceTrackingConfiguration.supportedNumberOfTrackedFaces
        }
        configuration.isLightEstimationEnabled = true
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        faceIdentifier = ""
        isRealface = false
        
        lastBlinkTimestamp = Date.timeIntervalSinceReferenceDate
        
        lblDistance.text = "0.00 Feets"
        startTimer()
    }
    
    func faceNotDetectAlert() {
        isRealface = false
        self.sceneView.session.pause()
        faceIdentifier = ""
        timer?.invalidate()
        
        DispatchQueue.main.async {
            let Alert = UIAlertController(title: "Did not detact face", message: "Please click on reset and try after", preferredStyle: .alert)
            Alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { ok in
                self.resetTracking()
            }))
            self.present(Alert, animated: true)
        }
    }
    
}


// MARK: - ARSessionDelegate
extension ImageSliderVC : ARSessionDelegate {
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        
        for anchor in anchors {
            guard let faceAnchor = anchor as? ARFaceAnchor else { continue }
            
            let leftEyeBlink = floor((faceAnchor.blendShapes[.eyeBlinkLeft] as? Float ?? 0.0) * 1000) / 1000
            let rightEyeBlink = floor((faceAnchor.blendShapes[.eyeBlinkRight] as? Float ?? 0.0) * 1000) / 1000
            
            
            let currentTime = Date.timeIntervalSinceReferenceDate
            if leftEyeBlink > 0.08 && rightEyeBlink > 0.08  {
                lastBlinkTimestamp = currentTime
                isRealface = true
            }else if leftEyeBlink <= 0.008 && rightEyeBlink <= 0.008 && currentTime - lastBlinkTimestamp > 10 {
                faceNotDetectAlert()
            }
        }
        
        if isRealface {
            guard let faceAnchor = anchors.compactMap({ $0 as? ARFaceAnchor }).first else { return }
            guard let cameraTransform = session.currentFrame?.camera.transform else { return }
            
            let facePosition = simd_make_float4(faceAnchor.transform.columns.3)
            let facePositionInCamera = simd_mul(cameraTransform, facePosition)
            
            let distance = sqrt(facePositionInCamera.x * facePositionInCamera.x +
                                facePositionInCamera.y * facePositionInCamera.y +
                                facePositionInCamera.z * facePositionInCamera.z)
            
            let feet = distance * 3.28084
            if (self.distance - Double(feet)) > 0.01 {
                lblDistance.text = "\(String(format:"%.2f",feet)) Feets"
                
                let distance_string = lblDistance.text
                captureDistance1(lbldistance: distance_string!)
                count = count + 1;
                //captureDistance(distance_string)
                
                array.append(distance_string!)
                print(array)
                if(currentIndex == 8){
                    //captureDistance(array)
                }
                
//                if self.distance >= fareDistance {
//                    btnNext.isEnabled = true
//                    btnPrevious.isEnabled = true
//                }
            }
            self.distance = Double(feet)
            
//            if self.distance >= fareDistance {
//                btnPrevious.isEnabled = true
//                btnNext.isEnabled = true
//            }
                if currentIndex == 0 {
                    btnPrevious.isEnabled = false
                }else if currentIndex == arrImage.count - 1 {
                    btnNext.isEnabled = false
                }
            
        }
    }
    
    func captureDistance1(lbldistance:String) {
        // Fetch existing distances from UserDefaults
        //var distances = UserDefaults.standard.array(forKey: "storedDistances") as? [Double] ?? []
        
        //for i in arr{
            
            UserDefaults.standard.set(lbldistance, forKey: "savedDistance\(k)")
        ImageSliderVC.arrayDistance.append(lbldistance)
            k = k + 1;
      
    }
    func captureDistance(_ array: [String]) {
        // Fetch existing distances from UserDefaults
        //var distances = UserDefaults.standard.array(forKey: "storedDistances") as? [Double] ?? []
        
        UserDefaults.standard.set(array[0], forKey: "savedDistance0")
        UserDefaults.standard.set(array[1], forKey: "savedDistance1")
        UserDefaults.standard.set(array[2], forKey: "savedDistance2")
        UserDefaults.standard.set(array[3], forKey: "savedDistance3")
        UserDefaults.standard.set(array[4], forKey: "savedDistance4")
        UserDefaults.standard.set(array[5], forKey: "savedDistance5")
        UserDefaults.standard.set(array[6], forKey: "savedDistance6")
        UserDefaults.standard.set(array[7], forKey: "savedDistance7")
        UserDefaults.standard.set(array[8], forKey: "savedDistance8")
        // Add the new distance value to the array
        //distances.append(distance)
        
        // Update UserDefaults with the new array of distances
        //UserDefaults.standard.set(distances, forKey: "storedDistances")
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        guard error is ARError else { return }
        
        let errorWithInfo = error as NSError
        let messages = [
            errorWithInfo.localizedDescription,
            errorWithInfo.localizedFailureReason,
            errorWithInfo.localizedRecoverySuggestion
        ]
        let errorMessage = messages.compactMap({ $0 }).joined(separator: "\n")
        
        DispatchQueue.main.async {
            self.displayErrorMessage(title: "The AR session failed.", message: errorMessage)
        }
    }
    
    // MARK: - Error handling
    
    func displayErrorMessage(title: String, message: String) {
        // Present an alert informing about the error that has occurred.
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let restartAction = UIAlertAction(title: "Restart Session", style: .default) { _ in
            alertController.dismiss(animated: true, completion: nil)
            self.resetTracking()
        }
        alertController.addAction(restartAction)
        present(alertController, animated: true, completion: nil)
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
   
}

extension ImageSliderVC: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        
//        DispatchQueue.main.async {
//            let contentController = TransformVisualization()
//            if node.childNodes.isEmpty, let contentNode = contentController.renderer(renderer, nodeFor: faceAnchor) {
//                node.addChildNode(contentNode)
//                // self.faceAnchorsAndContentControllers[faceAnchor] = contentController
//            }
//        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        
        if faceIdentifier == "" || faceIdentifier == faceAnchor.identifier.uuidString {
            faceIdentifier = faceAnchor.identifier.uuidString
            isRealface = true
        } else {
            self.isRealface = false
            self.sceneView.session.pause()
            self.timer?.invalidate()
            
            DispatchQueue.main.async {
                let Alert = UIAlertController(title: "Detect different face", message: "Please click on reset and try after", preferredStyle: .alert)
                Alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(Alert, animated: true)
            }
        }
        
        guard let faceGeometry = node.geometry as? ARSCNFaceGeometry,
              let faceAnchor = anchor as? ARFaceAnchor
        else { return }
        faceGeometry.update(from: faceAnchor.geometry)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
       // faceAnchorsAndContentControllers[faceAnchor] = nil
        if faceIdentifier != "" {
            faceNotDetectAlert()
        }
    }
    
}
