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

    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        .first?.appendingPathComponent("items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(filePath!)
        loadItems()
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
                self.saveItems()
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
        cell.accessoryType = itemForRow.isChecked ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].isChecked = !itemArray[indexPath.row].isChecked
        saveItems()
        tableView.reloadData()
    }
    
    private func saveItems(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.filePath!)
        } catch{
            print("Error while encoding \(error.localizedDescription)")
        }
    }
    
    private func loadItems(){
        if let data = try? Data(contentsOf: filePath!){
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([Item].self, from: data)
            } catch{
                print("Error decoding Array \(error.localizedDescription)")
            }
        }
    }
}

