//
//  AutomationTableView.swift
//  AutomationUIDemo
//
//  Created by Zhihao Cui on 29/10/2015.
//  Copyright © 2015 zhihaocui. All rights reserved.
//

import Foundation
import UIKit

class AutomationTableView : UIView {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var tableView: UITableView!
    
    class func instanceFromNib() -> AutomationTableView {
        let view = UINib(nibName: "AutomationTableView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! AutomationTableView
        
        view.tableView.layer.borderWidth = 1.0
        view.tableView.layer.borderColor = UIColor.blackColor().CGColor
        
        view.tableView.layer.shouldRasterize = true
        view.tableView.layer.cornerRadius =  5.0
        
        return view
    }
}