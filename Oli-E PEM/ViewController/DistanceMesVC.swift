//
//  DistanceMesVC.swift
//  Oli-E PEM
//
//  Created by Khushali Sorathiya on 14/09/23.
//

import UIKit
import ARKit
import SceneKit
import Foundation

class DistanceMesVC: UIViewController {

    
    @IBOutlet var lblPlaceholder: UILabel!
   
    @IBOutlet var cameraView: ARSCNView!
    @IBOutlet var lblDistance: UILabel!
    @IBOutlet var btnStart: UIButton!{
        didSet {
            btnStart.layer.cornerRadius = 10
        }
        
    }
    
    private let captureSession = AVCaptureSession()
    private lazy var previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
    private let videoDataOutput = AVCaptureVideoDataOutput()
    private var faceLayers: [CAShapeLayer] = []
    static var distanceFromEye = String()
    
    @IBAction func NextbtnAct(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let vc = storyboard.instantiateViewController(withIdentifier: "ImageSliderVC") ; // MySecondSecreen the storyboard ID
        //self.present(vc, animated: true, completion: nil);
        
        
        //vc.arrData = arrImage
        self.navigationController?.pushViewController(vc, animated: false)
        
    }
    @IBOutlet var btnNext: UIButton!
    {
        didSet {
            btnNext.layer.cornerRadius = 10
        }
        
    }
    
    //var faceAnchorsAndContentControllers: [ARFaceAnchor: VirtualContentController] = [:]
    
    var currentDistance = 0.0
    var lastBlinkTimestamp: TimeInterval = 0
    var isRealface = false
    var faceIdentifier = ""
    var distance = 20.0
    var timer: Timer?
    
    static var storyboardInstance:DistanceMesVC {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DistanceMesVC") as! DistanceMesVC
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIApplication.shared.isIdleTimerDisabled = true
        //kriti addded
        
        
        //self.captureSession.stopRunning()
        
       resetTracking()
        
       
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer?.invalidate()
        //if isRealface{
            //self.captureSession.stopRunning()
        //}
        stopSession()
    }
    
    //kriti added
    /*override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.previewLayer.frame = self.cameraView.frame
    }*/
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        /*setupCamera()
        //DispatchQueue.main.async
       // {
            self.captureSession.startRunning()
       // }*/
        
        
        lblPlaceholder.text = "To ensure a comfortable and healthy viewing experience, we recommend maintaining a distance of approximately \(fareDistance) feet from your screen"
        btnNext.setTitle("Next", for: .normal)
        
//        for anchor in faceAnchorsAndContentControllers.keys {
//            let contentController = TransformVisualization()
//            if let node = cameraView.node(for: anchor),
//            let contentNode = contentController.renderer(cameraView, nodeFor: anchor) {
//                node.addChildNode(contentNode)
//                faceAnchorsAndContentControllers[anchor] = contentController
//            }
//        }
        
