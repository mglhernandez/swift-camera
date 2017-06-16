//
//  ViewController.swift
//  LabCamera
//
//  Created by Miguel Hernandez on 6/14/17.
//  Copyright © 2017 Miguel Hernandez. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import MobileCoreServices

class SimpleOpenCameraViewController: UIViewController {
  
  
  @IBOutlet weak var imageView: UIImageView!
  private var imagePicker : UIImagePickerController!
  
  @IBAction func takePhotoClicked(_ sender: Any) {
    // openCameraOrLibrary()
    openMenuCameraOrLibrary()
  }
  
  func openMenuCameraOrLibrary() {
    
    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    
    if UIImagePickerController.isSourceTypeAvailable((.camera)) {
      let cameraAction = UIAlertAction(title: "Usar Camara", style: .default){(action) in
        
        let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        
        if status == .authorized {
          self.displayPicker(type: .camera)
        }
        if status == .restricted {
          self.handleRestricted()
        }
        if status == .denied {
          self.handleDenied()
        }
        if status == .notDetermined {
          AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted) in
            if(granted) {
              self.imagePicker.cameraDevice = UIImagePickerControllerCameraDevice.front;
              self.displayPicker(type: .camera)
            }
          })
        }
      }
      
      alertController.addAction(cameraAction)
    }
    
    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
      let photoLibraryAction = UIAlertAction(title: "Usar Photo Library", style: .default) {(action) in
        
        PHPhotoLibrary.requestAuthorization({(status) in
          if status == PHAuthorizationStatus.authorized {
            self.displayPicker(type: .photoLibrary)
          }
        })
      }
      
      alertController.addAction(photoLibraryAction)
    }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    
    
    alertController.addAction(cancelAction)
    
    present(alertController, animated: true, completion: nil)
  }
  
  func handleDenied() {
    let alertController = UIAlertController(title: "Media Access Denied", message: "Camera does not have access to use your device's camera. Please update your settings", preferredStyle: .alert)
    
    let settingsAction = UIAlertAction(title: "Go to settings", style: .default){ (action) in
      DispatchQueue.main.async {
        UIApplication.shared.open(NSURL(string: UIApplicationOpenSettingsURLString)! as URL)
      }
    }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    
    alertController.addAction(settingsAction)
    alertController.addAction(cancelAction)
    
    present(alertController, animated: true, completion: nil)
  }
  
  func handleRestricted() {
    let alertController = UIAlertController(title: "Media Access Denied", message: "This device is restricted from accessing any media at this time", preferredStyle: .alert)
    
    let defaulAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    
    alertController.addAction(defaulAction)
    
    present(alertController, animated: true, completion: nil)
  }
  
  
  func displayPicker(type: UIImagePickerControllerSourceType)
  {
    self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: type)!
    
    if type == .camera {
      self.imagePicker.sourceType = type
      self.imagePicker.cameraCaptureMode = .photo
      self.imagePicker.cameraDevice = .front;
      self.imagePicker.setNavigationBarHidden(true, animated: true)
      self.imagePicker.setToolbarHidden( true, animated: true)
    }
    
    
    self.imagePicker.sourceType = type
    self.imagePicker.allowsEditing = true
    
    DispatchQueue.main.async {
      self.present(self.imagePicker, animated: true, completion: nil)
    }
  }
  
  
  func openCameraOrLibrary() {
    imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      imagePicker.sourceType = .camera
    } else {
      imagePicker.sourceType = .photoLibrary
    }
    
    imagePicker.allowsEditing = true
    imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: imagePicker.sourceType)!
    
    self.present(imagePicker, animated: true, completion: nil)
  }
  
  
}

extension SimpleOpenCameraViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    self.dismiss(animated: true, completion: nil)
    print("user canceled the camera / photo library")
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    let chosenImage = info[UIImagePickerControllerEditedImage] as? UIImage
    //  let flippedImage = UIImage(CGImage: chosenImage?.cgImage, scale: chosenImage?.scale, orientation: .LeftMirrored)
    
    self.imageView?.contentMode = .scaleAspectFit
    self.imageView.image=chosenImage
    
    self.dismiss(animated: true, completion: nil)
  }
}

