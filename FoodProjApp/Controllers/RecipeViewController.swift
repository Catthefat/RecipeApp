//
//  ViewController.swift
//  FoodProjApp
//
//  Created by kristians.tide on 21/11/2021.
//

import UIKit
import SDWebImage
import CoreData


class RecipeViewController: UIViewController, UISearchBarDelegate {
    
//    let searchResult: String = "pasta"
    var apiKey = "63ce9be4c97b40a599b925a13b4ea5cd"
    var apiKey2 = "29483c45113645b3bb52bd896bd5836e" //two api keys because during testing i used up all calls too quickly

    var context: NSManagedObjectContext?
    var savedItems = [Items]()
    
    var spoonacularSourceUrl1 = String()
    var titleString = String()
    var servingsString = String()
    var imageURLString = String()
    var readyInMinutesString = String()
    var sourceNameString = String()

    
    var foodItems: [FoodItems] = []
    let sourceUrl = String()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Recipes"
        self.searchBar.delegate = self
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    func saveData(){
        do{
            try context?.save()
        }catch{
            fatalError("error in saving in core data item")
        }
        loadData()

    }
    func loadData(){
           let request: NSFetchRequest<Items> = Items.fetchRequest()
           do{
               let result = try  context?.fetch(request)
               savedItems = result!
           }catch{
               fatalError("error in loading core data item")
           }
       }
    
//MARK: search bar text to handleGetData(query: String)
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            tblView?.reloadData()
            handleGetData(query: text)
        }
        searchBar.endEditing(true)
       }
    
//MARK: Handle Json data
    func handleGetData(query: String){
        let jsonUrl = "https://api.spoonacular.com/recipes/complexSearch?query=\(query)&addRecipeInformation=true&sort=popularity&sortDirection=asc&number=1&apiKey=\(apiKey)"
        
        guard let url = URL(string: jsonUrl) else {return}
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        //urlsession
        
        URLSession(configuration: config).dataTask(with: urlRequest) { data, response, error in
            if error != nil {
                print((error?.localizedDescription)!)
                self.basicAlert(title: "Error!", message: "\(String(describing: error?.localizedDescription))")
                return
            }
            
            guard let data = data else {
                self.basicAlert(title: "Error!", message: "Something weng wrong, no data.")
                return
            }
            
            do{
                let jsonData = try JSONDecoder().decode(Results.self, from: data)
                self.foodItems = jsonData.results
                DispatchQueue.main.async {
                    print("self.foodItems:", self.foodItems)
                    self.tblView.reloadData()
                }
            }catch{
                print("err:", error)
            }
            
        }.resume()
    }
}
//extension String {
//    func textAtributes(text: String, font: UIFont? = nil) -> NSAttributedString {
//        let _font = font ?? UIFont.systemFont(ofSize: 14, weight: .regular)
//        let fullString = NSMutableAttributedString(string: self, attributes: [NSAttributedString.Key.font : _font])
//        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: _font.pointSize)]
//        let range = (self as NSString).range(of: text)
//        fullString.addAttributes(boldFontAttribute, range: range)
//        return fullString
//    }
//
//}

extension RecipeViewController: UITableViewDelegate, UITableViewDataSource {
//MARK: Cell and Table Configuration
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as? RecipeTableViewCell else {return UITableViewCell()}
        
        let item = foodItems[indexPath.row]
        cell.authorLabel.text = "Author: " + item.sourceName
        cell.servingsLabel.text = "Servings: " + String(item.servings)
        cell.readyInLabel.text = "Cooking Time: " + String(item.readyInMinutes) + " min"
        cell.RecipeNameLabel.text = item.title
        cell.recipeImageView.sd_setImage(with:URL(string: item.imageURL), placeholderImage: UIImage(named: "applelogo"))
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }

//MARK: Trailing swipe "Save" action
    func handleMarkAsSaved() {
        let newItem = Items(context: context!)
        newItem.url = spoonacularSourceUrl1
        newItem.author = sourceNameString
        newItem.recipeTitle = titleString
        newItem.servings = servingsString
        newItem.readyIn = readyInMinutesString
        newItem.image = imageURLString
        print("newItem.newsTitle: ", savedItems)
        savedItems.append(newItem)
        saveData()
        loadData()

    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Save") {
            (action, view, completionHandler) in self.handleMarkAsSaved()
            completionHandler(true)
        }
        action.backgroundColor = .systemYellow
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    
//MARK: Segue to WebView
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showLink" {
            if let indexPath = tblView.indexPathForSelectedRow {
                let destination = segue.destination as?
                WebViewController
                let item = foodItems[indexPath.row]
                destination?.urlString = item.sourceUrl
            }
        }
    }
}
