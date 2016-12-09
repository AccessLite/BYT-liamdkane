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
    var currentFoaas: Foaas?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.requestFoaas(url: foassEndPoint)
        self.registerForNotifications()
    }
    
    // MARK: Methods
    func updateUI(using foaas: Foaas) {
        DispatchQueue.main.async {
            self.messageLabel.text = foaas.message.filterBadLanguage(false)
            self.fromLabel.text = "From,\n" + foaas.subtitle.filterBadLanguage(false)
        }
    }
    
    func requestFoaas(url: URL) {
        FoaasDataManager.shared.getFoaas(url: foassEndPoint) { (foass: Foaas?) in
            if let validFoaas = foass {
                self.currentFoaas = validFoaas
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
        if let notificationBundle = sender.object as? Foaas {
            self.updateUI(using: notificationBundle)
        }
    }
    
    @IBAction func screenTappedShort(_ sender: UITapGestureRecognizer) {
        let avc = UIActivityViewController.init(activityItems: [currentFoaas?.description ?? "I'm a moron that doesn't know how to insult properly."], applicationActivities: nil)
        present(avc, animated: true, completion: nil)
    }
    
    @IBAction func longPressed(_ sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.began {
            print("working")
            UIGraphicsBeginImageContextWithOptions(view.frame.size, false, UIScreen.main.scale)
            view.layer.render(in: UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            //Save it to the camera roll
            UIImageWriteToSavedPhotosAlbum(image!, self, #selector(createScreenShotCompletion(image:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    internal func createScreenShotCompletion(image: UIImage, didFinishSavingWithError: NSError?, contextInfo: UnsafeMutableRawPointer?) {
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        var alert: UIAlertController
        
        // present appropriate message in UIAlertViewController
        if didFinishSavingWithError != nil {
            alert = UIAlertController(title: "Error", message: "There was an issue saving the screenshot to the camera roll", preferredStyle: .alert)
        }
        else {
            alert = UIAlertController(title: "Screenshot Taken!", message: "Image saved to camera roll", preferredStyle: .alert)
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        
        
        // double check that the image actually gets saved to the camera roll
    }
    
    
    
    @IBAction func octoButtonTouchedDown(_ sender: UIButton) {
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
            print("working!!!")
            //pass nothing
        }
    }
}
