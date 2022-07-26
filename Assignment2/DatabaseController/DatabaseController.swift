//
//  DatabaseController.swift
//  Assignment2
//
//  Created by Yuting Yu on 12/4/21.
//

import UIKit
import CoreData
class DatabaseController: NSObject {
    
    
    
    
    var listeners = MulticastDelegate<DatabaseListener>()
    private var persistentContainer:NSPersistentContainer
    
    // fetch result controller
    private var myMealFetchResultController:NSFetchedResultsController<Meal>?
    private var ingredientMeasurementFetchResultController:NSFetchedResultsController<IngredientMeasurement>?
    private var ingredientFetchResultController:NSFetchedResultsController<Ingredient>?
    
    override init() {
        persistentContainer = NSPersistentContainer(name: "MealModel")
        persistentContainer.loadPersistentStores { (info, error) in
            if let error = error{
                
                print(error)
            }
        }

        super.init()
        
        
        // fetch all ingredients from api if there is no ingredients in api
        if (fetchAllIngredients().count != 0) {
            fetchIngredientFromApi()

        }
        
        


    }
    
    
    // helper function to clean database, for debugging only
    
    
    func deleteAll(){
        var temp = fetchMyMeal()
        var temp2 = fetchAllIngredientMeasurement()
        var temp3 = fetchAllIngredients()
        for item in temp{
            persistentContainer.viewContext.delete(item)
        }
        for item2 in temp2{
            persistentContainer.viewContext.delete(item2)

        }
        for item3 in temp3{
            persistentContainer.viewContext.delete(item3)
        }
        cleanup()
        
    }

    
    func fetchMyMeal()->[Meal] {
        
        var meals:[Meal] = []
        
        if myMealFetchResultController == nil{
            let fetchRequest:NSFetchRequest = Meal.fetchRequest()
            let nameDescriptor:NSSortDescriptor = NSSortDescriptor(key:"name",ascending: true)
            fetchRequest.sortDescriptors = [nameDescriptor]
            
            myMealFetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            myMealFetchResultController?.delegate = self
            do{
                try myMealFetchResultController?.performFetch()
                // synchronise the coredata upon launch

                meals = myMealFetchResultController?.fetchedObjects ?? []

            }catch{
                fatalError("failed to fetch myMeal from coredata \(error)")
            }
        }
            
    
        else if myMealFetchResultController != nil {
            meals = myMealFetchResultController?.fetchedObjects ?? []
        }
        return meals
        
       
    }
    func fetchAllIngredientMeasurement()->[IngredientMeasurement]{
        var ingredients:[IngredientMeasurement] = []
        if ingredientMeasurementFetchResultController == nil{
            let fetchRequest:NSFetchRequest = IngredientMeasurement.fetchRequest()
            let nameDescriptor:NSSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [nameDescriptor]
            
            ingredientMeasurementFetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            ingredientMeasurementFetchResultController?.delegate = self
            do{
                try ingredientMeasurementFetchResultController?.performFetch()
                // synchronise the coredata upon launch
                ingredients = ingredientMeasurementFetchResultController?.fetchedObjects ?? []
            }catch{
                fatalError("failed to fetch ingredient measurement from coredata\(error)")
            }
        }
        else if myMealFetchResultController != nil{
            ingredients = ingredientMeasurementFetchResultController?.fetchedObjects ?? []
            
        }
        
        return ingredients
        
    }
    func  fetchAllIngredients()->[Ingredient]{
        var ingredients:[Ingredient] = []
        if ingredientFetchResultController == nil{
            let fetchRequest:NSFetchRequest = Ingredient.fetchRequest()
            let nameDescriptor:NSSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [nameDescriptor]
            ingredientFetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            ingredientFetchResultController?.delegate = self
            do{
                try ingredientFetchResultController?.performFetch()
                ingredients = ingredientFetchResultController?.fetchedObjects ?? []
            }catch{
                fatalError("failed to fetch ingredients from coredata\(error)")
            }
            
            
        }
        else {
            ingredients = ingredientFetchResultController?.fetchedObjects ?? []

        }
        return ingredients
    }
}

extension DatabaseController:DatabaseProtocol,NSFetchedResultsControllerDelegate{
    
    
    
    
    
    func addMeal(name: String, instruction: String, ingredients: [String:String]) -> Meal {
        // adding meal to persistent store and return the object
        let newMeal = NSEntityDescription.insertNewObject(forEntityName: "Meal", into: persistentContainer.viewContext) as! Meal
        newMeal.name = name
        newMeal.instruction = instruction
        for item in ingredients{
            addIngredientMeasurement(meal: newMeal, name: item.key, quantity: item.value,viewContext: persistentContainer.viewContext)
        }
        
        return newMeal
    }
    
