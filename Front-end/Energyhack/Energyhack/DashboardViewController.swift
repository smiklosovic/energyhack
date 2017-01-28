//
//  ViewController.swift
//  Energyhack
//
//  Created by Alexey Potapov on 27/01/2017.
//  Copyright © 2017 Community. All rights reserved.
//

import UIKit
import Alamofire

class DashboardViewController: UIViewController {

    let AGNotificationCellIdentifier = "AGNotificationCell"
    var isRegistered = false
    var messages: Array<String> = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var datePickerCallerButton: UIButton!
    @IBOutlet weak var adviceCallerButton: UIButton!
    var datePickerView: UIDatePicker?
    
    @IBAction func presentDatePicker() {
        
    }
    
    @IBAction func presentAdviceVC() {
        performSegue(withIdentifier: "adviceScreenSegue", sender: self)
    }
    
    @IBAction func present() {
        Alamofire.request("http://miklosovic.net:8080/api/distributors").responseJSON { response in
            print(response.request ?? "request: nil")  // original URL request
            print(response.response ?? "response: nil") // HTTP URL response
            print(response.data ?? "data: nil")     // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(DashboardViewController.registered), name: Notification.Name(rawValue:"success_registered"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DashboardViewController.errorRegistration), name: Notification.Name(rawValue:"error_register"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DashboardViewController.messageReceived(notification:)), name: Notification.Name(rawValue:"message_received"), object: nil)
       
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "DashboardInfoViewCell", bundle: nil), forCellReuseIdentifier: "DashboardInfoViewCell")
        datePickerView = UIDatePicker()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepareForSegueName: \(segue.identifier)")
    }
}

extension DashboardViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardInfoViewCell", for: indexPath) as! DashboardInfoViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 114
    }
}

extension DashboardViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "dashboardInfoSegue", sender: tableView.cellForRow(at: indexPath))
    }

}