        cameraView.delegate = self
        cameraView.session.delegate = self
        cameraView.automaticallyUpdatesLighting = true
       // self.previewLayer.frame = self.cameraView.frame
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        
        /*let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ImageSliderVC") as? ImageSliderVC
        self.navigationController?.pushViewController(vc!, animated: true)*/
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(screenTapped))
                self.view.addGestureRecognizer(tapGesture)
       
    }
    @objc func screenTapped() {
            performSegue(withIdentifier: "ToImageSlider", sender: self)
        }
    private func setupCamera() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .front)
        if let device = deviceDiscoverySession.devices.first {
            if let deviceInput = try? AVCaptureDeviceInput(device: device) {
                if captureSession.canAddInput(deviceInput) {
                    captureSession.addInput(deviceInput)
                    
                    setupPreview()
                }
            }
        }
    }
    func stopSession() {
        if captureSession.isRunning {
            DispatchQueue.global().async {
                self.captureSession.stopRunning()
            }
        }
    }
    private func setupPreview() {
        
        
        self.cameraView.layer.addSublayer(self.previewLayer)
        self.previewLayer.videoGravity = .resizeAspectFill
        self.previewLayer.videoGravity = .resizeAspectFill
        //self.view.layer.addSublayer(self.previewLayer)
      /*  self.previewLayer.videoGravity = .resizeAspectFill
        self.view.layer.addSublayer(self.previewLayer)*/
       // self.previewLayer.frame = self.cameraView.frame
        
        self.videoDataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString) : NSNumber(value: kCVPixelFormatType_32BGRA)] as [String : Any]

        self.videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera queue"))
        self.captureSession.addOutput(self.videoDataOutput)
        
        let videoConnection = self.videoDataOutput.connection(with: .video)
        videoConnection?.videoOrientation = .portrait
    }

    //MARK: IBButton Action
    @IBAction func btnStartAction(_ sender: Any) {
        
        if distance >= fareDistance {
            //before kriti
           self.cameraView.session.pause()
            self.timer?.invalidate()
            
            //kriti added
           
            
            self.navigationController?.pushViewController(ImageSliderVC.storyboardInstance, animated: false)
        }else {
            let Alert = UIAlertController(title: "Distance is Close", message: "Please set subject \(fareDistance) feet away from screen.", preferredStyle: .alert)
            Alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(Alert, animated: true)
        }
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
    
    // - Tag: ARFaceTrackingSetup
    func resetTracking() {
        stopSession()
        
        guard ARFaceTrackingConfiguration.isSupported else { return }
        
        let configuration = ARFaceTrackingConfiguration()
        configuration.isWorldTrackingEnabled = true
        if #available(iOS 13.0, *) {
            configuration.maximumNumberOfTrackedFaces =  ARFaceTrackingConfiguration.supportedNumberOfTrackedFaces
        }
        configuration.isLightEstimationEnabled = true
        cameraView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        faceIdentifier = ""
        isRealface = false
        
        lastBlinkTimestamp = Date.timeIntervalSinceReferenceDate
        
        lblDistance.text = "0.00 Feets"
        startTimer()
    }
    
    func faceNotDetectAlert() {
        isRealface = false
        self.cameraView.session.pause()
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
extension DistanceMesVC : ARSessionDelegate {
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        
                for anchor in anchors {
                    guard let faceAnchor = anchor as? ARFaceAnchor else { continue }
                    
                    let leftEyeBlink = floor((faceAnchor.blendShapes[.eyeBlinkLeft] as? Float ?? 0.0) * 1000) / 1000
                    let rightEyeBlink = floor((faceAnchor.blendShapes[.eyeBlinkRight] as? Float ?? 0.0) * 1000) / 1000
                    
                    let jawleft = floor((faceAnchor.blendShapes[.mouthLeft] as? Float ?? 0.0) * 1000) / 1000
                    let jawRight = floor((faceAnchor.blendShapes[.mouthRight] as? Float ?? 0.0) * 1000) / 1000
                    
                    if jawleft > 0.02 || jawRight > 0.02 {
                        print(">>>>","LEFT : ", jawleft,"RIGHT: ", jawRight)
                    }
                    
                    let currentTime = Date.timeIntervalSinceReferenceDate
                    if leftEyeBlink > 0.05 && rightEyeBlink > 0.05  {
                        lastBlinkTimestamp = currentTime
                        isRealface = true
                    }else if leftEyeBlink <= 0.008 && rightEyeBlink <= 0.008 && currentTime - lastBlinkTimestamp > 10 {
                        faceNotDetectAlert()
                    }
                 }
        
        if isRealface {
            guard let faceAnchor = anchors.compactMap({ $0 as? ARFaceAnchor }).last else { return }
            // Get the camera transform
            guard let cameraTransform = session.currentFrame?.camera.transform else { return }
            
            // Get the face position relative to the camera
            let facePosition = simd_make_float4(faceAnchor.transform.columns.3)
            let facePositionInCamera = simd_mul(cameraTransform, facePosition)
            
            // Calculate the distance between the face and the camera
            let distance = sqrt(facePositionInCamera.x * facePositionInCamera.x +
                                facePositionInCamera.y * facePositionInCamera.y +
                                facePositionInCamera.z * facePositionInCamera.z)
            
            let feet = distance * 3.28084
            if (self.distance - Double(feet)) > 0.01 {
                lblDistance.text = "\(String(format:"%.2f",feet)) Feets"
            }
            
            //lblDistance.text
            UserDefaults.standard.set(lblDistance.text, forKey: "savedDistance")
            

            // Retrieve distance from UserDefaults
            if let savedDistance = UserDefaults.standard.value(forKey: "savedDistance") as? Double {
                print("Saved distance: \(savedDistance)")
            }
            
            self.distance = Double(feet)
            
            if self.distance >= fareDistance {
              self.btnStart.isEnabled = true
              //self.btnStartAction(btnStart)
            }else if self.distance < 8 {
              self.btnStart.isEnabled = false
            }
        }
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
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
extension DistanceMesVC: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
          return
        }

        let faceDetectionRequest = VNDetectFaceLandmarksRequest(completionHandler: { (request: VNRequest, error: Error?) in
            DispatchQueue.main.async {
                self.faceLayers.forEach({ drawing in drawing.removeFromSuperlayer() })

                if let observations = request.results as? [VNFaceObservation] {
                    self.handleFaceDetectionObservations(observations: observations)
                }
            }
        })

        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: imageBuffer, orientation: .leftMirrored, options: [:])

        do {
            try imageRequestHandler.perform([faceDetectionRequest])
        } catch {
          print(error.localizedDescription)
        }
    }
    
    private func handleFaceDetectionObservations(observations: [VNFaceObservation]) {
        for observation in observations {
            let faceRectConverted = self.previewLayer.layerRectConverted(fromMetadataOutputRect: observation.boundingBox)
            let faceRectanglePath = CGPath(rect: faceRectConverted, transform: nil)
            
            let faceLayer = CAShapeLayer()
            faceLayer.path = faceRectanglePath
            faceLayer.fillColor = UIColor.clear.cgColor
            faceLayer.strokeColor = UIColor.yellow.cgColor
            
            self.faceLayers.append(faceLayer)
            self.view.layer.addSublayer(faceLayer)
            
            //FACE LANDMARKS
            if let landmarks = observation.landmarks {
                if let leftEye = landmarks.leftEye {
                    self.handleLandmark(leftEye, faceBoundingBox: faceRectConverted)
                }
                if let leftEyebrow = landmarks.leftEyebrow {
                    self.handleLandmark(leftEyebrow, faceBoundingBox: faceRectConverted)
                }
                if let rightEye = landmarks.rightEye {
                    self.handleLandmark(rightEye, faceBoundingBox: faceRectConverted)
                }
                if let rightEyebrow = landmarks.rightEyebrow {
                    self.handleLandmark(rightEyebrow, faceBoundingBox: faceRectConverted)
                }

                if let nose = landmarks.nose {
                    self.handleLandmark(nose, faceBoundingBox: faceRectConverted)
                }

                if let outerLips = landmarks.outerLips {
                    self.handleLandmark(outerLips, faceBoundingBox: faceRectConverted)
                }
                if let innerLips = landmarks.innerLips {
                    self.handleLandmark(innerLips, faceBoundingBox: faceRectConverted)
                }
            }
        }
    }
    
    private func handleLandmark(_ eye: VNFaceLandmarkRegion2D, faceBoundingBox: CGRect) {
        let landmarkPath = CGMutablePath()
        let landmarkPathPoints = eye.normalizedPoints
            .map({ eyePoint in
                CGPoint(
                    x: eyePoint.y * faceBoundingBox.height + faceBoundingBox.origin.x,
                    y: eyePoint.x * faceBoundingBox.width + faceBoundingBox.origin.y)
            })
        landmarkPath.addLines(between: landmarkPathPoints)
        landmarkPath.closeSubpath()
        let landmarkLayer = CAShapeLayer()
        landmarkLayer.path = landmarkPath
        landmarkLayer.fillColor = UIColor.clear.cgColor
        landmarkLayer.strokeColor = UIColor.green.cgColor

        self.faceLayers.append(landmarkLayer)
        self.view.layer.addSublayer(landmarkLayer)
    }
}
extension DistanceMesVC: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
       guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        
//        DispatchQueue.main.async {
//            let contentController = TransformVisualization()
//            if node.childNodes.isEmpty, let contentNode = contentController.renderer(renderer, nodeFor: faceAnchor) {
//                node.addChildNode(contentNode)
//               // self.faceAnchorsAndContentControllers[faceAnchor] = contentController
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
            self.cameraView.session.pause()
            self.timer?.invalidate()
            
            DispatchQueue.main.async {
                let Alert = UIAlertController(title: "Detect different face", message: "Please click on reset and try after", preferredStyle: .alert)
                Alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { ok in
                    self.resetTracking()
                }))
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
        //faceAnchorsAndContentControllers[faceAnchor] = nil
        if faceIdentifier != "" {
            faceNotDetectAlert()
        }
    }
    
}
