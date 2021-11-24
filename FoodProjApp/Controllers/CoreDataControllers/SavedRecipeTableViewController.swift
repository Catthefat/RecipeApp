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

    @IBOutlet var SavedRecipeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reloadInputViews()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        loadData()
    }

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
    
    @IBAction func startEditing(_ sender: Any) {
        isEditing = !isEditing
    }
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = savedItems[sourceIndexPath.row]
        savedItems.remove(at: sourceIndexPath.row)
        savedItems.insert(itemToMove, at: destinationIndexPath.row)
        loadData()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedItems.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "savedCell", for: indexPath) as? SavedRecipeTableViewCell else {return UITableViewCell()}
        
//        let indexPath = SavedRecipeTableView.indexPathForSelectedRow
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = SavedRecipeTableView.indexPathForSelectedRow
        let item = savedItems[indexPath!.row]
        // Get the new view controller using segue.destination.
        
        let destinationVC: WebViewController = segue.destination as! WebViewController
        destinationVC.urlString = item.url!
        // Pass the selected object to the new view controller.
        
    }

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
