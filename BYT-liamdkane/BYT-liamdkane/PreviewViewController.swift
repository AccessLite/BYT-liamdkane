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
    var url: String {
        return operation?.url ?? ""
    }
    var targetURL: URL {
        return URL(string: "https://www.foaas.com\(url)")!
    }
    
    override func viewDidLoad() {
        if let o = operation {
            self.navigationItem.title = o.name
        }
        loadPreview(url: self.targetURL)
        print(targetURL.absoluteString)
    }
    
    func updateText (_ textField: UITextField) {
        guard let opURL = operation?.url else {return}
        switch textField {
        case nameTextField:
            let url = opURL.replacingOccurrences(of: ":name", with: nameTextField.text!)
            let newURL: URL = URL(string: "https://www.foaas.com\(url)")!
            print(url)
            loadPreview(url: newURL)
        case fromTextField:
            let url = opURL.replacingOccurrences(of: ":from", with: fromTextField.text!)
            let newURL: URL = URL(string: "https://www.foaas.com\(url)")!
            print(url)
            loadPreview(url: newURL)
        case referenceTextField:
            let url = opURL.replacingOccurrences(of: ":reference", with: referenceTextField.text!)
            let newURL: URL = URL(string: "https://www.foaas.com\(url)")!
            print(url)
            loadPreview(url: newURL)
        default:
            print("Report Bug")
        }

    }
    
    func loadPreview(url: URL) {
        FoaasAPIManager.getFoaas(url: url, completion: { (foass: Foaas?) in
            DispatchQueue.main.async {
                guard let fieldsArr = self.operation?.fields else {return}
                self.previewTextView.text = foass?.description
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
        updateText(textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        updateText(textField)
        return true
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
