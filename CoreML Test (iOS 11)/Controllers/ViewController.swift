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

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    //Image picker is for the controller
    //Remember to add privacy settings for camera and photolibrary in Info.plist
    //Make sure to have imageView in aspect fit
    //Make sure to clip bounds so image doesn't stretch the screen
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView! //Connect imageView to imageView
    
    let imagePicker = UIImagePickerController()
    var resultData: Data!
    var confidenceValues = [String](repeating: "", count: 10)
    var identifiers = [String](repeating: "", count: 10)
    var loaded = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultData = Data()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 70
        tableView.reloadData()
        
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
            
            //We use guard here over if let, prevents us from continuing
            guard let ciimage = CIImage(image: userPickedImage) else {
                fatalError("Could not convert image")
            }
            
            detect(image: ciimage)
            
        }

        imagePicker.dismiss(animated: true, completion: nil) //Dismiss the imagePicker
    }
    
    //Attempts to make a request
    func detect(image: CIImage) {
        
        //loads the CoreMLModel for Inceptionv3
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Loading CoreML Failed")
        }
        
        
        //Define what a request to the model looks like
        let request = VNCoreMLRequest(model: model) {(request, error) in
            
            //We use guard here because the program shouldn't continue if we can't classify
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process image.")
            }

            for index in 0...9 {
                self.confidenceValues[index] = (String(format: "%.2f", results[index].confidence * 100) + "%")
                //Check rounding documentation for more info
                self.identifiers[index] = (results[index].identifier.capitalized)
            }
            //We get the top 10 values by doing a for loop
            //Identifier gives the string result for the keywords (which can be more than one)
            //Such as keyboard, keypad
            //Confidence returns the confidence rating
            //We format the values to two decimal places

        }
        
        //Create a request handler
        let handler = VNImageRequestHandler(ciImage: image)
        
        //Call the request
        do {
            try handler.perform([request])
            loaded = true
            tableView.reloadData()
        } catch {
            print(error)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(loaded){
            if let cell = tableView.dequeueReusableCell(withIdentifier: "DataCell", for: indexPath) as? DataTableViewCell {
                cell.confidenceText.text = confidenceValues[indexPath.row]
                cell.guessText.text = identifiers[indexPath.row]
                return cell
                
            }
        }
        
        return DataTableViewCell()
    
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

