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
    var foaasPathBuilder: FoaasPathBuilder?
    
    var targetURL: URL {
        // Your code crashes if the url contains a space, addingPercentEncoding is needed
        return URL(string: "https://www.foaas.com\(foaasPathBuilder!.build())".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!
    }
    
    override func viewDidLoad() {
        if let previewOperation = operation {
            self.navigationItem.title = previewOperation.name
            self.foaasPathBuilder = FoaasPathBuilder(operation: previewOperation)
        }
        // we want to be able to let users back out at this point, i realize that isn't what the storyboard shows though
        self.navigationItem.hidesBackButton = false
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
        //An array of all of the keys, could be used to iterate through this instead of switching maybe?
        guard let key = foaasPathBuilder?.allKeys() else { return }
        guard let validText = textField.text else { return }
        if textField.text!.isEmpty {
            //this resets the dictionary back to the original parameters
            foaasPathBuilder?.update(key: textField.placeholder!, value: ":\(textField.placeholder!)")
        } else {
            switch textField {
            case nameTextField:
                self.foaasPathBuilder!.update(key: key[0], value: validText)
            case fromTextField:
                self.foaasPathBuilder!.update(key: key[1], value: validText)
            case referenceTextField:
                self.foaasPathBuilder!.update(key: key[2], value: validText)
            default:
                print("Report Bug")
            }
        }
        loadPreview(url: self.targetURL)
    }
    
    
    func loadPreview(url: URL) {
        /*
         Nice working solution. We'll need to consider how to update this more dynamically in the future
         (like say we suddenly have 10+ potential text fields to show/hide). Part of our work on this
         project will take a look at this.
         */
        
        FoaasDataManager.shared.getFoaas(url: url, completion: { (foaas: Foaas?) in
            DispatchQueue.main.async {
               //this switches on the count of the fields arr, although it doesn't account for more than 3 parameters.
                guard let fieldsArray = self.foaasPathBuilder?.allKeys() else { return }
                self.foaas = foaas
                self.previewTextView.text = foaas?.description.filterBadLanguage(false)
                switch fieldsArray.count {
                case 2:
                    self.nameLabel.text = ":\(fieldsArray[0])"
                    self.nameTextField.placeholder = "\(fieldsArray[0])"
                    self.fromLabel.text = ":\(fieldsArray[1])"
                    self.fromTextField.placeholder = "\(fieldsArray[1])"
                    
                    self.referenceLabel.isHidden = true
                    self.referenceTextField.isHidden = true
                case 3:
                    self.nameLabel.text = ":\(fieldsArray[0])"
                    self.nameTextField.placeholder = "\(fieldsArray[0])"
                    self.fromLabel.text = ":\(fieldsArray[1])"
                    self.fromTextField.placeholder = "\(fieldsArray[1])"
                    self.referenceLabel.text = ":\(fieldsArray[2])"
                    self.referenceTextField.placeholder = "\(fieldsArray[2])"
                    
                default:
                    self.nameLabel.text = ":\(fieldsArray[0])"
                    self.nameTextField.placeholder = "\(fieldsArray[0])"
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
        updateText(textField)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        updateText(textField)
        return true
    }
    @IBAction func selectButtonTapped(_ sender: UIBarButtonItem) {
        // Nicely done
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name: Notification.Name(rawValue: "FoaasObjectDidUpdate"), object: self.foaas)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func didTapGesture(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
