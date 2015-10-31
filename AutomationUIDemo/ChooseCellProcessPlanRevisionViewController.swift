//
//  ChooseCellProcessPlanRevisionViewController.swift
//  AutomationUIDemo
//
//  Created by Zhihao Cui on 30/10/2015.
//  Copyright © 2015 zhihaocui. All rights reserved.
//

import Foundation
import UIKit

protocol ChooseCellProcessPlanRevisionDelegate {
    func chooseCellProcessPlanRevision(cellProcessPlanRevision: CellProcessPlanRevision)
}

class ChooseCellProcessPlanRevisionViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var delegate : ChooseCellProcessPlanRevisionDelegate?
    
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var chooseButton: UIButton!
    @IBOutlet var _stackView: UIStackView!
    @IBOutlet var cellProcessPlanTableView: UITableView!
    @IBOutlet var revisionTableView: UITableView!
    
    var _cellProcessPlanList : [CellProcessPlan] = []
    var _revisionList : [CellProcessPlanRevision] = []
    
    let kCellIdentifier_CellProcessPlan = "CellProcessPlanCell"
    let kCellIdentifier_Revision = "RevisionCell"
    
    var _selectedCellProcessPlanIndex : Int?
    var _selectedRevisionIndex : Int?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.chooseButton.enabled = false
        
        setTableViewStyle(cellProcessPlanTableView)
        setTableViewStyle(revisionTableView)
        
        _cellProcessPlanList = CoreDataHelper().getAllCellProcessPlan()
        cellProcessPlanTableView.reloadData()
    }
    
    @IBAction func cancelButtonTapped(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func chooseButtonTapped(sender: UIButton) {
        delegate?.chooseCellProcessPlanRevision(_revisionList[_selectedRevisionIndex!])
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK:- Table View delegate and data source
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell = UITableViewCell()
        if tableView.tag == 1 {
            cell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier_CellProcessPlan)!
            cell.textLabel?.text = _cellProcessPlanList[indexPath.row].name
        } else if tableView.tag == 2 {
            cell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier_Revision)!
            cell.textLabel?.text = _revisionList[indexPath.row].name
        }
        cell.textLabel?.backgroundColor = UIColor.clearColor()
        cell.contentView.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.5)
        cell.layer.shouldRasterize = true
        cell.layer.cornerRadius =  10.0
        cell.layer.borderColor=UIColor.whiteColor().CGColor
        cell.layer.borderWidth=2.0
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.contentView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.1)
        
        if tableView.tag == 1 {
            _selectedCellProcessPlanIndex = indexPath.row
            _revisionList = CoreDataHelper().getCellProcessPlanRevision(byCellProcessPlan: _cellProcessPlanList[_selectedCellProcessPlanIndex!])
            revisionTableView.reloadData()
        } else if tableView.tag == 2 {
            _selectedRevisionIndex = indexPath.row
            chooseButton.enabled = true
        }
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.contentView.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.5)
        
        if tableView.tag == 2 {
            _selectedRevisionIndex = nil
            chooseButton.enabled = false
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1 {
            return _cellProcessPlanList.count
        } else if tableView.tag == 2 {
            return _revisionList.count
        }
        return 0
    }
    
    //MARK:- Utility
    func setTableViewStyle(tableView: UITableView) {
        tableView.layer.borderWidth = 1.0
        tableView.layer.borderColor = UIColor.blackColor().CGColor
        
        tableView.layer.shouldRasterize = true
        tableView.layer.cornerRadius =  5.0
    }
}