//
//  DetailRecipeViewController.swift
//  FoodProjApp
//
//  Created by kristians.tide on 22/11/2021.
//

import UIKit
import SDWebImage
import CoreData

class DetailRecipeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var details: FoodItems!
    var foodItems: [FoodItems] = []

    
    
    
    @IBOutlet weak var DetailTblView: UITableView!
    @IBOutlet weak var urlButton: UIBarButtonItem!
    @IBOutlet weak var ingredientsLabel: UILabel!

    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var titleTextLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        DetailTblView.delegate = self
        DetailTblView.dataSource = self
        
        
        instructionsLabel?.text = details.summary
            .replacingOccurrences(of: "<b>", with: " ")
            .replacingOccurrences(of: "</b>", with: " ")
            .replacingOccurrences(of: "<a href=", with: " ")
            .replacingOccurrences(of: "</a>", with: " ")
        titleTextLabel?.text = details.title
//        ImageView.sd_setImage(with: URL(string: details.image))
        

//        let words: () = details.extendedIngredients.forEach({ ExtendedIngredients in
//            ingredientsLabel?.text = ExtendedIngredients.name + String(ExtendedIngredients.amount) + ExtendedIngredients.unit
//
//        })
//        print("Words: ", words)
//
//        for extendedIngredients in details.extendedIngredients {
//            print("name: ", extendedIngredients.name)
//            ingredientsLabel?.text = extendedIngredients.name
//        }
//    }
//    + String(extendedIngredients.amount) + extendedIngredients.unit
//    cell.dateLabel.text = item.publishedAt
//          .replacingOccurrences(of: "T", with: " ")
//          .replacingOccurrences(of: "Z", with: "")
    
    }

    var testArr = ["one", "two", "three"]

//MARK: Cell and Table Configuration
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if foodItems.count == 0 {
                self.DetailTblView.setEmptyMessage("No ingredients found!")
            } else {
                self.DetailTblView.restore()
            }
        
        return details.extendedIngredients.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath) as? DetailTableViewCell else {return UITableViewCell()}
        
        let item = details.extendedIngredients[indexPath.row]
        cell.IngredientsLabel?.text = item.name
        cell.AmountLabel?.text = String(item.amount) + " " + item.unit
      
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       let destinationVC: WebViewController = segue.destination as! WebViewController
       
       destinationVC.urlString = details!.sourceUrl
       // Pass the selected object to the new view controller.
   }
}

