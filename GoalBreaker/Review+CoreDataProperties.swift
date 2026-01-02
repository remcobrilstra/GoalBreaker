//
//  Review+CoreDataProperties.swift
//  GoalBreaker
//
//  Created by GoalBreaker on 2026-01-02.
//

import Foundation
import CoreData

extension Review {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Review> {
        return NSFetchRequest<Review>(entityName: "Review")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var weekStartDate: Date?
    @NSManaged public var goalsSummary: String?
    @NSManaged public var userNotes: String?
}

extension Review : Identifiable {

}
