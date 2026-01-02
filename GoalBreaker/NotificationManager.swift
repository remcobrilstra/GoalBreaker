//
//  NotificationManager.swift
//  GoalBreaker
//
//  Created by GoalBreaker on 2026-01-02.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    /// Request authorization for notifications
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else if let error = error {
                print("Error requesting notification permission: \(error)")
            }
        }
    }
    
    /// Schedule daily reminders for a goal
    func scheduleDailyReminders(for goal: Goal) {
        guard let goalID = goal.id else { return }
        
        let weeklyGoals = goal.weeklyGoalsArray
        let calendar = Calendar.current
        var currentDate = Date()
        
        // Schedule reminders for all weeks
        for (monthIndex, monthWeeks) in weeklyGoals.enumerated() {
            for (weekIndex, weekTask) in monthWeeks.enumerated() {
                // Calculate the week number for this task
                let weekNumber = monthIndex * 4 + weekIndex
                
                // Schedule for the start of each week (Monday at 8 AM)
                if let targetDate = calendar.date(byAdding: .weekOfYear, value: weekNumber, to: currentDate) {
                    var dateComponents = calendar.dateComponents([.weekday, .hour], from: targetDate)
                    dateComponents.weekday = 2 // Monday
                    dateComponents.hour = 8
                    dateComponents.minute = 0
                    
                    let content = UNMutableNotificationContent()
                    content.title = "Daily Goal Reminder"
                    content.body = weekTask
                    content.sound = .default
                    
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                    let identifier = "\(goalID.uuidString)-month\(monthIndex)-week\(weekIndex)"
                    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                    
                    UNUserNotificationCenter.current().add(request) { error in
                        if let error = error {
                            print("Error scheduling notification: \(error)")
                        }
                    }
                }
            }
        }
    }
    
    /// Schedule weekly review notification
    func scheduleWeeklyReview() {
        // Remove existing weekly review notifications
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["weekly-review"])
        
        var dateComponents = DateComponents()
        dateComponents.weekday = 1 // Sunday
        dateComponents.hour = 19 // 7 PM
        dateComponents.minute = 0
        
        let content = UNMutableNotificationContent()
        content.title = "Weekly Review Time"
        content.body = "Review your week's progress"
        content.sound = .default
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "weekly-review", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling weekly review: \(error)")
            } else {
                print("Weekly review scheduled successfully")
            }
        }
    }
    
    /// Cancel all notifications for a goal
    func cancelNotifications(for goal: Goal) {
        guard let goalID = goal.id else { return }
        
        let weeklyGoals = goal.weeklyGoalsArray
        var identifiers: [String] = []
        
        for (monthIndex, monthWeeks) in weeklyGoals.enumerated() {
            for (weekIndex, _) in monthWeeks.enumerated() {
                let identifier = "\(goalID.uuidString)-month\(monthIndex)-week\(weekIndex)"
                identifiers.append(identifier)
            }
        }
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }
}
