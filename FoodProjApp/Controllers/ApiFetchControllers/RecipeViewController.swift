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
    
    var apiKey = "63ce9be4c97b40a599b925a13b4ea5cd"
    var apiKey2 = "29483c45113645b3bb52bd896bd5836e" //two api keys because during testing i used up all calls too quickly
    
    var savedItems = [Items]()
    var savedIngredients = [Ingredients]()
    var context: NSManagedObjectContext?
    var foodItems: [FoodItems] = []
    let sourceUrl = String()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self

        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.textColor = UIColor.white
            textField.backgroundColor = UIColor.systemOrange
            textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
            if let leftView = textField.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                leftView.tintColor = UIColor.darkGray
            }
        }
        //
//        searchBar.setTextFieldColor(UIColor.systemOrange)

        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        
    }
    //MARK: Save/Load Data
    
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
    
    //MARK: Trailing swipe "Save" action
    
    
    func handleMarkAsSaved(indexPath: IndexPath) {
        let newItem = Items(context: context!)
        let newItem2 = Ingredients(context: context!)
        print("indexPath:", indexPath)
        let item = foodItems[indexPath.row]
        
        newItem2.name = item.extendedIngredients[0].name
        newItem2.unit = item.extendedIngredients[0].unit
        newItem2.amount = item.extendedIngredients[0].amount

        newItem.url = item.sourceUrl
        newItem.author = item.sourceName
        newItem.recipeTitle = item.title
        newItem.image = item.image
        newItem.readyIn = String(item.readyInMinutes)
        newItem.servings = String(item.servings)
        newItem.summary = item.summary
        
        
        savedItems.append(newItem)
        print("newItem.newsTitle: ", savedItems)
        saveData()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Save") {
            (action, view, completionHandler) in self.handleMarkAsSaved(indexPath: indexPath)
            completionHandler(true)
        }
        action.backgroundColor = .systemOrange
        return UISwipeActionsConfiguration(actions: [action])
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
        let jsonUrl = "https://api.spoonacular.com/recipes/complexSearch?addRecipeInformation=true&sort=popularity&sortDirection=asc&query=\(query)&number=1&apiKey=\(apiKey2)&fillIngredients=true"
        
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

extension UITableView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .systemOrange
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "Arial", size: 23)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}

extension RecipeViewController: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Cell and Table Configuration
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if foodItems.count == 0 {
                self.tblView.setEmptyMessage("What type of food would you like today?")
            } else {
                self.tblView.restore()
            }
        return foodItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as? RecipeTableViewCell else {return UITableViewCell()}
        
        let item = foodItems[indexPath.row]
        cell.authorLabel.text = "Author: " + item.sourceName
        cell.servingsLabel.text = "Servings: " + String(item.servings)
        cell.readyInLabel.text = "Cooking Time: " + String(item.readyInMinutes) + " min"
        cell.RecipeNameLabel.text = item.title
        cell.recipeImageView.sd_setImage(with:URL(string: item.image), placeholderImage: UIImage(named: "applelogo"))
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    
    //MARK: Segue to WebView
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tblView.indexPathForSelectedRow {
            print("Index path:", indexPath)

        let detailVC = segue.destination as! DetailRecipeViewController

        detailVC.details = foodItems[indexPath.row]
            
        }
    }
    
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showLink" {
//            if let indexPath = tblView.indexPathForSelectedRow {
//                let destination = segue.destination as?
//                WebViewController
//                let item = foodItems[indexPath.row]
//                destination?.urlString = item.sourceUrl
//            }
//        }
//    }
}
