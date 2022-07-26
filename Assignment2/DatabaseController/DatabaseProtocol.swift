//
//  DatabaseProtocol.swift
//  Assignment2
//
//  Created by Yuting Yu on 12/4/21.
//

import Foundation
import CoreData

enum DatabaseChange {
    case add
    case remove
    case update
    
}

enum ListenerType{
    case myMeal
    case ingredientMeasure
    case ingredient
    case all
}
protocol DatabaseListener:AnyObject {
    var listenerType:ListenerType{get set}
    func onMealChange(change:DatabaseChange,mealList:[Meal])
    func onIngredientMeasurementChange(change:DatabaseChange,ingredients:[IngredientMeasurement])
    func onIngredientChange(change:DatabaseChange,ingredients:[Ingredient])
    
    
}
protocol DatabaseProtocol:AnyObject{
    func cleanup()
    func addMeal(name:String,instruction:String,ingredients:[String:String]) -> Meal
    func removeMeal(meal:Meal)
    func addIngredientMeasurement(meal:Meal,name:String,quantity:String,viewContext:NSManagedObjectContext)
    func removeIngredientMeasurement(meal:Meal,ingredient:IngredientMeasurement,viewContext:NSManagedObjectContext)
    func editInstruction(meal:Meal,instruction:String)
    func editName(meal:Meal,name:String)
    func addListener(listener:DatabaseListener)
    func removeListener(listener:DatabaseListener)
    func createChildContext(meal:Meal?)->(NSManagedObjectContext,Meal)
    func saveDraft(managedContext:NSManagedObjectContext)->Bool
    func discardDraft(managedContext:NSManagedObjectContext)
}
