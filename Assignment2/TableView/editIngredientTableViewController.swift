//
//  editIngredientTableViewController.swift
//  Assignment2
//
//  Created by Yuting Yu on 11/4/21.
//

import UIKit

class editIngredientTableViewController: UITableViewController {
    
    var ingredientList:[Ingredient] = []
    var CELL_INGREDIENT = "ingredientCell"
    var listenerType: ListenerType = .ingredient
    weak var editeIngredientDelegate:editIngredientDelegate?
    
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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ingredientList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_INGREDIENT, for: indexPath)
        let ingredient = ingredientList[indexPath.row]
        cell.textLabel?.text = ingredient.name
        // Only show accessory button if the ingredient has description
        if let description = ingredient.ingredientDescription, description != ""{
            cell.accessoryType = UITableViewCell.AccessoryType.detailDisclosureButton

        }

        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // need run the alert controller inside didselect function, otherwise the data wont reflect properly
        
        let ingredient = ingredientList[indexPath.row]
        let alert = UIAlertController(title: "Add measurement", message: "Enter measurement for \(ingredient.name)", preferredStyle: .alert)
        alert.addTextField { (textfield) in
            textfield.placeholder = "Please enter valid measurement"
        }
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Done", comment: "confirm action"), style: .default, handler: { (_) in
            // using hardcoded index for input text as only one textfield is added
            if let measurement = alert.textFields?[0].text, measurement != "",let addIngredientDelegate = self.editeIngredientDelegate{
                
                if let name = ingredient.name{
                    if  addIngredientDelegate.addIngredient(name: name, quantity: measurement){
                        self.navigationController?.popViewController(animated: true)
                    }

                }

            }
            else{
                self.displayMessage(title: "Empty Measurement", message: "You must enter a measurement for \(ingredient.name).")
            }
             
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
  
        
        


        tableView.deselectRow(at: indexPath, animated: false)
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
        if segue.identifier == "ingredientDetailSegue"{
            let destination = segue.destination as! ingredientDetailViewController
            if let cell = sender as? UITableViewCell{
                let indexPath = tableView.indexPath(for: cell)
                destination.ingredientDetail = ingredientList[indexPath!.row].ingredientDescription

            }
            
        }
        
    }
    

}


extension editIngredientTableViewController:DatabaseListener{

    
    func onMealChange(change: DatabaseChange, mealList: [Meal]) {
        //
    }
    
    func onIngredientMeasurementChange(change: DatabaseChange, ingredients: [IngredientMeasurement]) {
        //
    }
    
    func onIngredientChange(change: DatabaseChange, ingredients: [Ingredient]) {
        ingredientList = ingredients
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
    
    
    // This function are used to provide popup window for user to ennter ingredient measurement
    func addMeasurement(ingredient:Ingredient)->String?{
        var returnedValue:String?
        let alert = UIAlertController(title: "Add measurement", message: "Enter measurement for \(ingredient.name)", preferredStyle: .alert)
        alert.addTextField { (textfield) in
            textfield.placeholder = "Please enter valid measurement"
        }
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Done", comment: "confirm action"), style: .default, handler: { (_) in
            // using hardcoded index for input text as only one textfield is added
            if let measurement = alert.textFields?[0].text, measurement != ""{

                returnedValue = measurement
            }
            else{
                self.displayMessage(title: "Empty Measurement", message: "You must enter a measurement for \(ingredient.name).")
            }
             
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        return returnedValue
    }
    
    
    // general function for display alert message
    func displayMessage(title:String,message:String){
        let alterController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alterController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alterController,animated: true,completion: nil)
    }
}
