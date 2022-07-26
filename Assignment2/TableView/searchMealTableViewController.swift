//
//  searchMealTableViewController.swift
//  Assignment2
//
//  Created by Yuting Yu on 11/4/21.
//

import UIKit

class searchMealTableViewController: UITableViewController,UISearchBarDelegate {

    
    var indicator = UIActivityIndicatorView()
    var meals:[mealEntity] = []
    
    var SECTION_MEALS=0
    var SECTION_NORESULTS = 1
    var CELL_MEALS = "mealDetailCell"
    var CELL_NO_RESULTS = "no_resultsCell"
    let requestString = "https://www.themealdb.com/api/json/v1/1/search.php?s="
    weak var mealAddingDelegate:addMealDelegate?
    // used to determine whether the view is inital entry
    var initialEntry = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController


        
        //ensure search bar is alwasy visble
        navigationItem.hidesSearchBarWhenScrolling = false
        indicator.style = UIActivityIndicatorView.Style.large
        indicator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(indicator)

        
        NSLayoutConstraint.activate([indicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),indicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)])
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // ensure every new entry will display no row
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initialEntry = true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        switch section {
        case SECTION_MEALS:
            return meals.count
        case SECTION_NORESULTS:
            if initialEntry{
                return 0
            }
            return 1
        default:
            return 1
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == SECTION_MEALS{
            let mealCell = tableView.dequeueReusableCell(withIdentifier: CELL_MEALS, for: indexPath)
            let meal = meals[indexPath.row]
            mealCell.textLabel?.text = meal.name
            mealCell.detailTextLabel?.text = meal.instruction
            
            return mealCell
        }

        // Configure the cell...

    
        let noResultCell = tableView.dequeueReusableCell(withIdentifier: CELL_NO_RESULTS, for: indexPath)
        noResultCell.textLabel?.text = "Not what you were looking for? Tap to add a new meal"
        

        return noResultCell
    }
    

    
    // MARK: - Search bar function
    

    func requestMeal(_ mealName:String){
        guard let queryString = mealName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else{
            print("Query string cant be encoded")
            return
        }
        guard let requestURL = URL(string: requestString + queryString)  else{
            print("request url invalid")
            return
        }
        
        let task = URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
            
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
            }
            if let error = error{
                print(error)
            }
            else if let data = data{
                do{
                    let decoder = JSONDecoder()
                    let downloadMealList = try decoder.decode(MealData.self, from: data)
                    self.meals = downloadMealList.meals
                    
                    DispatchQueue.main.async {
                        // need update the search resuls on main thread
                        self.tableView.reloadData()
                    }
                    
                        
                }catch{
                    print(error)
            }

                
                
            }
        }
        task.resume()
        
        
        
    }
    

    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if let text = searchBar.text, text == ""{
            // clean table view once user press cancel
            meals.removeAll()
            tableView.reloadData()
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        meals.removeAll()
        // remove the no results section

        initialEntry = true
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // clean the meals before next fetch
        meals.removeAll()
        // no results section start loading after first search clicked
        initialEntry = false
        tableView.reloadData()
        indicator.startAnimating()
        if let searchText = searchBar.text,searchText != ""{
            requestMeal(searchText)

        }else{
            indicator.stopAnimating()
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate = mealAddingDelegate, indexPath.section == SECTION_MEALS{
            let meal:mealEntity = meals[indexPath.row]
            // returned ingredient list could containing empty string, remove here using map
            var ingredientList = meal.ingredients
            ingredientList = ingredientList.filter({!$0.key.isEmpty})
            
            if delegate.addMeal(name: meal.name ?? "", instruction: meal.instruction ?? "", ingredients: ingredientList){
                navigationController?.popViewController(animated: true)
            }
        }
    }
    /*
     
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.

    }
    

}
