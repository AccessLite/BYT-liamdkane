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

    let foassEndPoint: URL = URL(string: "https://www.foaas.com/awesome/BYT%20Team")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.requestFoaas(url: foassEndPoint)
        self.registerForNotifications()
    }
    
    // MARK: Methods
    func updateUI(using foaas: Foaas) {
        DispatchQueue.main.async {
            self.messageLabel.text = foaas.message
            self.fromLabel.text = "From,\n" + foaas.subtitle
        }
    }
    
    func requestFoaas(url: URL) {
        FoaasAPIManager.getFoaas(url: foassEndPoint) { (foass: Foaas?) in
            if let validFoaas = foass {
                self.updateUI(using: validFoaas)
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
                self.updateUI(using: foaasObject)
            }
        }
    }
}
