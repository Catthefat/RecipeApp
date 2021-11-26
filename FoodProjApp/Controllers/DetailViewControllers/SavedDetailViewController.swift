//
//  SavedDetailViewController.swift
//  FoodProjApp
//
//  Created by kristians.tide on 24/11/2021.
//

import UIKit
import SDWebImage
import CoreData

class SavedDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var SavedIngredientTblView: UITableView!
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var IngredientLabel: UILabel!
    @IBOutlet weak var intstructionLabel: UILabel!
    
    var context: NSManagedObjectContext?
    var savedDetail = Items()
    var savedIngredients = [Ingredients]()
    
    var titleText = String()


    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        SavedIngredientTblView.delegate = self
        SavedIngredientTblView.dataSource = self
        
        TitleLabel?.text = savedDetail.recipeTitle
        IngredientLabel?.text = savedDetail.summary?
            .replacingOccurrences(of: "<b>", with: " ")
            .replacingOccurrences(of: "</b>", with: " ")
            .replacingOccurrences(of: "<a href=", with: " ")
            .replacingOccurrences(of: "</a>", with: " ")
//            .replacingOccurrences(of: "\\[.*?\\]", with: " ")
        ImageView.sd_setImage(with: URL(string: savedDetail.image!))
        
        loadData()
    }
    
    func loadData(){
        let request: NSFetchRequest<Ingredients> = Ingredients.fetchRequest()
        do{
            let result = try  context?.fetch(request)
            savedIngredients = result!
            SavedIngredientTblView.reloadData()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if savedIngredients.count == 0 {
                self.SavedIngredientTblView.setEmptyMessage("No ingredients found!")
            } else {
                self.SavedIngredientTblView.restore()
            }
        
        return savedIngredients.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "savedIngredientCell", for: indexPath) as? SavedDetailTableViewCell else {return UITableViewCell()}
//
        let item = savedIngredients[indexPath.row]
        cell.SavedIngredientLabel?.text = item.name
        cell.SavedAmountLabel?.text = String(item.amount)
//        let item = savedIngredients[indexPath.row]
//        cell.SavedIngredientLabel?.text = item.name
//        cell.SavedAmountLabel?.text = String(item.amount) + " " + item.unit!
//
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC: WebViewController = segue.destination as! WebViewController

        destinationVC.urlString = savedDetail.url!
    }

}
