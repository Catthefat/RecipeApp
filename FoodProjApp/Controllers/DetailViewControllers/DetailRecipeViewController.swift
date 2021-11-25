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

        
        
        instructionsLabel?.text = details.summary
            .replacingOccurrences(of: "<b>", with: " ")
            .replacingOccurrences(of: "</b>", with: " ")
            .replacingOccurrences(of: "<a href=", with: " ")
            .replacingOccurrences(of: "</a>", with: " ")
        titleTextLabel?.text = details.title
        ImageView.sd_setImage(with: URL(string: details.image))
        

//        let words: () = details.extendedIngredients.forEach({ ExtendedIngredients in
//            ingredientsLabel?.text = ExtendedIngredients.name + String(ExtendedIngredients.amount) + ExtendedIngredients.unit
//
//        })
//        print("Words: ", words)
        
        for extendedIngredients in details.extendedIngredients {
            print("name: ", extendedIngredients.name)
            ingredientsLabel?.text = extendedIngredients.name
        }
    }
//    + String(extendedIngredients.amount) + extendedIngredients.unit
//    cell.dateLabel.text = item.publishedAt
//          .replacingOccurrences(of: "T", with: " ")
//          .replacingOccurrences(of: "Z", with: "")
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC: WebViewController = segue.destination as! WebViewController
        
        destinationVC.urlString = details!.sourceUrl
        // Pass the selected object to the new view controller.
    }

}
