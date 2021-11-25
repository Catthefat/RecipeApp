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
    
//    func loadData(){
//        let request: NSFetchRequest<Items> = Items.fetchRequest()
//        do{
//            let result = try  context?.fetch(request)
//            savedDetail = result
//        }catch{
//            fatalError("error in loading core data item")
//        }
//    }
//
//    func saveData(){
//        do{
//            try context?.save()
//        }catch{
//            fatalError("error in saving in core data item")
//        }
//        loadData()
//
//    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC: WebViewController = segue.destination as! WebViewController

        destinationVC.urlString = savedDetail.url!

    }

}
