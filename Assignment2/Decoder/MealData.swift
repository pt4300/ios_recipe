//
//  MealData.swift
//  Assignment2
//
//  Created by Yuting Yu on 14/4/21.
//

import UIKit

class MealData: NSObject,Codable {
    var meals:[mealEntity]


}

struct mealEntity:Codable{
    var name:String?
    var instruction:String?
    var ingredients:[String:String] = [:]
    var strIngredient1:String?
    var strIngredient2:String?
    var strIngredient3:String?
    var strIngredient4:String?
    var strIngredient5:String?
    var strIngredient6:String?
    var strIngredient7:String?
    var strIngredient8:String?
    var strIngredient9:String?
    var strIngredient10:String?
    var strIngredient11:String?
    var strIngredient12:String?
    var strIngredient13:String?
    var strIngredient14:String?
    var strIngredient15:String?
    var strIngredient16:String?
    var strIngredient17:String?
    var strIngredient18:String?
    var strIngredient19:String?
    var strIngredient20:String?
    var strMeasure1:String?
    var strMeasure2:String?
    var strMeasure3:String?
    var strMeasure4:String?
    var strMeasure5:String?
    var strMeasure6:String?
    var strMeasure7:String?
    var strMeasure8:String?
    var strMeasure9:String?
    var strMeasure10:String?
    var strMeasure11:String?
    var strMeasure12:String?
    var strMeasure13:String?
    var strMeasure14:String?
    var strMeasure15:String?
    var strMeasure16:String?
    var strMeasure17:String?
    var strMeasure18:String?
    var strMeasure19:String?
    var strMeasure20:String?
    
    private enum CodingKeys:String,CodingKey{
        case name = "strMeal"
        case instruction = "strInstructions"
        case strIngredient1
        case strIngredient2
        case strIngredient3
        case strIngredient4
        case strIngredient5
        case strIngredient6
        case strIngredient7
        case strIngredient8
        case strIngredient9
        case strIngredient10
        case strIngredient11
        case strIngredient12
        case strIngredient13
        case strIngredient14
        case strIngredient15
        case strIngredient16
        case strIngredient17
        case strIngredient18
        case strIngredient19
        case strIngredient20
        case strMeasure1
        case strMeasure2
        case strMeasure3
        case strMeasure4
        case strMeasure5
        case strMeasure6
        case strMeasure7
        case strMeasure8
        case strMeasure9
        case strMeasure10
        case strMeasure11
        case strMeasure12
        case strMeasure13
        case strMeasure14
        case strMeasure15
        case strMeasure16
        case strMeasure17
        case strMeasure18
        case strMeasure19
        case strMeasure20
        
        
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try? container.decode(String.self, forKey: .name)
        self.instruction = try? container.decode(String.self, forKey: .instruction)
        if let ingredent1 = try? container.decode(String.self, forKey: .strIngredient1), let measurement1 = try? container.decode(String.self, forKey: .strMeasure1){
            self.ingredients[ingredent1] = measurement1

        }
        if let ingredent2 = try? container.decode(String.self, forKey: .strIngredient2), let measurement2 = try? container.decode(String.self, forKey: .strMeasure2){
            self.ingredients[ingredent2] = measurement2

        }
        if let ingredent3 = try? container.decode(String.self, forKey: .strIngredient3), let measurement3 = try? container.decode(String.self, forKey: .strMeasure3){
            self.ingredients[ingredent3] = measurement3

        }
        if let ingredent4 = try? container.decode(String.self, forKey: .strIngredient4), let measurement4 = try? container.decode(String.self, forKey: .strMeasure4){
            self.ingredients[ingredent4] = measurement4

        }
        if let ingredent5 = try? container.decode(String.self, forKey: .strIngredient5), let measurement5 = try? container.decode(String.self, forKey: .strMeasure5){
            self.ingredients[ingredent5] = measurement5

        }
        if let ingredent6 = try? container.decode(String.self, forKey: .strIngredient6), let measurement6 = try? container.decode(String.self, forKey: .strMeasure6){
            self.ingredients[ingredent6] = measurement6

        }
        if let ingredent7 = try? container.decode(String.self, forKey: .strIngredient7), let measurement7 = try? container.decode(String.self, forKey: .strMeasure7){
            self.ingredients[ingredent7] = measurement7

        }
        if let ingredent8 = try? container.decode(String.self, forKey: .strIngredient8), let measurement8 = try? container.decode(String.self, forKey: .strMeasure8){
            self.ingredients[ingredent8] = measurement8

        }
        if let ingredent9 = try? container.decode(String.self, forKey: .strIngredient9), let measurement9 = try? container.decode(String.self, forKey: .strMeasure9){
            self.ingredients[ingredent9] = measurement9

        }
        if let ingredent10 = try? container.decode(String.self, forKey: .strIngredient10), let measurement10 = try? container.decode(String.self, forKey: .strMeasure10){
            self.ingredients[ingredent10] = measurement10

        }
        if let ingredent11 = try? container.decode(String.self, forKey: .strIngredient11), let measurement11 = try? container.decode(String.self, forKey: .strMeasure11){
            self.ingredients[ingredent11] = measurement11

        }
        if let ingredent12 = try? container.decode(String.self, forKey: .strIngredient12), let measurement12 = try? container.decode(String.self, forKey: .strMeasure12){
            self.ingredients[ingredent12] = measurement12

        }
        if let ingredent13 = try? container.decode(String.self, forKey: .strIngredient13), let measurement13 = try? container.decode(String.self, forKey: .strMeasure13){
            self.ingredients[ingredent13] = measurement13

        }
        if let ingredent14 = try? container.decode(String.self, forKey: .strIngredient14), let measurement14 = try? container.decode(String.self, forKey: .strMeasure14){
            self.ingredients[ingredent14] = measurement14

        }
        if let ingredent15 = try? container.decode(String.self, forKey: .strIngredient15), let measurement15 = try? container.decode(String.self, forKey: .strMeasure15){
            self.ingredients[ingredent15] = measurement15

        }
        if let ingredent16 = try? container.decode(String.self, forKey: .strIngredient16), let measurement16 = try? container.decode(String.self, forKey: .strMeasure16){
            self.ingredients[ingredent16] = measurement16

        }
        if let ingredent17 = try? container.decode(String.self, forKey: .strIngredient17), let measurement17 = try? container.decode(String.self, forKey: .strMeasure17){
            self.ingredients[ingredent17] = measurement17

        }
        if let ingredent18 = try? container.decode(String.self, forKey: .strIngredient18), let measurement18 = try? container.decode(String.self, forKey: .strMeasure18){
            self.ingredients[ingredent18] = measurement18

        }
        if let ingredent19 = try? container.decode(String.self, forKey: .strIngredient19), let measurement19 = try? container.decode(String.self, forKey: .strMeasure19){
            self.ingredients[ingredent19] = measurement19

        }
        if let ingredent20 = try? container.decode(String.self, forKey: .strIngredient20), let measurement20 = try? container.decode(String.self, forKey: .strMeasure20){
            self.ingredients[ingredent20] = measurement20

        }
    }
}
