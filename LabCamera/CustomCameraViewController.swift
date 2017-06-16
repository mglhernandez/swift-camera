//
//  CustomCameraViewController.swift
//  LabCamera
//
//  Created by Miguel Hernandez on 6/16/17.
//  Copyright © 2017 Miguel Hernandez. All rights reserved.
//

import UIKit
import AVFoundation

class CustomCameraViewController: UIViewController {
  
  @IBOutlet weak var cameraView: UIView!
  let captureSession = AVCaptureSession()
  var captureDevice: AVCaptureDevice?
  var previewLayer: AVCaptureVideoPreviewLayer!
  var fronCamera: Bool = false

  //var stillImageOutput : AVCaptureStillImageOutput = AVCaptureStillImageOutput()
  var cameraOutput = AVCapturePhotoOutput()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    captureSession.sessionPreset=AVCaptureSessionPresetPhoto
    
    
  }
  
  func frontCamera(_ front:Bool) {
    let devices = AVCaptureDevice.devices()
    
    do {
      try captureSession.removeInput(AVCaptureDeviceInput(device: captureDevice))
      
      
    } catch {
      print("Error")
    }
    
    for device in devices! {
      if((device as AnyObject).hasMediaType(AVMediaTypeVideo)){
        
      }
    }
  }
  
  @IBAction func activatedFlash(_ sender: Any) {
  }

  @IBAction func capturePicture(_ sender: Any) {
  }

  @IBAction func changePicture(_ sender: Any) {
  }
}
