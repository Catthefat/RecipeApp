//
//  SavedRecipeTableViewController.swift
//  FoodProjApp
//
//  Created by kristians.tide on 23/11/2021.
//

import UIKit
import CoreData
import SDWebImage

class SavedRecipeTableViewController: UITableViewController {

    
    var savedItems = [Items]()
    var context: NSManagedObjectContext?
    var recipeTitle = String()
    var urlStr = String()

    @IBOutlet weak var EditBttn: UIBarButtonItem!
    @IBOutlet var SavedRecipeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reloadInputViews()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        loadData()
    }
    
    //swipe down to refresh and fetch data
    @IBAction func HandleRefresh(_ sender: Any) {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { (timer) in
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Items")
            do{
                try self.context?.execute(request)
                self.saveData()
            }catch let err {
                print(err.localizedDescription)
            }
            self.refreshControl?.endRefreshing()
        })
    }
    
//MARK: Save/Load Data
    func loadData(){
        let request: NSFetchRequest<Items> = Items.fetchRequest()
        do{
            let result = try  context?.fetch(request)
            savedItems = result!
            tableView.reloadData()
        }catch{
            fatalError("error in loading core data item")
        }
    }
    
    func saveData(){
        do{
            try context?.save()
        }catch{
            fatalError("error in saving in core data item")
        }
        loadData()
        
    }

//MARK: Deleteing
    //alert for deleting all
    func basicAlert2(indexPath: IndexPath) {
        let alert = UIAlertController(title: "Delete?", message: "", preferredStyle: .alert)
        let yes = UIAlertAction(title: "OK", style: .default) { [self]
            _ in self.context?.delete(savedItems[indexPath.row])
            self.saveData()
            self.tableView.reloadData()
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelButton)
        alert.addAction(yes)
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    func deleteAllData(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Items")
        let delete: NSBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do{
            try context?.execute(delete)
            saveData()
        }catch let err {
            print(err.localizedDescription)
        }
    }
    
    
    // trash icon "Delete all"
    @IBAction func DeleteButton(_ sender: Any) {
        let alertController = UIAlertController(title: "Delete All?", message: "Do you want to delete them all?", preferredStyle: .actionSheet)
        let addActionButton = UIAlertAction(title: "Delete", style: .destructive) { action in
            self.deleteAllData()
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(addActionButton)
        alertController.addAction(cancelButton)
        
        present(alertController, animated: true, completion: nil)
        saveData()
    }

//MARK: Edit button
    @IBAction func EditBttnPressed(_ sender: Any) {
        SavedRecipeTableView.isEditing = !SavedRecipeTableView.isEditing
        
        //when editing it changes text from "Edit" to "Done"
        switch SavedRecipeTableView.isEditing{
        case true:
            EditBttn.title = "Done"
        case false:
            EditBttn.title = "Edit"

        }
    }
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = savedItems[sourceIndexPath.row]
        savedItems.remove(at: sourceIndexPath.row)
        savedItems.insert(item, at: destinationIndexPath.row)
    }
    
    
    
// MARK: Table view and cell setup
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if savedItems.count == 0 {
                self.SavedRecipeTableView.setEmptyMessage("Swipe down to refresh")
            } else {
                self.SavedRecipeTableView.restore()
            }
        
        return savedItems.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "savedCell", for: indexPath) as? SavedRecipeTableViewCell else {return UITableViewCell()}
        
        let item = savedItems[indexPath.row]
        
        cell.SavedTitleLabel?.text = item.recipeTitle
        cell.SavedAuthorLabel?.text = "Author: " + item.author!
        cell.SavedReadyInLabel?.text = "Cooking Time: " + item.readyIn! + " min"
        cell.savedServingsLabel?.text = "Servings: " + item.servings!
        cell.SavedImageView.sd_setImage(with: URL(string: item.image!))
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            basicAlert2(indexPath: indexPath)
        }
        saveData()
    }
    
//MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = SavedRecipeTableView.indexPathForSelectedRow {
            print("Index path:", indexPath)

        let detailVC = segue.destination as! SavedDetailViewController

        detailVC.savedDetail = savedItems[indexPath.row]
    }
}
}

