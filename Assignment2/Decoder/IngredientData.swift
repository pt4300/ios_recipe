//
//  IngredientData.swift
//  Assignment2
//
//  Created by Yuting Yu on 14/4/21.
//

import UIKit
import Foundation


class IngredientData: NSObject,Codable {
    
    
    var ingredients:[ingredientDetail]
    
    // specify the subset properties when decoding
    private enum CodingKeys:String,CodingKey{
        case ingredients = "meals"
        
    }
    
    

    
}

struct ingredientDetail:Codable{
    var ingredientName : String?
    var ingredientDescription : String?
    
    private enum CodingKeys: String,CodingKey{
        case ingredientName = "strIngredient"
        case ingredientDescription = "strDescription"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        ingredientName = try? container.decode(String.self, forKey: .ingredientName)
        ingredientDescription = try? container.decode(String.self, forKey: .ingredientDescription)

    }



}



