//
//  ViewController.swift
//  Energyhack
//
//  Created by Alexey Potapov on 27/01/2017.
//  Copyright © 2017 Community. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

class DashboardViewController: UIViewController {

    var isRegistered = false
    var messages: Array<String> = []
    var datePickerView: MonthPickerView?
    var currentMonth: Int?
    var refreshControl: UIRefreshControl?
    var monthOverviewModel: MonthOverviewModel?
    var months = ["Január","Február","Marec","Apríl","Máj","Jún","Júl","August","September","Október","November","December"]
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var datePickerCallerButton: UIButton!
    @IBOutlet weak var adviceCallerButton: UIButton!
    
    @IBAction func presentDatePicker() {
        datePickerView = MonthPickerView.loadFromNibNamed(nibNamed: "MonthPickerView") as! MonthPickerView?
        datePickerView?.months = months
        datePickerView?.currentMonth = currentMonth
        datePickerView?.frame = CGRect(x: 0, y: view.bounds.size.height - (datePickerCallerButton.bounds.size.height * 4), width: view.bounds.size.width, height: datePickerCallerButton.bounds.size.height * 4)
        view.addSubview(datePickerView!)
        view.bringSubview(toFront: datePickerView!)
    }
    
    @IBAction func presentAdviceVC() {
        performSegue(withIdentifier: "adviceScreenSegue", sender: self)
    }
    
    func reloadEnergyData() {
        
        Alamofire.request("http://marekkraus.sk:7777/getMonthOverview.json?month=\(currentMonth! + 1)").responseObject { [unowned self] (response: DataResponse<MonthOverviewModel>) in
            
            self.monthOverviewModel = response.result.value
            print("response: \(self.monthOverviewModel?.consuptionPrice!)")
            self.performSelector(onMainThread: #selector(DashboardViewController.reloadData), with: nil, waitUntilDone: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(DashboardViewController.selectMonth), name: Notification.Name(rawValue:"current_month"), object: nil)
        currentMonth = 1
        NotificationCenter.default.addObserver(self, selector: #selector(DashboardViewController.registered), name: Notification.Name(rawValue:"success_registered"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DashboardViewController.errorRegistration), name: Notification.Name(rawValue:"error_register"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DashboardViewController.messageReceived(notification:)), name: Notification.Name(rawValue:"message_received"), object: nil)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.backgroundColor = UIColor.white
        tableView.refreshControl?.tintColor = UIColor.black
        tableView.refreshControl?.addTarget(self, action: #selector(DashboardViewController.reloadEnergyData), for: .valueChanged)
        
        tableView.register(UINib(nibName: "DashboardInfoViewCell", bundle: nil), forCellReuseIdentifier: "DashboardInfoViewCell")
        datePickerCallerButton.setTitle("Mesiac: \(months[0])", for: .normal)
        adviceCallerButton.setTitle("Zniž svoje náklady", for: .normal)
        
        reloadEnergyData()
    }
   
    func selectMonth(notification: Notification) {
        if let monthNumber = notification.userInfo?["current_month"] as? Int {
            currentMonth = monthNumber
            datePickerCallerButton.setTitle("Mesiac: \(months[monthNumber])", for: .normal)
            reloadEnergyData()
        }
    }
    
    func reloadData() {
    
        if let refreshControl = tableView.refreshControl {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, h:mm a"
            let title = "Last update:\(formatter.string(from: Date()))" //[formatter stringFromDate:[NSDate date]]];
            let attrsDictionary =  [NSForegroundColorAttributeName:UIColor.black]
            let attributedTitle = NSAttributedString(string: title, attributes: attrsDictionary)
            refreshControl.attributedTitle = attributedTitle
            refreshControl.endRefreshing()
        }
        
        tableView.reloadData()
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
        reloadEnergyData()
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
        reloadEnergyData()
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
        if let _ = monthOverviewModel {
            return 4
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let monthOverviewModel = monthOverviewModel else { fatalError("model was lost!") }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardInfoViewCell", for: indexPath) as! DashboardInfoViewCell
        
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "Spotreba"
            cell.currentAmountLabel.text = "ku dnešnému dňu: \(round(100 * monthOverviewModel.consuptionPrice!.amount!)/100) €"
        case 1:
            cell.titleLabel.text = "Pokuta za jalovú elektrinu"
            cell.currentAmountLabel.text = "ku dnešnému dňu: \(round(100 * monthOverviewModel.reactivePrice!.amount!)/100) €"
        case 2:
            cell.titleLabel.text = "Pokuta za prekročenie rezervy"
            cell.currentAmountLabel.text = "ku dnešnému dňu: \(round(100 * monthOverviewModel.reservedPrice!.amount!)/100) €"
        case 3:
            cell.titleLabel.text = "Faktúra za tento mesiac"
            cell.currentAmountLabel.text = "ku dnešnému dňu: \(round(100 * monthOverviewModel.finalPrice!.amount!)/100) €"
        default:
            break
        }
        
        cell.selectionStyle = .none
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
