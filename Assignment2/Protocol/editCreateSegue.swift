//
//  editCreateSegue.swift
//  Assignment2
//
//  Created by Yuting Yu on 11/4/21.
//

import Foundation



protocol addMealDelegate:AnyObject{
    func addMeal(name:String,instruction:String,ingredients:[String:String])->Bool
}
protocol editNameDelegate:AnyObject{
    func editName(name:String)->Bool
}

protocol editIngredientDelegate:AnyObject{
    func addIngredient(name:String,quantity:String)->Bool
}

protocol editInstructionDelegate:AnyObject{
    func editInstruction(instruction:String)->Bool
}

