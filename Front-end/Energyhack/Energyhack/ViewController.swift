//
//  ViewController.swift
//  Energyhack
//
//  Created by Alexey Potapov on 27/01/2017.
//  Copyright © 2017 Community. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    let AGNotificationCellIdentifier = "AGNotificationCell"
    var isRegistered = false
    var messages: Array<String> = []
   
    @IBAction func getSomeData() {
        Alamofire.request("http://miklosovic.net:8080/api/distributors").responseJSON { response in
            print(response.request ?? "request: nil")  // original URL request
            print(response.response ?? "response: nil") // HTTP URL response
            print(response.data ?? "data: nil")     // server data
            print(response.result ?? "result: nil")   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.registered), name: Notification.Name(rawValue:"success_registered"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.errorRegistration), name: Notification.Name(rawValue:"error_register"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.messageReceived(notification:)), name: Notification.Name(rawValue:"message_received"), object: nil)
    }
    
    func registered() {
        print("registered")
        
        // workaround to get messages when app was not running
        let defaults: UserDefaults = UserDefaults.standard
        if(defaults.object(forKey: "message_received") != nil) {
            let msg = defaults.object(forKey: "message_received") as? String
            defaults.removeObject(forKey: "message_received")
            defaults.synchronize()
            
            if let msg = msg {
                messages.append(msg)
            }
        }
        
        isRegistered = true
//        tableView.reloadData()
    }

    
    func errorRegistration() {
        let message = UIAlertController(title: "Registration Error!", message: "Please verify the provisionioning profile and the UPS details have been setup correctly.", preferredStyle:  .alert)        
        self.present(message, animated:true, completion:nil)
    }
    
    func messageReceived(notification: Notification) {
        print("received")
        
        let aps = notification.userInfo?["aps"] as? [String : AnyObject]
        let obj = aps?["alert"]
        
        if let msg = obj as? String {
            messages.append(msg)
        } else {
            let msg = obj!["body"] as! String
            messages.append(msg)
        }
//        tableView.reloadData()
    }
}