    func addIngredientMeasurement(meal:Meal,name: String, quantity: String,viewContext:NSManagedObjectContext) {
        // require specify view context to ensure ingredient push to right contexts
        let ingredientMeasurement = NSEntityDescription.insertNewObject(forEntityName: "IngredientMeasurement", into: viewContext) as! IngredientMeasurement
        ingredientMeasurement.name = name
        ingredientMeasurement.quantity = quantity
        meal.addToIngredients(ingredientMeasurement)
        
    }
    

    
    func cleanup() {
        print("save persistent store success")

        if persistentContainer.viewContext.hasChanges{
            do{
                try persistentContainer.viewContext.save()
            }catch{
                fatalError("Commit to Coredata failed\(error)")
            }
            
        }
    }
    

    
    func removeMeal(meal: Meal) {
        persistentContainer.viewContext.delete(meal)
    }
    

    
    func removeIngredientMeasurement(meal: Meal, ingredient: IngredientMeasurement,viewContext:NSManagedObjectContext){
        var tempMeal = viewContext.object(with: meal.objectID) as! Meal

        tempMeal.removeFromIngredients(ingredient)
        
    }
    
    func editInstruction(meal: Meal, instruction: String) {
        meal.instruction = instruction
    }
    
    func editName(meal: Meal, name: String) {
        meal.name = name
    }
    
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        if listener.listenerType == .myMeal{
            listener.onMealChange(change: .update, mealList: fetchMyMeal())
        }
        else if listener.listenerType == .ingredientMeasure{
            listener.onIngredientMeasurementChange(change:.update,ingredients: fetchAllIngredientMeasurement())
        }
        else if listener.listenerType == .ingredient{
            listener.onIngredientChange(change: .update, ingredients: fetchAllIngredients())
        }
    }
    
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
    
    func createChildContext(meal:Meal?)->(NSManagedObjectContext,Meal) {
        // create child context every time user try to edit or create new meal.
        var childManagedContext:NSManagedObjectContext = NSManagedObjectContext.init(concurrencyType: .mainQueueConcurrencyType)
        
        childManagedContext.parent = self.persistentContainer.viewContext

        if let passedMeal = meal{
            // insert the meal into child managed conext
            let returned = childManagedContext.object(with: passedMeal.objectID) as! Meal
            
            
            return (childManagedContext,returned)
        }
        else{
            let newMeal = NSEntityDescription.insertNewObject(forEntityName: "Meal", into: childManagedContext) as! Meal
            newMeal.name = ""
            newMeal.instruction = ""

            return(childManagedContext,newMeal)
        }
    }
    
    func saveDraft(managedContext:NSManagedObjectContext)->Bool {
        if managedContext.hasChanges{
            print("save success")
            // save to child managed context then push to persisten store return true
            do{
                try managedContext.save()
            }catch{
                fatalError("failed to save child context \(error)")
            }
            return true
        }
        else{
            return false
        }
    }
    
    func discardDraft(managedContext:NSManagedObjectContext) {
        // actually not used in assignment as not pushing save to persistent store do the same thing
        managedContext.rollback()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if controller == myMealFetchResultController{
            listeners.invoke { (listener) in
                if listener.listenerType == .myMeal || listener.listenerType == .all{
                    listener.onMealChange(change: .update, mealList: fetchMyMeal())
                }
            }
        }
        else if controller == ingredientMeasurementFetchResultController{
            listeners.invoke { (listener) in
                if listener.listenerType == .ingredientMeasure || listener.listenerType == .all{
                    listener.onIngredientMeasurementChange(change:.update,ingredients: fetchAllIngredientMeasurement())
                }
            }
        }
        else if controller == ingredientFetchResultController{
            listeners.invoke { (listener) in
                if listener.listenerType == .ingredient || listener.listenerType == .all{
                    listener.onIngredientChange(change: .update, ingredients: fetchAllIngredients())
                }
            }
        }
    }
}


extension DatabaseController:URLSessionDelegate{
    func fetchIngredientFromApi(){
        // get all ingredients name in coredata
        let currentIngredient = fetchAllIngredients().map{$0.name}
        guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/list.php?i=list")else{
            print("failed to load ingredient")
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error{
                print(error)
            }
            else if let data = data{
                do{
                    let decoder = JSONDecoder()
                    let ingredientData = try decoder.decode(IngredientData.self, from: data)
                    // child context used to here to ensure data consistency. data will be push together.
                    var childContext:NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
                    childContext.parent = self.persistentContainer.viewContext
                    
                    // adding ingredient into persistent store
                    let ingredientList = ingredientData.ingredients
                    // save ingredients on childContext first then push to persistent store

                    for i in ingredientList{
                        // prevent duplicate ingredient in coredata
                        
                        if !currentIngredient.contains(i.ingredientName){
                            let ingredient = NSEntityDescription.insertNewObject(forEntityName: "Ingredient", into: childContext) as! Ingredient
                            
                            ingredient.name = i.ingredientName
                            ingredient.ingredientDescription = i.ingredientDescription
                        }
                    }
                    
                    // save to draft once the for loop finsh, if it failed only child context will be affected
                    self.saveDraft(managedContext: childContext)

                    
                }catch{
                    print(error)
                    print("failed to fetch ingredient list from api ")
                }
            }
        }
        task.resume()

    }
}
