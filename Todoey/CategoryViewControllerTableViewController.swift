//
//  CategoryViewControllerTableViewController.swift
//  Todoey
//
//  Created by Rahul Padmakumar on 31/03/25.
//  Copyright © 2025 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    private var categories = [Category]()
    
    @IBAction func onAddButtonPressed(_ sender: UIBarButtonItem) {
        var alertTextField: UITextField = UITextField()
        
        let alertController = UIAlertController(title: "Add category", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Add Category", style: .default) { action in
            if let text = alertTextField.text{
                let category = Category(
                    context: self.context
                )
                category.name = text
                self.categories.append(category)
                self.saveCatorgories()
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
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCategories()
    }
    
    private func fetchCategories(){
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        do{
            categories = try context.fetch(fetchRequest)
        } catch {
            print("Fetch request failed \(error)")
        }
    }
    
    private func saveCatorgories(){
        do{
            try context.save()
        } catch {
            print("Error while saving category \(error)")
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "itemSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! ViewController
        if let selectedPath = tableView.indexPathForSelectedRow{
            destVC.selectedCategory = categories[selectedPath.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todo_category", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
}
