//
//  OptionTwoCellViewController.swift
//  AutomationUIDemo
//
//  Created by Zhihao Cui on 30/10/2015.
//  Copyright © 2015 zhihaocui. All rights reserved.
//

import Foundation
import UIKit

class OptionTwoCellViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var _stackView: UIStackView!
    
    var _categoryView : AutomationTableView!
    var _cellProcessPlanView : AutomationTableView!
    var _cellProcessPlanRevisionView : AutomationTableView!
    var _cellView : AutomationTableView!
    var _cellEntityView : AutomationTableView!
    
    var _categoryList : [Category] = []
    var _cellProcessPlanList : [CellProcessPlan] = []
    var _cellProcessPlanRevisionList : [CellProcessPlanRevision] = []
    var _cellList : [Cell] = []
    var _cellEntityList : [CellEntity] = []
    
    let kCellIdentifier = "textFieldCell"
    
    var _selectedCategoryIndex : Int?
    var _selectedCellProcessPlanIndex : Int?
    var _selectedCellIndex : Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        _stackView.spacing = 10.0
        
        _categoryView = AutomationTableView.instanceFromNib()
        _categoryView.titleLabel.text = "Category"
        _categoryView.addButton.addTarget(self, action: "addCategory:", forControlEvents: .TouchUpInside)
        _categoryView.deleteButton.addTarget(self, action: "deleteCategory:", forControlEvents: .TouchUpInside)
        _categoryView.tableView.dataSource = self
        _categoryView.tableView.delegate = self
        _categoryView.deleteButton.enabled = false
        _categoryView.tableView.registerNib(UINib(nibName: "CustomTableCell", bundle: nil), forCellReuseIdentifier: kCellIdentifier)
        _categoryView.tag = 1
        
        _cellProcessPlanView = AutomationTableView.instanceFromNib()
        _cellProcessPlanView.titleLabel.text = "Cell Process Plan"
        _cellProcessPlanView.addButton.addTarget(self, action: "addCellProcessPlan:", forControlEvents: .TouchUpInside)
        _cellProcessPlanView.tableView.dataSource = self
        _cellProcessPlanView.tableView.delegate = self
        _cellProcessPlanView.tableView.registerNib(UINib(nibName: "CustomTableCell", bundle: nil), forCellReuseIdentifier: kCellIdentifier)
        _cellProcessPlanView.addButton.enabled = false
        _cellProcessPlanView.deleteButton.enabled = false
        _cellProcessPlanView.tag = 2
        
        _cellProcessPlanRevisionView = AutomationTableView.instanceFromNib()
        _cellProcessPlanRevisionView.titleLabel.text = "Cell Process Plan Revision"
        _cellProcessPlanRevisionView.addButton.addTarget(self, action: "addCellProcessPlanRevision:", forControlEvents: .TouchUpInside)
        _cellProcessPlanRevisionView.tableView.dataSource = self
        _cellProcessPlanRevisionView.tableView.delegate = self
        _cellProcessPlanRevisionView.tableView.registerNib(UINib(nibName: "CustomTableCell", bundle: nil), forCellReuseIdentifier: kCellIdentifier)
        _cellProcessPlanRevisionView.addButton.enabled = false
        _cellProcessPlanRevisionView.deleteButton.enabled = false
        _cellProcessPlanRevisionView.tag = 3
        
        
        
        
        _cellView = AutomationTableView.instanceFromNib()
        _cellView.titleLabel.text = "Cell"
        _cellView.addButton.addTarget(self, action: "addCell:", forControlEvents: .TouchUpInside)
        _cellView.tableView.dataSource = self
        _cellView.tableView.delegate = self
        _cellView.tableView.registerNib(UINib(nibName: "CustomTableCell", bundle: nil), forCellReuseIdentifier: kCellIdentifier)
        _cellView.addButton.enabled = false
        _cellView.deleteButton.enabled = false
        _cellView.tag = 4
        
        _cellEntityView = AutomationTableView.instanceFromNib()
        _cellEntityView.titleLabel.text = "Cell Entity"
        _cellEntityView.addButton.addTarget(self, action: "addCellEntity:", forControlEvents: .TouchUpInside)
        _cellEntityView.tableView.dataSource = self
        _cellEntityView.tableView.delegate = self
        _cellEntityView.tableView.registerNib(UINib(nibName: "CustomTableCell", bundle: nil), forCellReuseIdentifier: kCellIdentifier)
        _cellEntityView.addButton.enabled = false
        _cellEntityView.deleteButton.enabled = false
        _cellEntityView.tag = 5
        
        
        let secondColumnStackView = UIStackView(arrangedSubviews: [_cellProcessPlanView, _cellView])
        secondColumnStackView.distribution = .FillEqually
        secondColumnStackView.spacing = 10.0
        secondColumnStackView.alignment = .Fill
        secondColumnStackView.axis = .Vertical

        let thirdColumnStackView = UIStackView(arrangedSubviews: [_cellProcessPlanRevisionView, _cellEntityView])
        thirdColumnStackView.distribution = .FillEqually
        thirdColumnStackView.spacing = 10.0
        thirdColumnStackView.alignment = .Fill
        thirdColumnStackView.axis = .Vertical
        
        _stackView.addArrangedSubview(_categoryView)
        _stackView.addArrangedSubview(secondColumnStackView)
        _stackView.addArrangedSubview(thirdColumnStackView)


    }
    
    //MARK:- Table View
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
}