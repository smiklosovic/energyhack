//
//  File.swift
//  Energyhack
//
//  Created by Alexey Potapov on 28/01/2017.
//  Copyright © 2017 Community. All rights reserved.
//

import UIKit

class AdviceViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "AdviceHeaderViewCell", bundle: nil), forCellReuseIdentifier: "AdviceHeaderViewCell")
        tableView.register(UINib(nibName: "AdviceViewCell", bundle: nil), forCellReuseIdentifier: "AdviceViewCell")
    }
    
    @IBAction func dismiss() {
        dismiss(animated: true, completion: nil)
    }
}

extension AdviceViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row % 2 == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AdviceHeaderViewCell", for: indexPath) as! AdviceHeaderViewCell
            cell.selectionStyle = .none

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AdviceViewCell", for: indexPath) as! AdviceViewCell
            cell.selectionStyle = .none
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row % 2 == 0 {
            return 71
        } else {
            return 164
        }
    }
}

extension AdviceViewController: UITableViewDelegate {
    
}
