//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Katie McBratney on 8/18/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import RandomColor
import UIColor_Hex_Swift

class CategoryViewController: UITableViewController {
    
    var categories: Results<Category>?
    let realm = try! Realm()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = UIColor.systemBlue
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white.withAlphaComponent(0.5)]
        navigationController?.navigationBar.tintColor = UIColor.white
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.backgroundColor = UIColor(categories?[indexPath.row].color ?? UIColor.white.hexString()).withAlphaComponent(0.5)
        //categories?[indexPath.row].color = cell.backgroundColor?.hexString(true)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories added yet"

        return cell
    }
    
    // MARK: - Table view delegate methods
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        //if let currentCategory = self.selectedCategory {
        if let currentCategories = categories {
            do{
                try self.realm.write {
                    realm.delete(currentCategories[indexPath.row])
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
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK: - Data manipulation methods

    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action)  in
            if(textField.text != ""){
                let newCategory = Category()
                newCategory.name = textField.text!
                newCategory.color = randomColor(luminosity: .light).hexString(true)
                //self.categories. (newCategory)
                self.save(category: newCategory)
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) {_ in
            alert.dismiss(animated: true)
        }
        alert.addTextField() { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated:true, completion:nil)
    }
    func save(category: Category){
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print(error)
        }
        self.tableView.reloadData()
    }
    
    func loadCategories(){
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
//    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()){
//        do {
//            categories = try context.fetch(request)
//        } catch {
//            print("Error fetching data from context: \(error)")
//        }
//        tableView.reloadData()
//    }
    

}
