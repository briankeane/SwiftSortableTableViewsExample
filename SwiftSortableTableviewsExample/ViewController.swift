//
//  ViewController.swift
//  SwiftSortableTableviewsExample
//
//  Created by Brian D Keane on 9/4/17.
//  Copyright © 2017 Brian D Keane. All rights reserved.
//

import UIKit
import SwiftSortableTableviews

let kCustomCellIdentifier = "kCustomCellIdentifier"

class ViewController: UIViewController,SortableTableViewDelegate, SortableTableViewDataSource  {

    @IBOutlet weak var numbersTableView: SortableTableView!

    var numbersArray:Array<Int> = [0,1,2,3,4,5,6,7,8,9]
    var lettersArray:Array<String> = ["a","b","c","d","e","f","g","h","i","j"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.numbersTableView.sortableDelegate = self
        self.numbersTableView.sortableDataSource = self
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    
    //------------------------------------------------------------------------------
    
    //                    Delegate/DataSource
    //------------------------------------------------------------------------------
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
            let cell = self.numbersTableView.dequeueReusableCell(withIdentifier: kCustomCellIdentifier, for: indexPath) as! CustomCell
            cell.label.text = String(numbersArray[indexPath.row])
            return cell
    }
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.numbersArray.count
    }
    
        
    
    
    
    
}

