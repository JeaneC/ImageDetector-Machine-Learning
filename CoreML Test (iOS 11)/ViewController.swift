//
//  ViewController.swift
//  CoreML Test (iOS 11)
//
//  Created by Jeane Carlos on 8/10/17.
//  Copyright © 2017 jisy. All rights reserved.
//
//  For future reference... this document will be heavily coded

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //Image picker is for the controller
    //Remember to add privacy settings for camera and photolibrary in Info.plist
    //Make sure to have imageView in aspect fit
    //Make sure to clip bounds so image doesn't stretch the screen
    
    @IBOutlet weak var imageView: UIImageView! //Connect imageView to imageView
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType =  .camera
        imagePicker.allowsEditing = true
        //Can choose between camera or photo library, have camera as default
        //these things need to be initialized at load
    }

    //Afer the user finishes picking a photo
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let userPickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = userPickedImage
            
            guard let ciimage = CIImage(image: userPickedImage) else {
                fatalError("Could not convert image")
            }
            
            
            //We use guard here over if let, prevents us from continuing
            
            
        }
        
        imagePicker.dismiss(animated: true, completion: nil) //Dismiss the imagePicker
    }
    
    @IBAction func tappedSearch(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func tappedCamera(_ sender: UIBarButtonItem) {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
}

