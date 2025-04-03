//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Rahul Padmakumar on 03/04/25.
//  Copyright © 2025 App Brewery. All rights reserved.
//

import UIKit

class SwipeTableViewController: UITableViewController {
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let printAction = UIContextualAction(
            style: .normal, title: nil) { _, _, completion in
                print(self.getElementNameAt(index: indexPath.row))
                completion(true)
            }
        printAction.image = UIImage(systemName: "printer")
        printAction.backgroundColor = .orange
        return UISwipeActionsConfiguration(actions: [printAction])
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(
            style: .destructive, title: nil) { _, _, completion in
                self.deleteItem(index: indexPath.row)
                completion(true)
            }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .blue
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func deleteItem(index: Int){
        print(index)
    }
    
    func getElementNameAt(index: Int) -> String{
        print(index)
        return "Hello"
    }
}
