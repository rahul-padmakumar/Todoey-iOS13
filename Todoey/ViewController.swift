//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UITableViewController {
    
    var itemArray: Results<Item>?
    
    let realm = try! Realm(configuration: Realm.Configuration(deleteRealmIfMigrationNeeded: true))
    
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onAddButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField: UITextField = UITextField()
        
        let alert = UIAlertController(title: "Add todo item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default){ (action) in
            if let safeText = textField.text{
                if let category = self.selectedCategory{
                    do{
                        try self.realm.write{
                            let newItem = Item()
                            newItem.title = safeText
                            newItem.isChecked = false
                            newItem.dateCreated = Date()
                            category.items.append(newItem)
                        }
                    } catch {
                        print("Error in saving item")
                    }
                }
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
        return itemArray?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let itemForRow = itemArray?[indexPath.row]
        cell.textLabel?.text = itemForRow?.title ?? ""
        cell.accessoryType = itemForRow?.isChecked ?? false ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do{
            try realm.write{
                itemArray?[indexPath.row].isChecked = !(itemArray?[indexPath.row].isChecked ?? false)
            }
        } catch{
            print("Save error while updating check mark")
        }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
        let deleteAction = UIContextualAction(
            style: .destructive, title: nil) { _, _, completion in
                
                if let item = self.itemArray?[indexPath.row]{
                    do{
                        try self.realm.write{
                            self.realm.delete(item)
                            self.tableView.reloadData()
                        }
                    } catch {
                        print("Delete error \(error)")
                    }
                }
                
                completion(true)
            }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .blue
        
        let printAction = UIContextualAction(
            style: .normal, title: nil) { _, _, completion in
                print(self.itemArray?[indexPath.row] ?? "")
                completion(true)
            }
        printAction.image = UIImage(systemName: "printer")
        deleteAction.backgroundColor = .orange
        return UISwipeActionsConfiguration(actions: [deleteAction, printAction])
    }
    
    private func loadItems(){
        itemArray = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
    }
}

// Mark - Search Bar delegate

extension ViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(searchBar.text!)
        itemArray = itemArray?.where({ query in
            query.title.contains(searchBar.text!)
        }).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty{
            loadItems()
            tableView.reloadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

