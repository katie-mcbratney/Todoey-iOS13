//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    
    var items : Results<Item>?
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    let realm = try! Realm()
    
    let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext


    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.allowsMultipleSelectionDuringEditing = false;
        
        loadItems()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = UIColor(selectedCategory?.color ?? UIColor.systemBlue.hexString())
        navigationController?.navigationBar.titleTextAttributes = [.strokeColor : UIColor(selectedCategory?.color ?? UIColor.black.hexString())]
        navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    //MARK: - tableView data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        if let item = items?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            cell.textLabel?.textColor = UIColor(item.textColor ?? UIColor.black.hexString())
            
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        return cell
    }
    
    //MARK: - Table view delegate functions
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let item = items?[indexPath.row] {
            do{
                try realm.write {
                    item.done = !item.done
                }
            }catch {
                print("Error saving done dstatus /(error)")
            }
        }
        tableView.reloadData()
        //items[indexPath.row].done = !items[indexPath.row].done
        //saveData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if let currentCategory = self.selectedCategory {
            do{
                try self.realm.write {
                    currentCategory.items.remove(at: indexPath.row)
                }
            }catch {
                print(error)
            }
        }
        tableView.reloadData()
        
//            if (editingStyle == UITableViewCell.EditingStyle.delete) {
//                self.context.delete(itemArray[indexPath.row])
//                self.itemArray.remove(at: indexPath.row)
//                self.saveData()
//            }
    }


    //MARK: - add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) {(action) in
            if textField.text != "" {
                
                if let currentCategory = self.selectedCategory {
                    do{
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = textField.text!
                            newItem.dateCreated = Date()
                            if let color = currentCategory.color {
                                newItem.textColor = UIColor(color).darker(by: 75)?.hexString()
                            }
                            currentCategory.items.append(newItem)
                        }
                    }catch {
                        print(error)
                    }
                }
                
                //let newItem = Item(context: self.context)
                
                //newItem.parentCategory = self.selectedCategory
                
                //self.itemArray.append(newItem)
                //self.saveData()
                
                self.tableView.reloadData()
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (cancel) in
            alert.dismiss(animated: true)
        }
        
        alert.addTextField() { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(cancel)
        alert.addAction(action)
        present(alert, animated:true, completion:nil)
    }
    
//    func saveData() {
//        do {
//            try context.save()
//        } catch {
//            print(error)
//        }
//        self.tableView.reloadData()
//    }
    
    func loadItems(){
        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
//    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(),predicate: NSPredicate? = nil) {
//
//        let categoryPredicate = NSPredicate(format:"parentCategory.name MATCHES %@", selectedCategory!.name!)
//        if let additionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//        } else {
//            request.predicate = categoryPredicate
//        }
//
//
//        do {
//            itemArray = try context.fetch(request)
//        } catch {
//            print("Error fetching data")
//        }
//        tableView.reloadData()
//    }
        
}
    
    //MARK: - Search Bar Delegate methods
    
extension ToDoListViewController : UISearchBarDelegate {
        
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
       // let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        items = items?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        //items = items?.filter(predicate).sorted(byKeyPath: "title", ascending: true)
        
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request, predicate: predicate)
        tableView.reloadData()
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

extension UIColor {

    func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }

    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }

    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }
}
    


