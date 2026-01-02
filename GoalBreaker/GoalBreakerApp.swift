//
//  GoalBreakerApp.swift
//  GoalBreaker
//
//  Created by GoalBreaker on 2026-01-02.
//

import SwiftUI

@main
struct GoalBreakerApp: App {
    let persistenceController = PersistenceController.shared
    
    init() {
        // Request notification permissions on app launch
        NotificationManager.shared.requestAuthorization()
        // Schedule weekly review if not already scheduled
        NotificationManager.shared.scheduleWeeklyReview()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
