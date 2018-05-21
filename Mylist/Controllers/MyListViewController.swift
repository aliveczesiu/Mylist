//
//  ViewController.swift
//  Mylist
//
//  Created by Krzysztof Synowiec on 06/05/2018.
//  Copyright © 2018 Krzysztof Synowiec. All rights reserved.
//

import UIKit
import CoreData

class MyListViewController: UITableViewController {

    var itemArray = [Item]()
    
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
//MARK - TableView datasource methods
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyListItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]

        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
        
    }
    //MARK - TableView delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
       
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item To Your List", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
           
    //What will happen once the user clicks the Add Item button on our IUAlert
            
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK - Model Manipulation Methods
    
    func saveItems() {
        
        do {
           try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
        
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
       
        let categoryPredicate = NSPredicate(format:"parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let addtionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addtionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
              itemArray = try context.fetch(request)
           } catch {
                print("Error fetching data from context \(error)")
           }
        
        tableView.reloadData()
    }
}

//Mark - Search Bar Methods

extension MyListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
       
        }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
    


