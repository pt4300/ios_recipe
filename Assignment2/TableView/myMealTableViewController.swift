//
//  myMealTableViewController.swift
//  Assignment2
//
//  Created by Yuting Yu on 11/4/21.
//

import UIKit

class myMealTableViewController: UITableViewController,UISearchBarDelegate {

    
    
    var meals:[Meal]=[]
    let SECTION_MEAL = 0
    let SECTION_COUNT = 1
    let CELL_MEAL = "mealDetailCell"
    let CELL_COUNT = "countCell"
    var listenerType:ListenerType = .myMeal
    
    weak var databaseController:DatabaseProtocol?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    

    // MARK: - Table view data source


    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
 
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        switch section {
        case SECTION_MEAL:
            return meals.count
        case SECTION_COUNT:
            return 1
        default:
            return 1
        }
    }

    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section==SECTION_MEAL {
            let mealCell = tableView.dequeueReusableCell(withIdentifier: CELL_MEAL, for: indexPath)
            let meal = meals[indexPath.row]
            mealCell.textLabel?.text = meal.name
            mealCell.detailTextLabel?.text = meal.instruction
            return mealCell
        }
        
        let countCell = tableView.dequeueReusableCell(withIdentifier: CELL_COUNT, for: indexPath)
        if meals.count > 0{
            countCell.textLabel?.text = "\(meals.count) stored meal"

        }
        else{
            countCell.textLabel?.text = "There is no meal added in list now. Please use search function to add more."

        }
        
        return countCell
        // Configure the cell...
            
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        if indexPath.section == SECTION_MEAL{
            return true
        }
        return false
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == SECTION_COUNT{
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            databaseController?.removeMeal(meal: meals[indexPath.row])
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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
        
        if segue.identifier == "editMyMealSegue"{
            // using sender to locate the position of selected meal and pass to edit screen
            
            if let cell = sender as? UITableViewCell{
                let indexPath = tableView.indexPath(for: cell)
                let destination = segue.destination as! editCreateTableViewController
                destination.meal = meals[indexPath!.row]
                
                
            }
        }
        else if segue.identifier == "addMealSegue"{
            let destination = segue.destination as! searchMealTableViewController
            destination.mealAddingDelegate = self
        }
    }
    

}



extension myMealTableViewController:DatabaseListener{
    func onIngredientChange(change: DatabaseChange, ingredients: [Ingredient]) {
        //
    }
    
    func onIngredientMeasurementChange(change: DatabaseChange, ingredients: [IngredientMeasurement]) {
        //
    }
    
    
    func onMealChange(change: DatabaseChange, mealList: [Meal]) {
        meals = mealList
        tableView.reloadData()
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
        
    }
}


extension myMealTableViewController:addMealDelegate{
    func addMeal(name: String, instruction: String, ingredients: [String : String]) -> Bool {
        databaseController?.addMeal(name: name, instruction: instruction, ingredients: ingredients)
        tableView.reloadData()
        return true

    }

    

    
    
}
