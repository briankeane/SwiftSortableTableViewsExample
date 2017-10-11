//
//  ViewController.swift
//  SwiftSortableTableviewsExample
//
//  Created by Brian D Keane on 9/4/17.
//  Copyright © 2017 Brian D Keane. All rights reserved.
//

import UIKit
import SwiftSortableTableViews

let kCustomCellIdentifier = "kCustomCellIdentifier"


// In the Example:
//  -- vowels cannot be dropped into the numbers table
//  -- odd numbers cannot be picked up from the numbers table
//  -- even numbers cannot be deleted

class ViewController: UIViewController,SortableTableViewDelegate, SortableTableViewDataSource  {

    @IBOutlet weak var numbersTableView: SortableTableView!
    @IBOutlet weak var lettersTableView: SortableTableView!
    @IBOutlet weak var eventLogTextView: UITextView!

    var numbersArray:Array<String> = ["0","1","2","3","4","5","6","7","8","9"]
    var lettersArray:Array<String> = ["a","b","c","d","e","f","g","h","i","j"]
    
    var sortableHandler:SortableTableViewHandler!
    
    //------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSortableTableViews()
        self.eventLogTextView.text = ""
    }
    
    //------------------------------------------------------------------------------
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //------------------------------------------------------------------------------
    
    func setupSortableTableViews()
    {
        self.numbersTableView.sortableDelegate = self
        self.numbersTableView.sortableDataSource = self
        
        self.lettersTableView.sortableDelegate = self
        self.lettersTableView.sortableDataSource = self
        
        self.sortableHandler = SortableTableViewHandler(view: self.view,
                                                        sortableTableViews: [
                                                            self.numbersTableView,
                                                            self.lettersTableView
                                                        ])
        
    }
    
    //------------------------------------------------------------------------------
    
    func logEvent(_ text:String)
    {
        DispatchQueue.main.async {
            self.eventLogTextView.text = self.eventLogTextView.text + "\n\(text)"
            let bottom = self.eventLogTextView.contentSize.height - self.eventLogTextView.bounds.size.height
            self.eventLogTextView.setContentOffset(CGPoint(x: 0, y: bottom), animated: true)
        }
    }
    
    //------------------------------------------------------------------------------
    
    //                    Delegate/DataSource
    //------------------------------------------------------------------------------
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = self.numbersTableView.dequeueReusableCell(withIdentifier: kCustomCellIdentifier) as! CustomCell
        
        if (tableView == self.numbersTableView)
        {
            cell.label.text = String(numbersArray[indexPath.row])
        }
        else
        {
            cell.label.text = String(lettersArray[indexPath.row])
        }
        cell.isHidden = false
        return cell
    }
    
    //------------------------------------------------------------------------------
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //------------------------------------------------------------------------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (tableView == self.numbersTableView)
        {
           return self.numbersArray.count
        }
        else
        {
            return self.lettersArray.count
        }
    }
    
    //------------------------------------------------------------------------------
    
    func sortableTableView(_ releasingTableView: SortableTableView, shouldReleaseItem originalRow: Int, desiredRow:Int, receivingTableView:SortableTableView) -> Bool
    {
        self.logEvent("shouldReleaseItem fired")
        // vowels are not welcome in the numbers table
        if (receivingTableView == self.numbersTableView)
        {
            return (["a","e","i","o","u"].index(of: self.lettersArray[originalRow]) == nil)
        }
        return true
    }
    
    //------------------------------------------------------------------------------
    
    func sortableTableView(_ tableView: SortableTableView, canBePickedUp row: Int) -> Bool {
        self.logEvent("canBePickedUp fired")
        if (tableView == self.numbersTableView)
        {
            if let numberVersion = Int(self.numbersArray[row])
            {
                return (numberVersion % 2 == 0)
            }
        }
        return true
    }
    
    //------------------------------------------------------------------------------

    func sortableTableView(_ releasingTableView: SortableTableView, willReceiveItem originalRow: Int, newRow: Int, receivingTableView: SortableTableView) {
        self.logEvent("willReceiveItem fired")
        // if moving from numbersTableView to lettersTableView
        if ((releasingTableView == self.lettersTableView) && (receivingTableView == self.numbersTableView))
        {
            self.numbersArray.insert(self.lettersArray.remove(at: originalRow), at: newRow)
        }
        // ELSE IF moving from numb
        else if ((releasingTableView == self.numbersTableView) && (receivingTableView == self.lettersTableView))
        {
            self.lettersArray.insert(self.numbersArray.remove(at: originalRow), at: newRow)
        }
    }
    
    //------------------------------------------------------------------------------
    
    func sortableTableView(_ tableView: SortableTableView, willDropItem originalRow: Int, newRow: Int) {
        self.logEvent("willDropItem fired")
        if (tableView == self.lettersTableView)
        {
            self.lettersArray.insert(self.lettersArray.remove(at: originalRow), at: newRow)
            print("new letters array: ")
            print(self.lettersArray)
        }
        else if (tableView == self.numbersTableView)
        {
            self.numbersArray.insert(self.numbersArray.remove(at: originalRow), at: newRow)
        }
    }
    
    //------------------------------------------------------------------------------
    func sortableTableView(_ releasingTableView: SortableTableView, willReleaseItem originalRow: Int, newRow: Int, receivingTableView: SortableTableView) {
        self.logEvent("willReleaseItem fired")
    }
    
    //------------------------------------------------------------------------------
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    //------------------------------------------------------------------------------
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if (editingStyle == .delete)
        {
            if (tableView == self.lettersTableView)
            {
                self.lettersArray.remove(at: indexPath.row)
                self.lettersTableView.deleteRows(at: [indexPath], with: .automatic)
            }
            else
            {
                self.numbersArray.remove(at: indexPath.row)
                self.numbersTableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    //------------------------------------------------------------------------------
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        // odd numbers cannot be deleted from the number table
        if (tableView == self.numbersTableView)
        {
            if let numberVersion = Int(self.numbersArray[indexPath.row])
            {
                return (numberVersion % 2 != 0)
            }
        }
        return true
    }
    
    //------------------------------------------------------------------------------
    
    func sortableTableView(_ tableView: SortableTableView, draggedItemDidEnterTableViewAtRow row: Int) {
        self.logEvent("draggedItemDidEnterTableViewAtIndexPath fired")
    }
    
    //------------------------------------------------------------------------------
    
    func sortableTableView(_ tableView: SortableTableView, draggedItemDidExitTableViewFromRow row: Int) {
        self.logEvent("draggedItemDidExitTableViewFromIndexPath fired")
    }
    
    //------------------------------------------------------------------------------
    
    func sortableTableView(_ originalTableView: SortableTableView, itemMoveDidCancel originalRow: Int) {
        self.logEvent("itemMoveDidCancel fired")
    }
    
    //------------------------------------------------------------------------------
    
    func sortableTableView(_ originalTableView: SortableTableView, itemWasPickedUp originalRow: Int) {
        self.logEvent("itemWasPickedUp fired")
    }
    
    //------------------------------------------------------------------------------
    
    func sortableTableView(_ releasingTableView: SortableTableView, shouldReceiveItem originalRow: Int, desiredRow: Int, receivingTableView: SortableTableView) -> Bool {
        self.logEvent("shouldReceiveItem fired")
        return true
    }
}

