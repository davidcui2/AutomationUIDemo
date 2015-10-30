//
//  OptionOneCellViewControllers.swift
//  AutomationUIDemo
//
//  Created by Zhihao Cui on 30/10/2015.
//  Copyright © 2015 zhihaocui. All rights reserved.
//

import Foundation
import UIKit

class OptionOneDesignCellViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet var _stackView: UIStackView!
    
    var _categoryView : AutomationTableView!
    var _cellProcessPlanView : AutomationTableView!
    var _cellProcessPlanRevisionView : AutomationTableView!
    
    var _categoryList : [Category] = []
    var _cellProcessPlanList : [CellProcessPlan] = []
    var _cellProcessPlanRevisionList : [CellProcessPlanRevision] = []
    
    let kCellIdentifier = "textFieldCell"
    
    var _selectedCategoryIndex : Int!
    var _selectedCellProcessPlanIndex : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadTableDataSource(1)
        
        _stackView.spacing = 10.0
        
        _categoryView = AutomationTableView.instanceFromNib()
        _categoryView.titleLabel.text = "Category"
        _categoryView.addButton.addTarget(self, action: "addCategory:", forControlEvents: .TouchUpInside)
        _categoryView.tableView.dataSource = self
        _categoryView.tableView.delegate = self
        _categoryView.tableView.registerNib(UINib(nibName: "CustomTableCell", bundle: nil), forCellReuseIdentifier: kCellIdentifier)
        _categoryView.tag = 1
        
        _cellProcessPlanView = AutomationTableView.instanceFromNib()
        _cellProcessPlanView.titleLabel.text = "Cell Process Plan"
        _cellProcessPlanView.addButton.addTarget(self, action: "addCellProcessPlan:", forControlEvents: .TouchUpInside)
        _cellProcessPlanView.tableView.dataSource = self
        _cellProcessPlanView.tableView.delegate = self
        _cellProcessPlanView.tableView.registerNib(UINib(nibName: "CustomTableCell", bundle: nil), forCellReuseIdentifier: kCellIdentifier)
        _cellProcessPlanView.addButton.enabled = false
        _cellProcessPlanView.tag = 2
        
        _cellProcessPlanRevisionView = AutomationTableView.instanceFromNib()
        _cellProcessPlanRevisionView.titleLabel.text = "Cell Process Plan Revision"
        _cellProcessPlanRevisionView.addButton.addTarget(self, action: "addCellProcessPlanRevision:", forControlEvents: .TouchUpInside)
        _cellProcessPlanRevisionView.tableView.dataSource = self
        _cellProcessPlanRevisionView.tableView.delegate = self
        _cellProcessPlanRevisionView.tableView.registerNib(UINib(nibName: "CustomTableCell", bundle: nil), forCellReuseIdentifier: kCellIdentifier)
        _cellProcessPlanRevisionView.addButton.enabled = false
        _cellProcessPlanRevisionView.tag = 3
        
        _stackView.addArrangedSubview(_categoryView)
        _stackView.addArrangedSubview(_cellProcessPlanView)
        _stackView.addArrangedSubview(_cellProcessPlanRevisionView)
    }
    
    //MARK: - Button events
    @IBAction func addCategory(sender: UIButton) {
        print("addCategory called")
        let indexPath = NSIndexPath(forItem: _categoryList.count, inSection: 0)
        _categoryView.tableView.beginUpdates()
        if CoreDataHelper().addCategory(withName: "") {
            _categoryView.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
        reloadTableDataSource(1)
        _categoryView.tableView.reloadData()
        _categoryView.tableView.endUpdates()
    }
    
    @IBAction func addCellProcessPlan(sender: UIButton) {
        print("addCellProcessPlan called")
        let indexPath = NSIndexPath(forItem: _cellProcessPlanList.count, inSection: 0)
        _cellProcessPlanView.tableView.beginUpdates()
        if CoreDataHelper().addCellProcessPlan(withName: "", toCategory: _categoryList[_selectedCategoryIndex]) {
            _cellProcessPlanView.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
        reloadTableDataSource(2)
        _cellProcessPlanView.tableView.reloadData()
        _cellProcessPlanView.tableView.endUpdates()
    }
    
    @IBAction func addCellProcessPlanRevision(sender: UIButton) {
        print("addCellProcessPlanRevision called")
        let indexPath = NSIndexPath(forItem: _cellProcessPlanRevisionList.count, inSection: 0)
        _cellProcessPlanRevisionView.tableView.beginUpdates()
        if CoreDataHelper().addCellProcessPlanRevision(withName: "", toCellProcessPlan: _cellProcessPlanList[_selectedCellProcessPlanIndex]) {
            _cellProcessPlanRevisionView.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
        reloadTableDataSource(3)
        _cellProcessPlanRevisionView.tableView.reloadData()
        _cellProcessPlanRevisionView.tableView.endUpdates()
    }
    
    //MARK: - Table View Delegate & Data Source
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier)
        if tableView.superview!.tag == 1 {
            if cell == nil {
                return UITableViewCell.init(style: .Default, reuseIdentifier: kCellIdentifier)
            } else {
                let categoryCell = cell as! TextFieldTableCell
                categoryCell.layer.shouldRasterize = true
                categoryCell.layer.cornerRadius =  10.0
                categoryCell.layer.borderColor=UIColor.whiteColor().CGColor
                categoryCell.layer.borderWidth=2.0
                
                categoryCell.textField.placeholder = "Category name"
                categoryCell.textField.text = _categoryList[indexPath.row].name!
                categoryCell.textField.returnKeyType = .Done
                categoryCell.textField.delegate = self
            }
            return cell!
        } else if tableView.superview!.tag == 2 {
            if cell == nil {
                return UITableViewCell.init(style: .Default, reuseIdentifier: kCellIdentifier)
            } else {
                let processPlanCell = cell as! TextFieldTableCell
                processPlanCell.layer.shouldRasterize = true
                processPlanCell.layer.cornerRadius =  10.0
                processPlanCell.layer.borderColor=UIColor.whiteColor().CGColor
                processPlanCell.layer.borderWidth=2.0
                
                processPlanCell.textField.placeholder = "Process Plan name"
                processPlanCell.textField.text = _cellProcessPlanList[indexPath.row].name!
                processPlanCell.textField.returnKeyType = .Done
                processPlanCell.textField.delegate = self
            }
            return cell!
        } else if tableView.superview!.tag == 3 {
            if cell == nil {
                return UITableViewCell.init(style: .Default, reuseIdentifier: kCellIdentifier)
            } else {
                let processPlanRevisionCell = cell as! TextFieldTableCell
                processPlanRevisionCell.layer.shouldRasterize = true
                processPlanRevisionCell.layer.cornerRadius =  10.0
                processPlanRevisionCell.layer.borderColor=UIColor.whiteColor().CGColor
                processPlanRevisionCell.layer.borderWidth=2.0
                
                processPlanRevisionCell.textField.placeholder = "Process Plan Revision name"
                processPlanRevisionCell.textField.text = _cellProcessPlanRevisionList[indexPath.row].name!
                processPlanRevisionCell.textField.returnKeyType = .Done
                processPlanRevisionCell.textField.delegate = self
            }
            return cell!
        }
        return tableView.dequeueReusableCellWithIdentifier("cell")!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.superview!.tag == 1 {
            return _categoryList.count
        } else if tableView.superview!.tag == 2 {
            return _cellProcessPlanList.count
        } else if tableView.superview!.tag == 3 {
            return _cellProcessPlanRevisionList.count
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView.superview!.tag == 1 {
            _selectedCategoryIndex = indexPath.row
            _cellProcessPlanView.addButton.enabled = true
            reloadTableDataSource(2)
            _cellProcessPlanView.tableView.reloadData()
            _cellProcessPlanRevisionView.addButton.enabled = false
            _cellProcessPlanRevisionList.removeAll()
            _cellProcessPlanRevisionView.tableView.reloadData()
        } else if tableView.superview!.tag == 2 {
            _selectedCellProcessPlanIndex = indexPath.row
            _cellProcessPlanRevisionView.addButton.enabled = true
            reloadTableDataSource(3)
            _cellProcessPlanRevisionView.tableView.reloadData()
        }
    }
    
    //MARK: - Gesture Delegate
    
    func textFieldTapped(sender: UITapGestureRecognizer) {
        let textField = sender.view! as! UITextField
        textField.enabled = true
    }
    
    //MARK: - Text Field Delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let tableCell = textField.superview!.superview! as! TextFieldTableCell
        let tableView = tableCell.superview!.superview! as! UITableView
        let indexPath = tableView.indexPathForCell(tableCell)
        
        if tableView.superview!.tag == 1 {
            let nameChange = CoreDataHelper().changeCategory(_categoryList[(indexPath?.row)!], withName: textField.text!)
            print("Change Category name success: \(nameChange)")
        } else if tableView.superview!.tag == 2 {
            let nameChange = CoreDataHelper().changeCellProcessPlan(_cellProcessPlanList[(indexPath?.row)!], withName: textField.text!)
            print("Change Process Plan name success: \(nameChange)")
        } else if tableView.superview!.tag == 3 {
            let nameChange = CoreDataHelper().changeCellProcessPlanRevision(_cellProcessPlanRevisionList[(indexPath?.row)!], withName: textField.text!)
            print("Change Process Plan Revision name success: \(nameChange)")
        }
        
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: - Utility
    
    func showAlertWithMessage(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default) { _ in
            // Put here any code that you would like to execute when
            // the user taps that OK button (may be empty in your case if that's just
            // an informative alert)
        }
        alert.addAction(action)
        self.presentViewController(alert, animated: true){}
    }
    
    func reloadTableDataSource(listNumber: Int) {
        if listNumber == 1 {
            _categoryList = CoreDataHelper().getCategory()
        } else if listNumber == 2 {
            _cellProcessPlanList = CoreDataHelper().getCellProcessPlan(byCategory: _categoryList[_selectedCategoryIndex])
        } else if listNumber == 3 {
            _cellProcessPlanRevisionList = CoreDataHelper().getCellProcessPlanRevision(byCellProcessPlan: _cellProcessPlanList[_selectedCellProcessPlanIndex])
        }
    }

}