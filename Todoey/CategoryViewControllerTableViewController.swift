//
//  CategoryViewControllerTableViewController.swift
//  Todoey
//
//  Created by Rahul Padmakumar on 31/03/25.
//  Copyright © 2025 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: SwipeTableViewController {
    
    private var categories: Results<Category>?
    private let realm = try! Realm(configuration: Realm.Configuration(deleteRealmIfMigrationNeeded: true))
    
    @IBAction func onAddButtonPressed(_ sender: UIBarButtonItem) {
        var alertTextField: UITextField = UITextField()
        
        let alertController = UIAlertController(title: "Add category", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Add Category", style: .default) { action in
            if let text = alertTextField.text{
                let category = Category()
                category.name = text
                self.saveCategories(category)
                self.tableView.reloadData()
            }
        }
        alertController.addTextField { textField in
            alertTextField = textField
            alertTextField.placeholder = "Add Category"
        }
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCategories()
    }
    
    private func fetchCategories(){
        categories = realm.objects(Category.self)
    }
    
    private func saveCategories(_ category: Category){
        do{
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error while saving category \(error)")
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "itemSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! ViewController
        if let selectedPath = tableView.indexPathForSelectedRow{
            if let category = categories?[selectedPath.row]{
                destVC.selectedCategory = category
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todo_category", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? ""
        return cell
    }
    
    override func deleteItem(index: Int) {
        if let item = self.categories?[index]{
            do{
                try self.realm.write{
                    self.realm.delete(item)
                    self.tableView.reloadData()
                }
            } catch {
                print("Delete error \(error)")
            }
        }
    }
    
    override func getElementNameAt(index: Int) -> String {
        return self.categories?[index].name ?? ""
    }
}
