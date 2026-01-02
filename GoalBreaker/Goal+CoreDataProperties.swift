//
//  Goal+CoreDataProperties.swift
//  GoalBreaker
//
//  Created by GoalBreaker on 2026-01-02.
//

import Foundation
import CoreData

extension Goal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Goal> {
        return NSFetchRequest<Goal>(entityName: "Goal")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var deadline: Date?
    @NSManaged public var monthlyGoals: String?
    @NSManaged public var weeklyGoals: String?
    @NSManaged public var createdAt: Date?
    
    // Helper properties to work with JSON
    var monthlyGoalsArray: [String] {
        get {
            guard let data = monthlyGoals?.data(using: .utf8),
                  let array = try? JSONDecoder().decode([String].self, from: data) else {
                return []
            }
            return array
        }
        set {
            if let data = try? JSONEncoder().encode(newValue),
               let string = String(data: data, encoding: .utf8) {
                monthlyGoals = string
            }
        }
    }
    
    var weeklyGoalsArray: [[String]] {
        get {
            guard let data = weeklyGoals?.data(using: .utf8),
                  let array = try? JSONDecoder().decode([[String]].self, from: data) else {
                return []
            }
            return array
        }
        set {
            if let data = try? JSONEncoder().encode(newValue),
               let string = String(data: data, encoding: .utf8) {
                weeklyGoals = string
            }
        }
    }
}

extension Goal : Identifiable {

}
