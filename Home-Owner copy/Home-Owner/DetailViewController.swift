 //
//  DetailViewController.swift
//  Home-Owner
//
//  Created by Vo Huy on 5/14/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import UIKit
 
 class DetailViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var imageStore: ImageStore!
    var item: Item! {
        didSet {
            navigationItem.title = item.name
        }
    }
    
    let numberFormatter: NumberFormatter = {
        let fm = NumberFormatter()
        fm.numberStyle = .decimal
        fm.minimumFractionDigits = 2
        fm.maximumFractionDigits = 2
        return fm
    }()
    
    let dateFormatter: DateFormatter = {
        let fm = DateFormatter()
        fm.dateStyle = .medium
        fm.timeStyle = .none
        return fm
    }()
    
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var serialNumberField: UITextField!
    @IBOutlet var valueField: UITextField!
    @IBOutlet var dateCreatedLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var clearImageButton: UIBarButtonItem!
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.delegate = self
        serialNumberField.delegate = self
        valueField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nameField.text = item.name
        serialNumberField.text = item.serialNumber
        valueField.text = numberFormatter.string(from: NSNumber(value: item.valueInDollars))
        dateCreatedLabel.text = dateFormatter.string(from: item.dateCreated)
        if let image = imageStore.getImage(forKey: item.itemKey) {
            imageView.image = image
            clearImageButton.isEnabled = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
        item.name = nameField.text ?? ""
        item.serialNumber = serialNumberField.text
        
        if let valueText = valueField.text,
            let value = numberFormatter.number(from: valueText) {
            item.valueInDollars = value.doubleValue
        } else {
            item.valueInDollars = 0
        }
    }
    
    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showDate":
            let dateCreatedViewController = segue.destination as! DateCreatedViewController
            dateCreatedViewController.item = self.item
        default:
            preconditionFailure("Unexpected segue identifer")
        }
    }
    
     // MARK: User Interaction
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func takePicture(_ sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func clearImage(_ sender: UIBarButtonItem) {
        imageStore.removeImage(forKey: item.itemKey)
        imageView.image = nil
        clearImageButton.isEnabled = false
    }
 }
 
 // MARK: - TextFieldDelegate
 extension DetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
 }
 
 // MARK: - Image Picker
 extension DetailViewController {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        
        imageStore.setImage(image, forKey: item.itemKey)
        imageView.image = image
        clearImageButton.isEnabled = true
        dismiss(animated: true, completion: nil)
    }

 }
 
// class DetailViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
//
//
//    @IBOutlet weak var nameField: customTextField!
//    @IBOutlet weak var serialField: customTextField!
//    @IBOutlet weak var valueField: customTextField!
//    @IBOutlet weak var dateLabel: customTextField!
//    @IBOutlet var  imageView: UIImageView!
//    @IBOutlet var removeImgBtn: UIButton!
//
//
//    var item: Item! {
//        didSet {
//            navigationItem.title = item.name
//        }
//    }
//
//    var imageStore: ImageStore!
//
//    // formatter for money
//    let numberFormatter: NumberFormatter = {
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .decimal
//        formatter.minimumFractionDigits = 2
//        formatter.maximumFractionDigits = 2
//        return formatter
//    }()
//
//    // formatter for date
//    let dateFormatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        formatter.timeStyle = .none
//        return formatter
//    }()
//
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//
//
//
//        // display the item's info
//        nameField.text = item.name
//        serialField.text = item.serialNumber
//        valueField.text = numberFormatter.string(from: NSNumber(value: item.valueInDollars))
//        dateLabel.text = dateFormatter.string(from: item.dateCreated)
//
//        // Get the item key
//        let key = item.itemKey
//
//        // If there is an associated image with the item, display it
//        if let image = imageStore.image(forKey: key) {
//            imageView.image = image
//            removeImgBtn.isEnabled = true
//        } else {
//            removeImgBtn.isEnabled = false
//        }
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        // clear first responder
//        view.endEditing(true)
//
//        // Save changes to the item
//        item.name = nameField.text ?? ""
//        item.serialNumber = serialField.text
//        if let valueText = valueField.text,
//            let value = numberFormatter.number(from: valueText) {
//            item.valueInDollars = value.doubleValue
//        } else {
//            item.valueInDollars = 0
//        }
//    }
//
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        switch segue.identifier {
//        case "changeDate":
//            let dateCreatedViewController = segue.destination as! DateCreatedViewController
//            dateCreatedViewController.item = item
//        default:
//            preconditionFailure("Unexpected segue identifier")
//        }
//    }
//
//
//
//    // when the user is entering input
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if textField == valueField {
//
//            // avoid enter text in money value
//            if string.rangeOfCharacter(from: NSCharacterSet.letters) != nil {
//                return false
//            }
//
//            // decimal separator of the region
//            let currentLocale = Locale.current
//            let decimalSeparator = currentLocale.decimalSeparator ?? "."
//
//            let existingTextHasDecimalSeparator = textField.text?.range(of: decimalSeparator)
//            let replacementTextDecimalSeparator = string.range(of: decimalSeparator)
//
//            if existingTextHasDecimalSeparator != nil, replacementTextDecimalSeparator != nil {
//                return false
//            } else {
//                return true
//            }
//        }
//        return true
//    }
//    // when the Return button is pressed on a text field
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        // tigger the changes for the tittle when the return is pressed
//        if textField == nameField {
//            navigationItem.title = textField.text
//        }
//        return true
//    }
//
//    // after the user took a picture or chose an image
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//
//        // Get picked image from info dictionary
//        let image = info[UIImagePickerControllerEditedImage] as! UIImage
//
//        // Store the image in the ImageStore for the item's key
//        imageStore.setImage(image, forKey: item.itemKey)
//
//        // Put the image on the screen in the image view
//        imageView.image = image
//
//        // Take image picker off the screen
//        dismiss(animated: true, completion: nil)
//    }
//
//    @IBAction func backgroundTapped(_ sender: Any) {
//        // clear first responder when the users tap on the screen
//        view.endEditing(true)
//    }
//
//    @IBAction func takePicture(_ sender: Any) {
//
//        let imagePicker = UIImagePickerController()
//
//        // set up the image picker
//        // if the device has a camera, take a picture; otherwise, choose one from the library
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//            imagePicker.sourceType = .camera
//
//            // creating a crosshair
//            let overlayView = UIView(frame: imagePicker.cameraOverlayView!.frame)
//
//            let crosshairLabel = UILabel()
//            crosshairLabel.text = "+"
//            crosshairLabel.font = UIFont.systemFont(ofSize: 50)
//            crosshairLabel.translatesAutoresizingMaskIntoConstraints = false
//            overlayView.addSubview(crosshairLabel)
//            // place the crosshair in the middle
//            crosshairLabel.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor)
//            crosshairLabel.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor)
//
//            // To avoid blocking the underneath default camera controls
//            overlayView.isUserInteractionEnabled = false
//
//            imagePicker.cameraOverlayView = overlayView
//        } else {
//            imagePicker.sourceType = .photoLibrary
//        }
//
//        imagePicker.delegate = self
//        imagePicker.allowsEditing = true
//
//        // Display the image picker on the screen modally
//        present(imagePicker, animated: true, completion: nil)
//    }
//
//    @IBAction func removeImage(_ sender: UIButton) {
//        imageStore.deleteImage(forKey: item.itemKey)
//        imageView.image = nil
//        removeImgBtn.isEnabled = false
//    }
//
// }
