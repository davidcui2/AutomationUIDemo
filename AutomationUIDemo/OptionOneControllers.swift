//
//  ViewController.swift
//  AutomationUIDemo
//
//  Created by Zhihao Cui on 29/10/2015.
//  Copyright © 2015 zhihaocui. All rights reserved.
//

import UIKit

class OptionOneManagerHomeViewController: UIViewController {

    @IBOutlet var _buttonStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setButtonBorder(inView: _buttonStackView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func homeButtonTapped(sender: UIButton) {
    }
    @IBAction func unwindToManagerHome(segue: UIStoryboardSegue) {
        
    }
    
    func setButtonBorder(inView view:UIView) {
        for var subview in view.subviews {
            if let button  = subview as? UIButton {
                button.backgroundColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 0.7)
                button.layer.borderWidth = 1.0
                button.layer.shouldRasterize = true
                button.layer.cornerRadius = 5.0
            }
            setButtonBorder(inView: subview)
        }
    }

}

class OptionOneProcessPlanViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet var _stackView: UIStackView!
    
    var _categoryView : AutomationTableView!
    var _processPlanView : AutomationTableView!
    var _processPlanRevisionView : AutomationTableView!
    
    var _categoryList : [Category] = []
    var _processPlanList : [ProcessPlan] = []
    var _processPlanRevisionList : [ProcessPlanRevision] = []
    
    let kCellIdentifier = "textFieldCell"
    
    var _selectedCategoryIndex : Int?
    var _selectedProcessPlanIndex : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadTableDataSource(1)
        
        _stackView.spacing = 10.0
        
        _categoryView = AutomationTableView.instanceFromNib()
        _categoryView.titleLabel.text = "Category"
        _categoryView.addButton.addTarget(self, action: "addCategory:", forControlEvents: .TouchUpInside)
        _categoryView.deleteButton.addTarget(self, action: "deleteCategory:", forControlEvents: .TouchUpInside)
        _categoryView.deleteButton.enabled = false
        _categoryView.tableView.dataSource = self
        _categoryView.tableView.delegate = self
        _categoryView.tableView.registerNib(UINib(nibName: "CustomTableCell", bundle: nil), forCellReuseIdentifier: kCellIdentifier)
        _categoryView.tag = 1
        
        _processPlanView = AutomationTableView.instanceFromNib()
        _processPlanView.titleLabel.text = "Process Plan"
        _processPlanView.addButton.addTarget(self, action: "addProcessPlan:", forControlEvents: .TouchUpInside)
        _processPlanView.tableView.dataSource = self
        _processPlanView.tableView.delegate = self
        _processPlanView.tableView.registerNib(UINib(nibName: "CustomTableCell", bundle: nil), forCellReuseIdentifier: kCellIdentifier)
        _processPlanView.addButton.enabled = false
        _processPlanView.deleteButton.enabled = false
        _processPlanView.tag = 2
        
        _processPlanRevisionView = AutomationTableView.instanceFromNib()
        _processPlanRevisionView.titleLabel.text = "Process Plan Revision"
        _processPlanRevisionView.addButton.addTarget(self, action: "addProcessPlanRevision:", forControlEvents: .TouchUpInside)
        _processPlanRevisionView.tableView.dataSource = self
        _processPlanRevisionView.tableView.delegate = self
        _processPlanRevisionView.tableView.registerNib(UINib(nibName: "CustomTableCell", bundle: nil), forCellReuseIdentifier: kCellIdentifier)
        _processPlanRevisionView.addButton.enabled = false
        _processPlanRevisionView.deleteButton.enabled = false
        _processPlanRevisionView.tag = 3
        
        _stackView.addArrangedSubview(_categoryView)
        _stackView.addArrangedSubview(_processPlanView)
        _stackView.addArrangedSubview(_processPlanRevisionView)
    }
    
    //MARK:- Button events
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
    
    @IBAction func deleteCategory(sender: UIButton) {
        print("deleteCategory called")
        let indexPath = NSIndexPath(forItem: _selectedCategoryIndex!, inSection: 0)
        _categoryView.tableView.beginUpdates()
        if CoreDataHelper().deleteCategory(_categoryList[_selectedCategoryIndex!]) {
            _categoryView.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            _selectedCategoryIndex = nil
        }
        reloadTableDataSource(1)
        _categoryView.tableView.reloadData()
        _categoryView.tableView.endUpdates()
        
        _processPlanList = []
        _processPlanRevisionList = []
        _processPlanView.tableView.reloadData()
        _processPlanRevisionView.tableView.reloadData()
    }
    
    @IBAction func addProcessPlan(sender: UIButton) {
        print("addProcessPlan called")
        let indexPath = NSIndexPath(forItem: _processPlanList.count, inSection: 0)
        _processPlanView.tableView.beginUpdates()
        if CoreDataHelper().addProcessPlan(withName: "", toCategory: _categoryList[_selectedCategoryIndex!]) {
            _processPlanView.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
        reloadTableDataSource(2)
        _processPlanView.tableView.reloadData()
        _processPlanView.tableView.endUpdates()
    }
    
    @IBAction func addProcessPlanRevision(sender: UIButton) {
        print("addProcessPlanRevision called")
        let indexPath = NSIndexPath(forItem: _processPlanRevisionList.count, inSection: 0)
        _processPlanRevisionView.tableView.beginUpdates()
        if CoreDataHelper().addProcessPlanRevision(withName: "", toProcessPlan: _processPlanList[_selectedProcessPlanIndex!]) {
            _processPlanRevisionView.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
        reloadTableDataSource(3)
        _processPlanRevisionView.tableView.reloadData()
        _processPlanRevisionView.tableView.endUpdates()
    }
    
    //MARK:- Table View Delegate & Data Source
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as! TextFieldTableCell
        if tableView.superview!.tag == 1 {
            cell.textField.placeholder = "Category name"
            cell.textField.text = _categoryList[indexPath.row].name!
        } else if tableView.superview!.tag == 2 {
            cell.textField.placeholder = "Process Plan name"
            cell.textField.text = _processPlanList[indexPath.row].name!
        } else if tableView.superview!.tag == 3 {
            cell.textField.placeholder = "Process Plan Revision name"
            cell.textField.text = _processPlanRevisionList[indexPath.row].name!
        }
        cell.layer.shouldRasterize = true
        cell.layer.cornerRadius =  10.0
        cell.layer.borderColor=UIColor.whiteColor().CGColor
        cell.layer.borderWidth=2.0
        
        cell.textField.returnKeyType = .Done
        cell.textField.delegate = self
        
        cell.contentView.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.5)

        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.superview!.tag == 1 {
            return _categoryList.count
        } else if tableView.superview!.tag == 2 {
            return _processPlanList.count
        } else if tableView.superview!.tag == 3 {
            return _processPlanRevisionList.count
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.cellForRowAtIndexPath(indexPath)?.contentView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.1)
        
        if tableView.superview!.tag == 1 {
            _categoryView.deleteButton.enabled = true
            
            _selectedCategoryIndex = indexPath.row
            _processPlanView.addButton.enabled = true
            reloadTableDataSource(2)
            _processPlanView.tableView.reloadData()
            _processPlanRevisionView.addButton.enabled = false
            _processPlanRevisionList.removeAll()
            _processPlanRevisionView.tableView.reloadData()
        } else if tableView.superview!.tag == 2 {
            _selectedProcessPlanIndex = indexPath.row
            _processPlanRevisionView.addButton.enabled = true
            reloadTableDataSource(3)
            _processPlanRevisionView.tableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.contentView.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.5)
        
        
    }
    
    //MARK:- Text Field Delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        changeName(inTextField: textField)
        return true
    }
    
    //MARK:- Utility
    
    func changeName(inTextField textField: UITextField) {
        let tableCell = textField.superview!.superview! as! TextFieldTableCell
        let tableView = tableCell.superview!.superview! as! UITableView
        let indexPath = tableView.indexPathForCell(tableCell)
        
        if tableView.superview!.tag == 1 {
            let nameChange = CoreDataHelper().changeCategory(_categoryList[(indexPath?.row)!], withName: textField.text!)
            print("Change Category name success: \(nameChange)")
        } else if tableView.superview!.tag == 2 {
            let nameChange = CoreDataHelper().changeProcessPlan(_processPlanList[(indexPath?.row)!], withName: textField.text!)
            print("Change Process Plan name success: \(nameChange)")
        } else if tableView.superview!.tag == 3 {
            let nameChange = CoreDataHelper().changeProcessPlanRevision(_processPlanRevisionList[(indexPath?.row)!], withName: textField.text!)
            print("Change Process Plan Revision name success: \(nameChange)")
        }
        
        textField.resignFirstResponder()
    }
    
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
            _processPlanList = _selectedCategoryIndex != nil ? CoreDataHelper().getProcessPlan(byCategory: _categoryList[_selectedCategoryIndex!]) : []
        } else if listNumber == 3 {
            _processPlanRevisionList = _selectedProcessPlanIndex != nil ? CoreDataHelper().getProcessPlanRevision(byProcessPlan: _processPlanList[_selectedProcessPlanIndex!]) : []
        }
    }
}
