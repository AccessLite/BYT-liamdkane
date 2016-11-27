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

    var currentFoaas: Foaas?
    var foassEndPoint: String = "https://www.foaas.com/awesome/BYT%20Team"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getSetFoaas()
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
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "operationsSegue" {
            print("working?")
            //pass nothing
        }
    }
}
