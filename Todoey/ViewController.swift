//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var itemArray = [Item]()
    let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        //if let items = userDefaults.array(forKey: "todo_items") as? [Item]{
        //    itemArray = items
        //}
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onAddButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField: UITextField = UITextField()
        
        let alert = UIAlertController(title: "Add todo item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default){ (action) in
            if let safeText = textField.text{
                let newItem = Item(
                    title: safeText, isChecked: false
                )
                self.itemArray.append(newItem)
                //self.userDefaults.set(self.itemArray, forKey: "todo_items")
                self.tableView.reloadData()
            }
        }
        alert.addTextField { alertTextField in
            textField = alertTextField
            alertTextField.placeholder = "Create new item"
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let itemForRow = itemArray[indexPath.row]
        cell.textLabel?.text = itemForRow.title
        cell.accessoryType = if(itemForRow.isChecked){
            .checkmark
        } else {
            .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].isChecked = !itemArray[indexPath.row].isChecked
        tableView.reloadData()
    }
}

