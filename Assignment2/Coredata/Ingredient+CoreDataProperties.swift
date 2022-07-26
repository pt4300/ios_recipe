//
//  Ingredient+CoreDataProperties.swift
//  Assignment2
//
//  Created by Yuting Yu on 12/4/21.
//
//

import Foundation
import CoreData


extension Ingredient {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ingredient> {
        return NSFetchRequest<Ingredient>(entityName: "Ingredient")
    }

    @NSManaged public var name: String?
    @NSManaged public var ingredientDescription: String?

}

extension Ingredient : Identifiable {

}
