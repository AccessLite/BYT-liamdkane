//
//  DetailViewController.swift
//  BYT-liamdkane
//
//  Created by C4Q on 11/26/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var previewTextView: UITextView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var referenceTextField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var referenceLabel: UILabel!
    
    var operation: FoaasOperation?
    var foaas: Foaas?
    
    
    var url: String = ""

    var targetURL: URL {
        // Your code crashes if the url contains a space, addingPercentEncoding is needed
        return URL(string: "https://www.foaas.com\(url)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!
    }
    
    override func viewDidLoad() {
        // More descriptive var names
        if let previewOperation = operation {
            self.navigationItem.title = previewOperation.name
        }
        
        // we want to be able to let users back out at this point, i realize that isn't what the storyboard shows though
        self.navigationItem.hidesBackButton = false
        self.url = (operation?.url)!
        loadPreview(url: self.targetURL)
    }
    
    //MARK - Methods
    
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
        // Nicely done
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name: Notification.Name(rawValue: "FoaasObjectDidUpdate"), object: self.foaas)
        dismiss(animated: true, completion: nil)
    }

}
