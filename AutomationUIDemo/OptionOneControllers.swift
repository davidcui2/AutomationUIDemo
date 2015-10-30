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

    @IBAction func unwindToManagerHome(segue: UIStoryboardSegue) {
        
    }
    
    func setButtonBorder(inView view:UIView) {
        for var subview in view.subviews {
            if let button  = subview as? UIButton {
                button.layer.borderWidth = 1.0
            }
            setButtonBorder(inView: subview)
        }
    }

}

class OptionOneProcessPlanViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet var _stackView: UIStackView!
    
    var _categoryView : AutomationTableView!
    var _processPlanView : AutomationTableView!
    var _processPlanRevisionView : AutomationTableView!
    
    var _doubleTapGestureRecognizer : UITapGestureRecognizer!
    
    var _categoryList : [Category] = []
    var _processPlanList : [ProcessPlan] = []
    var _processPlanRevisionList : [ProcessPlanRevision] = []
    
    let kCellIdentifier = "textFieldCell"
    
    var _selectedCategoryIndex : Int!
    var _selectedProcessPlanIndex : Int!
    
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
        
        _processPlanView = AutomationTableView.instanceFromNib()
        _processPlanView.titleLabel.text = "Process Plan"
        _processPlanView.addButton.addTarget(self, action: "addProcessPlan:", forControlEvents: .TouchUpInside)
        _processPlanView.tableView.dataSource = self
        _processPlanView.tableView.delegate = self
        _processPlanView.tableView.registerNib(UINib(nibName: "CustomTableCell", bundle: nil), forCellReuseIdentifier: kCellIdentifier)
        _processPlanView.addButton.enabled = false
        _processPlanView.tag = 2
        
        _processPlanRevisionView = AutomationTableView.instanceFromNib()
        _processPlanRevisionView.titleLabel.text = "Process Plan Revision"
        _processPlanRevisionView.addButton.addTarget(self, action: "addProcessPlanRevision:", forControlEvents: .TouchUpInside)
        _processPlanRevisionView.tableView.dataSource = self
        _processPlanRevisionView.tableView.delegate = self
        _processPlanRevisionView.tableView.registerNib(UINib(nibName: "CustomTableCell", bundle: nil), forCellReuseIdentifier: kCellIdentifier)
        _processPlanRevisionView.addButton.enabled = false
        _processPlanRevisionView.tag = 3
        
        _stackView.addArrangedSubview(_categoryView)
        _stackView.addArrangedSubview(_processPlanView)
        _stackView.addArrangedSubview(_processPlanRevisionView)
        
        _doubleTapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: "textFieldTapped:")
        _doubleTapGestureRecognizer.numberOfTapsRequired = 2
        _doubleTapGestureRecognizer.numberOfTouchesRequired = 1
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
    
    @IBAction func addProcessPlan(sender: UIButton) {
        print("addProcessPlan called")
        let indexPath = NSIndexPath(forItem: _processPlanList.count, inSection: 0)
        _processPlanView.tableView.beginUpdates()
        if CoreDataHelper().addProcessPlan(withName: "", toCategory: _categoryList[_selectedCategoryIndex]) {
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
        if CoreDataHelper().addProcessPlanRevision(withName: "", toProcessPlan: _processPlanList[_selectedProcessPlanIndex]) {
            _processPlanRevisionView.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
        reloadTableDataSource(3)
        _processPlanRevisionView.tableView.reloadData()
        _processPlanRevisionView.tableView.endUpdates()
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
                
                categoryCell.textField.addGestureRecognizer(_doubleTapGestureRecognizer)
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
                processPlanCell.textField.text = _processPlanList[indexPath.row].name!
                processPlanCell.textField.returnKeyType = .Done
                processPlanCell.textField.delegate = self
                
                processPlanCell.textField.addGestureRecognizer(_doubleTapGestureRecognizer)
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
                processPlanRevisionCell.textField.text = _processPlanRevisionList[indexPath.row].name!
                processPlanRevisionCell.textField.returnKeyType = .Done
                processPlanRevisionCell.textField.delegate = self
                
                processPlanRevisionCell.textField.addGestureRecognizer(_doubleTapGestureRecognizer)
            }
            return cell!
        }
        return tableView.dequeueReusableCellWithIdentifier("cell")!
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
        if tableView.superview!.tag == 1 {
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
            let nameChange = CoreDataHelper().changeProcessPlan(_processPlanList[(indexPath?.row)!], withName: textField.text!)
            print("Change Process Plan name success: \(nameChange)")
        } else if tableView.superview!.tag == 3 {
            let nameChange = CoreDataHelper().changeProcessPlanRevision(_processPlanRevisionList[(indexPath?.row)!], withName: textField.text!)
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
            _processPlanList = CoreDataHelper().getProcessPlan(byCategory: _categoryList[_selectedCategoryIndex])
        } else if listNumber == 3 {
            _processPlanRevisionList = CoreDataHelper().getProcessPlanRevision(byProcessPlan: _processPlanList[_selectedProcessPlanIndex])
        }
    }
}
