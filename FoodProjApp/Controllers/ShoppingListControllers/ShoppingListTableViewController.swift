//
//  ShoppingListTableViewController.swift
//  FoodProjApp
//
//  Created by kristians.tide on 23/11/2021.
//

import UIKit
import CoreData

class ShoppingListTableViewController: UITableViewController {

    @IBOutlet weak var tblView: UITableView!
    var shopping = [ShoppingList]()
    var managedObjectContext: NSManagedObjectContext?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
        
        loadData()
    }
    
    func loadData(){
        let request: NSFetchRequest<ShoppingList> = ShoppingList.fetchRequest()
        do{
            let result = try managedObjectContext?.fetch(request)
            shopping = result!
            tableView.reloadData()
        }catch{
            fatalError("error in loading core data item")
        }
    }
    
    func saveData(){
        do{
            try managedObjectContext?.save()
        }catch{
            fatalError("error in saving in core data item")
        }
        loadData()
    }
    
    func deleteAllData(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Shopping")
        let delete: NSBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do{
            try managedObjectContext?.execute(delete)
            saveData()
        }catch let err {
            print(err.localizedDescription)
        }
    }
    
    @IBAction func addItem(_ sender: Any) {
        let alertController = UIAlertController(title: "Shopping Item", message: "What do you want to add?", preferredStyle: .alert)
        alertController.addTextField { textField in
            print("textField: ", textField)
            textField.placeholder = "Enter your product"
        }
        alertController.addTextField { textFieldCount in
            print("textFieldCount: ", textFieldCount)
            textFieldCount.placeholder = "Number of items"
            textFieldCount.keyboardType = .numberPad
        }
        
        let addActionButton = UIAlertAction(title: "Add", style: .default) { action in
            let textField = alertController.textFields?[0]
            let textFieldCount = alertController.textFields?[1]
            let entity = NSEntityDescription.entity(forEntityName: "ShoppingList", in: self.managedObjectContext!)
            let shop = NSManagedObject(entity: entity!, insertInto: self.managedObjectContext)
            
            shop.setValue(textField?.text, forKey: "item")
            shop.setValue(textFieldCount?.text, forKey: "itemCount")
            
            self.saveData()
            self.tableView.reloadData()
        }//addActionButton
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(addActionButton)
        alertController.addAction(cancelButton)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func EditButton(_ sender: Any) {
        isEditing = !isEditing
    }
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = shopping[sourceIndexPath.row]
        shopping.remove(at: sourceIndexPath.row)
        shopping.insert(itemToMove, at: destinationIndexPath.row)
        loadData()
    }
    
    @IBAction func DeleteAllButton(_ sender: Any) {
        let alertController = UIAlertController(title: "Delete All Shopping items?", message: "Do you want to delete them all?", preferredStyle: .actionSheet)
        let addActionButton = UIAlertAction(title: "Delete", style: .destructive) { action in
            self.deleteAllData()
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(addActionButton)
        alertController.addAction(cancelButton)
        
        present(alertController, animated: true, completion: nil)
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return shopping.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingCell", for: indexPath)
        
        // Configure the cell...
        //        cell.textLabel?.text = shopping[indexPath.row]
        let shop = shopping[indexPath.row]
        cell.textLabel?.text = "Item: \(shop.value(forKey: "item") ?? "")"
        cell.detailTextLabel?.text = "Qty: \(shop.value(forKey: "itemCount") ?? "")"
        cell.accessoryType = shop.isCompleted ? .checkmark : .none
        return cell
    }
    
    
    // MARK: - Table view delegate
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            managedObjectContext?.delete(shopping[indexPath.row])
        }
        saveData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        shopping[indexPath.row].isCompleted = !shopping[indexPath.row].isCompleted
        saveData()
    }
        
}
    
    
    

    

