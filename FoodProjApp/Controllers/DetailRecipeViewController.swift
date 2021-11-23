//
//  DetailRecipeViewController.swift
//  FoodProjApp
//
//  Created by kristians.tide on 22/11/2021.
//

import UIKit
import SDWebImage

class DetailRecipeViewController: UIViewController {

    var details: FoodItems!
    
    
    
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var titleTextLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
       // let extIngr = details.extendedIngredients
//        let extIngrName = extIngr[0]
//        let extIngrName1 = extIngrName[0]
        let myArray = details.cuisines
//        let ingredientArray = details.ingredients[1]
        titleTextLabel.text = details.title
        ImageView.sd_setImage(with: URL(string: details.imageURL), placeholderImage: UIImage(systemName: "applelogo"))
        detailsLabel.text = "Cuisine: " + myArray.joined(separator: ", ")
//        ingredientsLabel.text = details!.extendedIngredients.name
    }
    
    @IBAction func SaveButtonTapped(_ sender: Any) {
        
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
