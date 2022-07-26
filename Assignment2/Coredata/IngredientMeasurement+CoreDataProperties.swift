//
//  IngredientMeasurement+CoreDataProperties.swift
//  Assignment2
//
//  Created by Yuting Yu on 12/4/21.
//
//

import Foundation
import CoreData


extension IngredientMeasurement {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<IngredientMeasurement> {
        return NSFetchRequest<IngredientMeasurement>(entityName: "IngredientMeasurement")
    }

    @NSManaged public var name: String?
    @NSManaged public var quantity: String?
    @NSManaged public var usedBy: Meal?

}

extension IngredientMeasurement : Identifiable {

}
