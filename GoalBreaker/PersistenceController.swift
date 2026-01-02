//
//  PersistenceController.swift
//  GoalBreaker
//
//  Created by GoalBreaker on 2026-01-02.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // Create sample data for previews
        let goal = Goal(context: viewContext)
        goal.id = UUID()
        goal.title = "Learn Swift"
        goal.deadline = Calendar.current.date(byAdding: .month, value: 3, to: Date())
        goal.createdAt = Date()
        goal.monthlyGoalsArray = ["Master basics", "Build first app", "Advanced features"]
        goal.weeklyGoalsArray = [
            ["Variables", "Functions", "Classes", "Protocols"],
            ["SwiftUI basics", "Navigation", "Data flow", "UI components"],
            ["Core Data", "Networking", "Async/Await", "Final polish"]
        ]
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "GoalBreaker")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
