//
//  DetailViewController.swift
//  BYT-liamdkane
//
//  Created by C4Q on 11/26/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var previewTextView: UITextView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var referenceTextField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var referenceLabel: UILabel!
    
    @IBOutlet weak var scrollViewBottomContraint: NSLayoutConstraint!
    var operation: FoaasOperation?
    var foaas: Foaas?
    
    
    var url: String = ""

    var targetURL: URL {
        // Your code crashes if the url contains a space, addingPercentEncoding is needed
        return URL(string: "https://www.foaas.com\(url)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!
    }
    
    override func viewDidLoad() {
<<<<<<< HEAD
        super.viewDidLoad()
        if let o = operation {
            self.navigationItem.title = o.name
=======
        // More descriptive var names
        if let previewOperation = operation {
            self.navigationItem.title = previewOperation.name
>>>>>>> da989d5f9179a440b7dec75f89e96fd2a1d96773
        }
        
        // we want to be able to let users back out at this point, i realize that isn't what the storyboard shows though
        self.navigationItem.hidesBackButton = false
        self.url = (operation?.url)!
        loadPreview(url: self.targetURL)
        setUpNotifications()
        
    }
    
    //MARK: -Keyboard Methods
    
    func setUpNotifications () {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    //StackOverflow Source: http://stackoverflow.com/questions/26070242/move-view-with-keyboard-using-swift
    
    func keyboardWillShow(notification: NSNotification) {
         print("keyboard up")
            let keyboardSize = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue
        self.scrollViewBottomContraint.constant = (keyboardSize?.cgRectValue.height)!
    }
    
    func keyboardWillHide(notification: NSNotification) {
        print("keyboard down")
        self.scrollViewBottomContraint.constant = 0
    }
    
    //MARK: - Text Upate Methods
    
    func updateText (_ textField: UITextField) {
        switch textField {
        case nameTextField:
            self.url = self.url.replacingOccurrences(of: nameLabel.text! , with: nameTextField.text!)
        case fromTextField:
            self.url = self.url.replacingOccurrences(of: fromLabel.text! , with: fromTextField.text!)
        case referenceTextField:
            self.url = self.url.replacingOccurrences(of: referenceLabel.text! , with: referenceTextField.text!)
        default:
            print("Report Bug")
        }
        loadPreview(url: self.targetURL)
<<<<<<< HEAD
        
=======
>>>>>>> da989d5f9179a440b7dec75f89e96fd2a1d96773
    }
  
  
    func loadPreview(url: URL) {
        /*
            Nice working solution. We'll need to consider how to update this more dynamically in the future
            (like say we suddenly have 10+ potential text fields to show/hide). Part of our work on this 
            project will take a look at this.
        */
        
        FoaasAPIManager.getFoaas(url: url, completion: { (foaas: Foaas?) in
            DispatchQueue.main.async {
                
                // fully descriptive vars, spaces around brackets always
                guard let fieldsArray = self.operation?.fields else { return }
                self.foaas = foaas
                self.previewTextView.text = foaas?.description
                switch self.operation!.fields.count {
                case 2:
                    self.nameLabel.text = ":\(fieldsArray[0].name.lowercased())"
                    self.nameTextField.placeholder = "\(fieldsArray[0].name.lowercased())"
                    self.fromLabel.text = ":\(fieldsArray[1].name.lowercased())"
                    self.fromTextField.placeholder = "\(fieldsArray[1].name.lowercased())"
                    
                    self.referenceLabel.isHidden = true
                    self.referenceTextField.isHidden = true
                case 3:
                    self.nameLabel.text = ":\(fieldsArray[0].name.lowercased())"
                    self.nameTextField.placeholder = "\(fieldsArray[0].name.lowercased())"
                    self.fromLabel.text = ":\(fieldsArray[1].name.lowercased())"
                    self.fromTextField.placeholder = "\(fieldsArray[1].name.lowercased())"
                    self.referenceLabel.text = ":\(fieldsArray[2].name.lowercased())"
                    self.referenceTextField.placeholder = "\(fieldsArray[2].name.lowercased())"
                    
                default:
                    self.nameLabel.text = ":\(fieldsArray[0].name.lowercased())"
                    self.nameTextField.placeholder = "\(fieldsArray[0].name.lowercased())"
                    self.fromTextField.isHidden = true
                    
                    self.fromLabel.isHidden = true
                    self.fromTextField.isHidden = true
                    self.referenceLabel.isHidden = true
                    self.referenceTextField.isHidden = true
                }
            }
        })
    }
    
    //MARK: - Text Field Delegate Methods
    
    // why is updateText called second here, but 1st in textFieldShouldReturn?
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text!.isEmpty {
            self.url = operation!.url
        }
        updateText(textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        updateText(textField)
        if textField.text!.isEmpty {
            self.url = operation!.url
        }
        return true
    }
    @IBAction func selectButtonTapped(_ sender: UIBarButtonItem) {
<<<<<<< HEAD
        
=======
        // Nicely done
>>>>>>> da989d5f9179a440b7dec75f89e96fd2a1d96773
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name: Notification.Name(rawValue: "FoaasObjectDidUpdate"), object: self.foaas)
        dismiss(animated: true, completion: nil)
    }
<<<<<<< HEAD
    @IBAction func didTapGesture(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
=======

>>>>>>> da989d5f9179a440b7dec75f89e96fd2a1d96773
}
