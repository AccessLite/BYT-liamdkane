//
//  MainPageViewController.swift
//  BYT-liamdkane
//
//  Created by C4Q on 11/26/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class MainPageViewController: UIViewController {
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    
    var foassEndPoint: String = "https://www.foaas.com/awesome/BYT%20Team"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getSetFoaas()
        registerForNotifications()
    }
    
    // MARK: Methods
    
    func getSetFoaas() {
        guard let foassURL: URL = URL(string: self.foassEndPoint) else {return}
        FoaasAPIManager.getFoaas(url: foassURL) { (foass: Foaas?) in
            if let f = foass {
                DispatchQueue.main.async {
                    self.messageLabel.text = f.message
                    self.fromLabel.text = "From,\n" + f.subtitle
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    internal func registerForNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(updateFoaas(sender:)), name: Notification.Name(rawValue: "FoaasObjectDidUpdate"), object: nil)
    }
    
    func updateFoaas(sender: Notification) {
        if let notificationBundel = sender.object {
            if let foaasObject = notificationBundel as? Foaas {
                self.messageLabel.text = foaasObject.message
                self.fromLabel.text = "From,\n" + foaasObject.subtitle
                
            }
        }
    }
    
    
    @IBAction func octoButtonTouched(_ sender: UIButton) {
        let newTransform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        let originalTransform = sender.imageView!.transform
        
        UIView.animate(withDuration: 0.1, animations: {
            sender.transform = newTransform
        }, completion: { (complete) in
            sender.transform = originalTransform
        })
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "operationsSegue" {
            print("working?")
            //pass nothing
        }
    }
}
