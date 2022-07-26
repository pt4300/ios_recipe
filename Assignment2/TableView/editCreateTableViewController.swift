//
//  editCreateTableViewController.swift
//  Assignment2
//
//  Created by Yuting Yu on 11/4/21.
//

import UIKit
import CoreData

class editCreateTableViewController: UITableViewController {

    var SECTION_NAME = 0
    var SECTION_INSTRUCTION = 1
    var SECTION_INGREDIENT = 2
    var SECTION_ADDED = 3
    var CELL_NAME = "nameCell"
    var CELL_INSTRUCTION = "instructionCell"
    var CELL_INGREDIENT = "ingredientsCell"
    var CELL_ADDED = "addCell"
    var meal: Meal?
    var managedContext: NSManagedObjectContext?

    
    var listenerType:ListenerType = .ingredientMeasure
    weak var databaseController:DatabaseProtocol?

    

    
    weak var addMealDelegate:addMealDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        if let editMeal = meal{
            if let (managedContext, meal) = databaseController?.createChildContext(meal: editMeal){
                navigationItem.title = editMeal.name
                // replaced the meal with childManagedContext meal
                self.meal = meal
                self.managedContext = managedContext

            }
            
        }
        else{
            navigationItem.title = "Create New Meal"
            // create context function will generate default meal
            if let(managedContext,newMeal) = databaseController?.createChildContext(meal: nil){
                self.managedContext = managedContext
                self.meal = newMeal
            }
            
            
            
            // This prevent crash for adding ingredient into new meal
           // meal = Meal(name: "", instruction: "", ingredients: [])
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    @IBAction func saveAction(_ sender: Any) {
        //validate if meal exist
        if let name = meal?.name , name != ""{
            if let managedContext = self.managedContext{
                databaseController?.saveDraft(managedContext: managedContext)
            }
            navigationController?.popToRootViewController(animated: false)
            
        }else{
            displayMessage(title: "Warning", message: "Please create valid meal")
            // prevent creating empty duplicates meal in persistent store
            if let managedObjextContext = self.managedContext{
                databaseController?.discardDraft(managedContext: managedObjextContext)

            }
        }

    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case SECTION_NAME:
            return 1
            
        case SECTION_INSTRUCTION:
            return 1
        case SECTION_INGREDIENT:
            if let ingredients = meal?.ingredients{
                return ingredients.count
            }
            return 0
            
        case SECTION_ADDED:
            return 1
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case SECTION_NAME:
            return "MEAL NAME"
            
        case SECTION_INGREDIENT:
            return "INGREDIENTS"
            
        case SECTION_INSTRUCTION:
            return "INSTRUCTIONS"
            
        default:
            return ""
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == SECTION_NAME{
           let nameCell = tableView.dequeueReusableCell(withIdentifier: CELL_NAME, for: indexPath)
            if let mealName = meal?.name,mealName != ""{
                nameCell.textLabel?.text = mealName
            }
            else{
                nameCell.textLabel?.text = "Tap to enter meal name"
            }
            return nameCell
            
        }
        else if indexPath.section == SECTION_INSTRUCTION{
            let instructionCell = tableView.dequeueReusableCell(withIdentifier: CELL_INSTRUCTION, for: indexPath)
            if let mealInstruction = meal?.instruction, mealInstruction != ""{
                instructionCell.textLabel?.text = mealInstruction
            }
            else{
                instructionCell.textLabel?.text = "Tap to enter meal instruction"
            }
            return instructionCell
        }
        else if indexPath.section == SECTION_INGREDIENT{
            // doesnt need unwrap ingredients since the number of row in section will handle this if there is  no item in ingredients list
            
            let ingredientCell = tableView.dequeueReusableCell(withIdentifier: CELL_INGREDIENT, for: indexPath)
            
            if let ingredients = meal?.ingredients?.allObjects as? [IngredientMeasurement] {
                let ingredient = ingredients[indexPath.row]
                ingredientCell.textLabel?.text = ingredient.name
                ingredientCell.detailTextLabel?.text = ingredient.quantity

            }
            


             return ingredientCell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ADDED, for: indexPath)
        cell.textLabel?.text = "Add Ingredient"

        // Configure the cell...

        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == SECTION_INGREDIENT{
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        if indexPath.section == SECTION_INGREDIENT{
            return true
        }
        return false
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && indexPath.section == SECTION_INGREDIENT {
            
            tableView.performBatchUpdates({
                if let meal = self.meal{
                    if let ingredients = meal.ingredients?.allObjects as? [IngredientMeasurement]{
                        
                        databaseController?.removeIngredientMeasurement(meal: meal, ingredient: ingredients[indexPath.row],viewContext: self.managedContext!)

                    }

                }
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                self.tableView.reloadSections([SECTION_INGREDIENT], with: .fade)
            }, completion: nil)
            // Delete the row from the data source
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
        if segue.identifier == "editInstruction"{
            let destination = segue.destination as! editInstructionsViewController
            destination.editInstrucitonDelegate = self
            destination.meal = self.meal
        }
        else if segue.identifier == "editIngredientSegue"{
            let destination = segue.destination as! editIngredientTableViewController
            destination.editeIngredientDelegate = self
        }
        else if segue.identifier ==  "editNameSegue"{
            let destination = segue.destination as! editNameViewController
            destination.editeNameDelegate = self
            destination.meal = self.meal
        }
    }
    
    
    
    

}

extension editCreateTableViewController:editIngredientDelegate,editNameDelegate,editInstructionDelegate{
    func editInstruction(instruction: String) -> Bool {
        // prevent creating empty meal in coredata

        if let meal = self.meal, instruction != ""{
            databaseController?.editInstruction(meal: meal, instruction: instruction)
            return true
        }
        else{
            return false
        }
    }
    
    func editName(name: String) -> Bool {
        
        // prevent creating empty meal in coredata
        if let meal = meal, name != ""{
            databaseController?.editName(meal: meal, name: name)
            return true
        }else{
            return false
        }
    }
    
    func addIngredient(name:String,quantity:String) -> Bool {
       
        if let editedMeal = meal{
            tableView.performBatchUpdates({
                if let meal = self.meal,let managedContext = self.managedContext{
                    self.databaseController?.addIngredientMeasurement(meal: meal, name: name, quantity: quantity,viewContext: managedContext)

                }
                tableView.reloadSections([SECTION_INGREDIENT], with: .automatic)
            }, completion: nil)
        }

        return true
    }
    
    
    
    func displayMessage(title:String,message:String){
        let alterController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alterController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alterController,animated: true,completion: nil)
    }
    
    
}


extension editCreateTableViewController:DatabaseListener{
    func onIngredientChange(change: DatabaseChange, ingredients: [Ingredient]) {
        //
    }
    
    func onIngredientMeasurementChange(change: DatabaseChange, ingredients: [IngredientMeasurement]) {
        // doesnt need replace ingredients since it handle through coredata, only require to refresh table
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
    func onMealChange(change: DatabaseChange, mealList: [Meal]) {
        // do nothing
    }
    

    
    
}
