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
import Snowflake

class DashboardViewController: UIViewController {

    var isRegistered = false
    var isDropdownOpen = false
    
    var dropdownArrowUpSVG: Document!
    var dropdownArrowDownSVG: Document! // .init(fileName: "dropdown")!
    var infoIconSVG: Document! //.init(fileName: "info")!
    var graphSVG: Document! //.init(fileName: "graph")!
    
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
            self.performSelector(onMainThread: #selector(DashboardViewController.reloadData), with: nil, waitUntilDone: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dropdownArrowUpSVG = Document.init(fileName: "dropdown")!
        dropdownArrowDownSVG = Document.init(fileName: "dropdown")!
        infoIconSVG = Document.init(fileName: "info")!
        graphSVG = Document.init(fileName: "graph")!
        
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
        tableView.register(UINib(nibName: "DashboardInfoHeaderViewCell", bundle: nil), forCellReuseIdentifier: "DashboardInfoHeaderViewCell")
        
        datePickerCallerButton.setTitle("Mesiac: \(months[0])", for: .normal)
        datePickerCallerButton.backgroundColor = UIColor.white
        datePickerCallerButton.setTitleColor(UIColor(red: 255.0/255.0, green: 110.0/255.0, blue: 80.0/255.0, alpha: 1.0), for: .normal)
        datePickerCallerButton.layer.borderWidth = 2.0
        datePickerCallerButton.layer.borderColor = UIColor(red: 255.0/255.0, green: 110.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor
        
        adviceCallerButton.setTitle("Zniž svoje náklady", for: .normal)
        adviceCallerButton.setTitleColor(UIColor.white, for: .normal)
        adviceCallerButton.backgroundColor = UIColor(red: 255.0/255.0, green: 110.0/255.0, blue: 80.0/255.0, alpha: 1.0)
        
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
            let title = "Last update:\(formatter.string(from: Date()))"
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
    
    func toggleSection() {
        isDropdownOpen = !isDropdownOpen
        tableView.reloadData()
    }
}

extension DashboardViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let _ = monthOverviewModel {
            return 2
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = monthOverviewModel {
            switch section {
            case 0:
                return 3
            case 1:
                if isDropdownOpen {
                    return 2
                } else {
                    return 1
                }
            default:
                return 0
            }
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let monthOverviewModel = monthOverviewModel else { fatalError("model was lost!") }
        
        //sorry, generics...
        //hello! CopyPasta! :D
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardInfoHeaderViewCell", for: indexPath) as! DashboardInfoHeaderViewCell
                cell.backgroundColor = UIColor.white

                var text = NSMutableAttributedString(string: "Spotreba")
                text.addAttributes([NSUnderlineStyleAttributeName:NSUnderlineStyle.styleSingle.rawValue, NSForegroundColorAttributeName:UIColor(red: 255.0/255.0, green: 110.0/255.0, blue: 80.0/255.0, alpha: 1.0)], range: NSMakeRange(0, text.length))
                cell.titleLabel.attributedText = text
                cell.currentAmount.text = "ku dnešnému dňu:"
                
                text = NSMutableAttributedString(string: "\(round(100 * monthOverviewModel.consuptionPriceModel!.price!)/100) €")
                text.addAttributes([NSForegroundColorAttributeName:UIColor(red: 77.0/255.0, green: 175.0/255.0, blue: 255.0/255.0, alpha: 1.0)], range: NSMakeRange(0, text.length))
                cell.currentAmountValue.attributedText = text
                cell.predictedAmount.text = "predpokladaná:"
                
                text = NSMutableAttributedString(string: "Y €")
                text.addAttributes([NSForegroundColorAttributeName:UIColor(red: 17.0/255.0, green: 107.0/255.0, blue: 180.0/255.0, alpha: 1.0)], range: NSMakeRange(0, text.length))
                cell.predictedAmountValue.attributedText = text
                
                cell.graphSVGView.addSubview(graphSVG.svg.view(size: cell.graphSVGView.frame.size))
//                cell.graphButton = action
                
                cell.infoSVGView.addSubview(infoIconSVG.svg.view(size: cell.infoSVGView.frame.size))
//                cell.infoButton = action
                
                cell.arrowButton.isHidden = true
                cell.arrowSVGView.isHidden = true
                cell.separatorLine.backgroundColor = UIColor(red: 212.0/255.0, green: 214.0/255.0, blue: 215.0/255.0, alpha: 1.0)
                
                cell.selectionStyle = .none
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardInfoHeaderViewCell", for: indexPath) as! DashboardInfoHeaderViewCell
                cell.backgroundColor = UIColor.white
                
                var text = NSMutableAttributedString(string: "Pokuta za jalovú elektrinu")
                text.addAttributes([NSUnderlineStyleAttributeName:NSUnderlineStyle.styleSingle.rawValue, NSForegroundColorAttributeName:UIColor(red: 255.0/255.0, green: 110.0/255.0, blue: 80.0/255.0, alpha: 1.0)], range: NSMakeRange(0, text.length))
                cell.titleLabel.attributedText = text
                
                cell.currentAmount.text = "ku dnešnému dňu:"
                
                text = NSMutableAttributedString(string: "\(round(100 * monthOverviewModel.reactivePriceModel!.price!)/100) €")
                text.addAttributes([NSForegroundColorAttributeName:UIColor(red: 77.0/255.0, green: 175.0/255.0, blue: 255.0/255.0, alpha: 1.0)], range: NSMakeRange(0, text.length))
                cell.currentAmountValue.attributedText = text
                
                cell.predictedAmount.text = "predpokladaná:"
                text = NSMutableAttributedString(string: "Y €")
                text.addAttributes([NSForegroundColorAttributeName:UIColor(red: 17.0/255.0, green: 107.0/255.0, blue: 180.0/255.0, alpha: 1.0)], range: NSMakeRange(0, text.length))
                cell.predictedAmountValue.attributedText = text
                
                cell.graphSVGView.addSubview(graphSVG.svg.view(size: cell.graphSVGView.frame.size))
                //                cell.graphButton = action
                
                cell.infoSVGView.addSubview(infoIconSVG.svg.view(size: cell.infoSVGView.frame.size))
                //                cell.infoButton = action
                
                cell.arrowButton.isHidden = true
                cell.arrowSVGView.isHidden = true
                cell.separatorLine.backgroundColor = UIColor(red: 212.0/255.0, green: 214.0/255.0, blue: 215.0/255.0, alpha: 1.0)
                
                cell.selectionStyle = .none
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardInfoHeaderViewCell", for: indexPath) as! DashboardInfoHeaderViewCell
                cell.backgroundColor = UIColor.white
                
                var text = NSMutableAttributedString(string: "Pokuta za prekročenie rezervy")
                text.addAttributes([NSUnderlineStyleAttributeName:NSUnderlineStyle.styleSingle.rawValue, NSForegroundColorAttributeName:UIColor(red: 255.0/255.0, green: 110.0/255.0, blue: 80.0/255.0, alpha: 1.0)], range: NSMakeRange(0, text.length))
                cell.titleLabel.attributedText = text
                
                cell.currentAmount.text = "ku dnešnému dňu:"
                
                text = NSMutableAttributedString(string: "\(round(100 * monthOverviewModel.reservedPriceModel!.price!)/100) €")
                text.addAttributes([NSForegroundColorAttributeName:UIColor(red: 77.0/255.0, green: 175.0/255.0, blue: 255.0/255.0, alpha: 1.0)], range: NSMakeRange(0, text.length))
                cell.currentAmountValue.attributedText = text
                
                cell.predictedAmount.text = "predpokladaná:"
                text = NSMutableAttributedString(string: "Y €")
                text.addAttributes([NSForegroundColorAttributeName:UIColor(red: 17.0/255.0, green: 107.0/255.0, blue: 180.0/255.0, alpha: 1.0)], range: NSMakeRange(0, text.length))
                cell.predictedAmountValue.attributedText = text
                
                cell.graphSVGView.addSubview(graphSVG.svg.view(size: cell.graphSVGView.frame.size))
                //                cell.graphButton = action
                
                cell.infoSVGView.addSubview(infoIconSVG.svg.view(size: cell.infoSVGView.frame.size))
                //                cell.infoButton = action
                
                cell.arrowButton.isHidden = true
                cell.arrowSVGView.isHidden = true
                cell.separatorLine.backgroundColor = UIColor(red: 212.0/255.0, green: 214.0/255.0, blue: 215.0/255.0, alpha: 1.0)
                
                cell.selectionStyle = .none
                return cell
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardInfoHeaderViewCell", for: indexPath) as! DashboardInfoHeaderViewCell
                cell.backgroundColor = UIColor.white
                
                var text = NSMutableAttributedString(string: "Celkovo")
                text.addAttributes([NSUnderlineStyleAttributeName:NSUnderlineStyle.styleSingle.rawValue, NSForegroundColorAttributeName:UIColor(red: 255.0/255.0, green: 110.0/255.0, blue: 80.0/255.0, alpha: 1.0)], range: NSMakeRange(0, text.length))
                cell.titleLabel.attributedText = text

                cell.currentAmount.text = "celkovo ku dnešnému dňu:"
                
                text = NSMutableAttributedString(string: "\(round(100 * monthOverviewModel.finalPriceModel!.price!)/100) €")
                text.addAttributes([NSForegroundColorAttributeName:UIColor(red: 77.0/255.0, green: 175.0/255.0, blue: 255.0/255.0, alpha: 1.0)], range: NSMakeRange(0, text.length))
                cell.currentAmountValue.attributedText = text
                
                cell.predictedAmount.text = "predpokladaná faktúra za tento mesiac:"
                
                text = NSMutableAttributedString(string: "Y €")
                text.addAttributes([NSForegroundColorAttributeName:UIColor(red: 17.0/255.0, green: 107.0/255.0, blue: 180.0/255.0, alpha: 1.0)], range: NSMakeRange(0, text.length))
                cell.predictedAmountValue.attributedText = text
                
                cell.graphSVGView.addSubview(graphSVG.svg.view(size: cell.graphSVGView.frame.size))
                //                cell.graphButton = action
                
                cell.infoSVGView.addSubview(infoIconSVG.svg.view(size: cell.infoSVGView.frame.size))
                //                cell.infoButton = action
                
                cell.arrowSVGView.addSubview(dropdownArrowUpSVG.svg.view(size: cell.arrowSVGView.frame.size))
                
                cell.arrowButton.isHidden = false
                cell.arrowButton.addTarget(self, action: #selector(DashboardViewController.toggleSection), for: .touchUpInside)
                cell.arrowSVGView.isHidden = false
                cell.separatorLine.backgroundColor = UIColor(red: 212.0/255.0, green: 214.0/255.0, blue: 215.0/255.0, alpha: 1.0)
                
                cell.selectionStyle = .none
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardInfoViewCell", for: indexPath) as! DashboardInfoViewCell
                
                cell.backgroundColor = UIColor(red: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1.0)
                
                var text = NSMutableAttributedString(string: "Činný odber")
                text.addAttributes([NSUnderlineStyleAttributeName:NSUnderlineStyle.styleSingle.rawValue, NSForegroundColorAttributeName:UIColor(red: 177.0/255.0, green: 177.0/255.0, blue: 177.0/255.0, alpha: 1.0)], range: NSMakeRange(0, text.length))
                
                cell.cinnyOdber.attributedText = text
                cell.cinnyOdberNizkaTarifa.text = "Činný odber, nizka tarifa:"
                
                text = NSMutableAttributedString(string: "\(round(100 * monthOverviewModel.finalPriceModel!.lowConsumptionCost!)/100) €")
                text.addAttributes([NSForegroundColorAttributeName:UIColor(red: 77.0/255.0, green: 175.0/255.0, blue: 255.0/255.0, alpha: 1.0)], range: NSMakeRange(0, text.length))
                cell.cinnyOdberNizkaTarifaValue.attributedText = text
                cell.cinnyOdberVysokaTarifa.text = "Činný odber, výsoka tarifa:"
                
                text = NSMutableAttributedString(string: "\(round(100 * monthOverviewModel.finalPriceModel!.highConsumptionCost!)/100) €")
                text.addAttributes([NSForegroundColorAttributeName:UIColor(red: 77.0/255.0, green: 175.0/255.0, blue: 255.0/255.0, alpha: 1.0)], range: NSMakeRange(0, text.length))
                cell.cinnyOdberVysokaTarifaValue.attributedText = text
                
                text = NSMutableAttributedString(string: "Ostatné poplatky")
                text.addAttributes([NSUnderlineStyleAttributeName:NSUnderlineStyle.styleSingle.rawValue, NSForegroundColorAttributeName:UIColor(red: 177.0/255.0, green: 177.0/255.0, blue: 177.0/255.0, alpha: 1.0)], range: NSMakeRange(0, text.length))
                cell.ostatnePoplatky.attributedText = text
                cell.odvodDoJadrovehoFondu.text = "Odvod do jadrového fondu:"
                text = NSMutableAttributedString(string: "\(round(100 * monthOverviewModel.finalPriceModel!.nuclearFondCost!)/100) €")
                text.addAttributes([NSForegroundColorAttributeName:UIColor(red: 77.0/255.0, green: 175.0/255.0, blue: 255.0/255.0, alpha: 1.0)], range: NSMakeRange(0, text.length))
                cell.odvodDoJadrovehoFonduValue.attributedText = text
                cell.platbaZaSystemoveSluzby.text = "Platba za systémové služby:"
                text = NSMutableAttributedString(string: "\(round(100 * monthOverviewModel.finalPriceModel!.systemServicesCost!)/100) €")
                text.addAttributes([NSForegroundColorAttributeName:UIColor(red: 77.0/255.0, green: 175.0/255.0, blue: 255.0/255.0, alpha: 1.0)], range: NSMakeRange(0, text.length))
                cell.platbaZaSystemoveSluzbyValue.attributedText = text
                cell.platbaZaPrevadzkovanieSystemu.text = "Platba za prevádzkovanie systému:"
                text = NSMutableAttributedString(string: "\(round(100 * monthOverviewModel.finalPriceModel!.supplierPart!)/100) €")
                text.addAttributes([NSForegroundColorAttributeName:UIColor(red: 77.0/255.0, green: 175.0/255.0, blue: 255.0/255.0, alpha: 1.0)], range: NSMakeRange(0, text.length))
                cell.platbaZaPrevadzkovanieSystemuValue.attributedText = text
                cell.platbaZaStratyElektrinyPriDistribucii.text = "Platba za straty elektriny pri distribúcii"
                text = NSMutableAttributedString(string: "\(round(100 * monthOverviewModel.finalPriceModel!.distributionLossCost!)/100) €")
                text.addAttributes([NSForegroundColorAttributeName:UIColor(red: 77.0/255.0, green: 175.0/255.0, blue: 255.0/255.0, alpha: 1.0)], range: NSMakeRange(0, text.length))
                cell.platbaZaStratyElektrinyPriDistribuciiValue.attributedText = text
                
                text = NSMutableAttributedString(string: "Celkovo")
                text.addAttributes([NSUnderlineStyleAttributeName:NSUnderlineStyle.styleSingle.rawValue, NSForegroundColorAttributeName:UIColor(red: 177.0/255.0, green: 177.0/255.0, blue: 177.0/255.0, alpha: 1.0)], range: NSMakeRange(0, text.length))
                cell.celkovo.attributedText = text
                
                cell.distribucnaCast.text = "Distribučna čast':"
                text = NSMutableAttributedString(string: "\(round(100 * monthOverviewModel.finalPriceModel!.distributionPart!)/100) €")
                text.addAttributes([NSForegroundColorAttributeName:UIColor(red: 77.0/255.0, green: 175.0/255.0, blue: 255.0/255.0, alpha: 1.0)], range: NSMakeRange(0, text.length))
                cell.distribucnaCastValue.attributedText = text
                cell.dodavatelskaCast.text = "Dodávateĺská čast':"
                text = NSMutableAttributedString(string: "\(round(100 * monthOverviewModel.finalPriceModel!.supplierPart!)/100) €")
                text.addAttributes([NSForegroundColorAttributeName:UIColor(red: 77.0/255.0, green: 175.0/255.0, blue: 255.0/255.0, alpha: 1.0)], range: NSMakeRange(0, text.length))
                cell.dodavatelskaCastValue.attributedText = text
                
                cell.spoluKuDnesnemuDnu.text = "Spolu, ku dnešnému dňu:"
                text = NSMutableAttributedString(string: "\(round(100 * monthOverviewModel.finalPriceModel!.price!)/100) €")
                text.addAttributes([NSForegroundColorAttributeName:UIColor(red: 77.0/255.0, green: 175.0/255.0, blue: 255.0/255.0, alpha: 1.0)], range: NSMakeRange(0, text.length))
                cell.spoluKuDnesnemuValue.attributedText = text
                
                cell.separatorLine1.backgroundColor = UIColor(red: 225.0/255.0, green: 226.0/255.0, blue: 226.0/255.0, alpha: 1.0)
                cell.separatorLine2.backgroundColor = UIColor(red: 225.0/255.0, green: 226.0/255.0, blue: 226.0/255.0, alpha: 1.0)
                cell.separatorLine3.backgroundColor = UIColor(red: 225.0/255.0, green: 226.0/255.0, blue: 226.0/255.0, alpha: 1.0)
                
                cell.selectionStyle = .none
                return cell
            default:
                break
            }
        default:
            break
        }
        
        let cell = UITableViewCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section{
        case 0:
            return 148
        case 1:
            switch indexPath.row{
            case 0:
                return 148
            case 1:
                return 421
            default:
                return 0
            }
        default:
            return 0
        }
    }
}

extension DashboardViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            performSegue(withIdentifier: "graphInfoSegue", sender: tableView.cellForRow(at: indexPath))
            break
        case 1:
            switch indexPath.row {
            case 0:
                performSegue(withIdentifier: "dashboardInfoSegue", sender: tableView.cellForRow(at: indexPath))
                break
            default:
                break
            }
        default:
            break
        }
    }

}
