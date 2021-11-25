//
//  SavedDetailViewController.swift
//  FoodProjApp
//
//  Created by kristians.tide on 24/11/2021.
//

import UIKit
import SDWebImage
import CoreData

class SavedDetailViewController: UIViewController {
    
    
    @IBOutlet weak var SavedIngredientTblView: UITableView!
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var IngredientLabel: UILabel!
    @IBOutlet weak var intstructionLabel: UILabel!
    
    var context: NSManagedObjectContext?
    var savedDetail = Items()
    
    var titleText = String()


    override func viewDidLoad() {
        super.viewDidLoad()
//        loadData()
        
        TitleLabel?.text = savedDetail.recipeTitle
        IngredientLabel?.text = savedDetail.summary
        ImageView.sd_setImage(with: URL(string: savedDetail.image!))
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if foodItems.count == 0 {
                self.SavedIngredientTblView.setEmptyMessage("No ingredients found!")
            } else {
                self.SavedIngredientTblView.restore()
            }
        
        return savedDetail.extendedIngredients.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "savedIngredientCell", for: indexPath) as? SavedDetailTableViewCell else {return UITableViewCell()}
        
        let item = SavedIngredientTblView.extendedIngredients[indexPath.row]
        cell.IngredientsLabel?.text = item.name
        cell.AmountLabel?.text = String(item.amount) + " " + item.unit
      
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
