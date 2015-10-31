//
//  RootTableViewController.swift
//  AutomationUIDemo
//
//  Created by Zhihao Cui on 30/10/2015.
//  Copyright © 2015 zhihaocui. All rights reserved.
//

import Foundation
import UIKit

class RootViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func unwindToRoot(segue: UIStoryboardSegue) {
        print("unwindToRoot called")
    }
}