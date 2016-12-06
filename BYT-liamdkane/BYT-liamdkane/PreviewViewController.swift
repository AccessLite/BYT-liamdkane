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
        return URL(string: "https://www.foaas.com\(url)")!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let o = operation {
            self.navigationItem.title = o.name
        }
        self.navigationItem.hidesBackButton = true
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
        
    }
    
    func loadPreview(url: URL) {
        FoaasAPIManager.getFoaas(url: url, completion: { (foaas: Foaas?) in
            DispatchQueue.main.async {
                guard let fieldsArr = self.operation?.fields else {return}
                self.foaas = foaas
                self.previewTextView.text = foaas?.description
                switch self.operation!.fields.count {
                case 2:
                    self.nameLabel.text = ":\(fieldsArr[0].name.lowercased())"
                    self.nameTextField.placeholder = "\(fieldsArr[0].name.lowercased())"
                    self.fromLabel.text = ":\(fieldsArr[1].name.lowercased())"
                    self.fromTextField.placeholder = "\(fieldsArr[1].name.lowercased())"
                    
                    self.referenceLabel.isHidden = true
                    self.referenceTextField.isHidden = true
                case 3:
                    self.nameLabel.text = ":\(fieldsArr[0].name.lowercased())"
                    self.nameTextField.placeholder = "\(fieldsArr[0].name.lowercased())"
                    self.fromLabel.text = ":\(fieldsArr[1].name.lowercased())"
                    self.fromTextField.placeholder = "\(fieldsArr[1].name.lowercased())"
                    self.referenceLabel.text = ":\(fieldsArr[2].name.lowercased())"
                    self.referenceTextField.placeholder = "\(fieldsArr[2].name.lowercased())"
                    
                default:
                    self.nameLabel.text = ":\(fieldsArr[0].name.lowercased())"
                    self.nameTextField.placeholder = "\(fieldsArr[0].name.lowercased())"
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
