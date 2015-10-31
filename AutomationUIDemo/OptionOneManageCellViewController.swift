//
//  OptionOneManageCellViewController.swift
//  AutomationUIDemo
//
//  Created by Zhihao Cui on 30/10/2015.
//  Copyright © 2015 zhihaocui. All rights reserved.
//

import Foundation
import UIKit

class OptionOneManageCellViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIPopoverPresentationControllerDelegate, ChooseCellProcessPlanRevisionDelegate  {
    
    @IBOutlet var _stackView: UIStackView!
    
    var _categoryView : AutomationTableView!
    var _cellView : AutomationTableView!
    var _cellEntityView : AutomationTableView!
    
    var _categoryList : [Category] = []
    var _cellList : [Cell] = []
    var _cellEntityList : [CellEntity] = []
    
    let kCellIdentifier = "textFieldCell"
    
    var _selectedCategoryIndex : Int?
    var _selectedCellIndex : Int?
    
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
        
        _cellView = AutomationTableView.instanceFromNib()
        _cellView.titleLabel.text = "Cell"
        _cellView.addButton.addTarget(self, action: "addCell:", forControlEvents: .TouchUpInside)
        _cellView.tableView.dataSource = self
        _cellView.tableView.delegate = self
        _cellView.tableView.registerNib(UINib(nibName: "CustomTableCell", bundle: nil), forCellReuseIdentifier: kCellIdentifier)
        _cellView.addButton.enabled = false
        _cellView.deleteButton.enabled = false
        _cellView.tag = 2
        
        _cellEntityView = AutomationTableView.instanceFromNib()
        _cellEntityView.titleLabel.text = "Cell Entity"
        _cellEntityView.addButton.addTarget(self, action: "addCellEntity:", forControlEvents: .TouchUpInside)
        _cellEntityView.tableView.dataSource = self
        _cellEntityView.tableView.delegate = self
        _cellEntityView.tableView.registerNib(UINib(nibName: "CustomTableCell", bundle: nil), forCellReuseIdentifier: kCellIdentifier)
        _cellEntityView.addButton.enabled = false
        _cellEntityView.deleteButton.enabled = false
        _cellEntityView.tag = 3
        
        _stackView.addArrangedSubview(_categoryView)
        _stackView.addArrangedSubview(_cellView)
        _stackView.addArrangedSubview(_cellEntityView)
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
        
        _cellList = []
        _cellEntityList = []
        _cellView.tableView.reloadData()
        _cellEntityView.tableView.reloadData()
    }

    @IBAction func addCell(sender: UIButton) {
        print("addCell called")
        let indexPath = NSIndexPath(forItem: _cellList.count, inSection: 0)
        _cellView.tableView.beginUpdates()
        if CoreDataHelper().addCell(withName: "", toCategory: _categoryList[_selectedCategoryIndex!]) {
            _cellView.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
        reloadTableDataSource(2)
        _cellView.tableView.reloadData()
        _cellView.tableView.endUpdates()
    }

    @IBAction func addCellEntity(sender: UIButton) {
        print("addCellEntity called")
        
        // Display choice of all available cell process plan revision
        let storeyboard = UIStoryboard(name: "ChooseCellProcessPlan", bundle: nil)
        let menuViewController = storeyboard.instantiateViewControllerWithIdentifier("ChooseCellProcessPlanRevisionViewController") as! ChooseCellProcessPlanRevisionViewController
        menuViewController.delegate = self
        menuViewController.modalPresentationStyle = .FormSheet
        menuViewController.preferredContentSize = CGSizeMake(_stackView.bounds.width - 100, _stackView.bounds.height - 20)
        
        let popoverMenuViewController = menuViewController.popoverPresentationController
        popoverMenuViewController?.permittedArrowDirections = .Any
        popoverMenuViewController?.delegate = self
        
        presentViewController(menuViewController, animated: true, completion: nil)
    }
    
    //MARK:- Popover Delegate
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .FormSheet
    }
    
    //MARK:- Table View Delegate & Data Source
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as! TextFieldTableCell
        if tableView.superview!.tag == 1 {
            cell.textField.placeholder = "Category name"
            cell.textField.text = _categoryList[indexPath.row].name!
        } else if tableView.superview!.tag == 2 {
            cell.textField.placeholder = "Cell name"
            cell.textField.text = _cellList[indexPath.row].name!
        } else if tableView.superview!.tag == 3 {
            cell.textField.placeholder = "Cell Entity name"
            cell.textField.text = _cellEntityList[indexPath.row].name!
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
            return _cellList.count
        } else if tableView.superview!.tag == 3 {
            return _cellEntityList.count
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.cellForRowAtIndexPath(indexPath)?.contentView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.1)
        
        if tableView.superview!.tag == 1 {
            _categoryView.deleteButton.enabled = true
            
            _selectedCategoryIndex = indexPath.row
            _cellView.addButton.enabled = true
            reloadTableDataSource(2)
            _cellView.tableView.reloadData()
            _cellEntityView.addButton.enabled = false
            _cellEntityList.removeAll()
            _cellEntityView.tableView.reloadData()
        } else if tableView.superview!.tag == 2 {
            _selectedCellIndex = indexPath.row
            _cellEntityView.addButton.enabled = true
            reloadTableDataSource(3)
            _cellEntityView.tableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.contentView.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.5)
    }

    //MARK:- Text Field Delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        let tableCell = textField.superview!.superview! as! TextFieldTableCell
        let tableView = tableCell.superview!.superview! as! UITableView
        let indexPath = tableView.indexPathForCell(tableCell)
        
        if tableView.superview!.tag == 1 {
            let nameChange = CoreDataHelper().changeCategory(_categoryList[(indexPath?.row)!], withName: textField.text!)
            print("Change Category name success: \(nameChange)")
        } else if tableView.superview!.tag == 2 {
            let nameChange = CoreDataHelper().changeCell(_cellList[(indexPath?.row)!], withName: textField.text!)
            print("Change Cell name success: \(nameChange)")
        } else if tableView.superview!.tag == 3 {
            let nameChange = CoreDataHelper().changeCellEntity(_cellEntityList[(indexPath?.row)!], withName: textField.text!)
            print("Change Cell Entity name success: \(nameChange)")
        }
        
        textField.resignFirstResponder()
        return true
    }
    
    //MARK:- Choose Cell Process Plan Revision Delegate
    func chooseCellProcessPlanRevision(cellProcessPlanRevision: CellProcessPlanRevision) {
        print("chooseCellProcessPlanRevision called")
        let indexPath = NSIndexPath(forItem: _cellEntityList.count, inSection: 0)
        _cellEntityView.tableView.beginUpdates()
        if CoreDataHelper().addCellEntity(withName: "", toCell: _cellList[_selectedCellIndex!], withRevision: cellProcessPlanRevision) {
            _cellEntityView.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
        reloadTableDataSource(3)
        _cellEntityView.tableView.reloadData()
        _cellEntityView.tableView.endUpdates()
    }
    
    //MARK:- Utility
    
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
            _cellList = CoreDataHelper().getCell(byCategory: _categoryList[_selectedCategoryIndex!]) ?? []
        } else if listNumber == 3 {
            _cellEntityList = CoreDataHelper().getCellEntity(byCell: _cellList[_selectedCellIndex!]) ?? []
        }
    }

}