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

  
    var savedDetail = [Items]()
    var context: NSManagedObjectContext?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let destinationVC: WebViewController = segue.destination as! WebViewController
//
//        destinationVC.urlString = savedDetail!.url
//
//    }

}
