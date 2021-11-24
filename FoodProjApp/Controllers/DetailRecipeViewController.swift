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
    
    
    
    @IBOutlet weak var urlButton: UIBarButtonItem!
    @IBOutlet weak var ingredientsLabel: UILabel!

    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var titleTextLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  let ingredientArray = details.extendedIngredients[1]
//        let ingrArray = ingredientArray.joined(separator: ", ")
        
        titleTextLabel?.text = details.title
        ImageView.sd_setImage(with: URL(string: details.image))
//        ingredientsLabel?.text = ingrArray
       
//        let myArray = details.cuisines
//        let ingredientArray = details.ingredients[1]
//        titleTextLabel.text = details.title
//        ImageView.sd_setImage(with: URL(string: details.imageURL), placeholderImage: UIImage(systemName: "applelogo"))
//        detailsLabel.text = "Cuisine: " + myArray.joined(separator: ", ")
//        ingredientsLabel.text = details!.extendedIngredients.name
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC: WebViewController = segue.destination as! WebViewController
        
        destinationVC.urlString = details!.sourceUrl
        // Pass the selected object to the new view controller.
    }

}
