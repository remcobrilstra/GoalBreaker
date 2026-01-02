//
//  GoalDetailView.swift
//  GoalBreaker
//
//  Created by GoalBreaker on 2026-01-02.
//

import SwiftUI

struct GoalDetailView: View {
    @ObservedObject var goal: Goal
    @State private var completedTasks: Set<String> = []
    
    var body: some View {
        List {
            Section("Goal Information") {
                VStack(alignment: .leading, spacing: 8) {
                    Text(goal.title ?? "Untitled Goal")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    if let deadline = goal.deadline {
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(.blue)
                            Text("Deadline: \(deadline.formatted(date: .long, time: .omitted))")
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    if let createdAt = goal.createdAt {
                        HStack {
                            Image(systemName: "clock")
                                .foregroundColor(.gray)
                            Text("Created: \(createdAt.formatted(date: .abbreviated, time: .omitted))")
                                .foregroundColor(.secondary)
                                .font(.caption)
                        }
                    }
                }
            }
            
            let monthlyGoals = goal.monthlyGoalsArray
            let weeklyGoals = goal.weeklyGoalsArray
            
            ForEach(Array(monthlyGoals.enumerated()), id: \.offset) { monthIndex, monthlyGoal in
                Section {
                    Text(monthlyGoal)
                        .font(.headline)
                        .foregroundColor(.blue)
                    
                    if monthIndex < weeklyGoals.count {
                        ForEach(Array(weeklyGoals[monthIndex].enumerated()), id: \.offset) { weekIndex, weeklyTask in
                            let taskID = "\(goal.id?.uuidString ?? "")-m\(monthIndex)-w\(weekIndex)"
                            
                            HStack {
                                Button(action: {
                                    toggleTask(taskID)
                                }) {
                                    Image(systemName: completedTasks.contains(taskID) ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(completedTasks.contains(taskID) ? .green : .gray)
                                }
                                
                                Text(weeklyTask)
                                    .strikethrough(completedTasks.contains(taskID))
                                    .foregroundColor(completedTasks.contains(taskID) ? .secondary : .primary)
                                
                                Spacer()
                            }
                        }
                    }
                } header: {
                    Text("Month \(monthIndex + 1)")
                }
            }
        }
        .navigationTitle("Goal Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadCompletedTasks()
        }
    }
    
    private func loadCompletedTasks() {
        if let goalID = goal.id?.uuidString,
           let data = UserDefaults.standard.data(forKey: "completed_tasks_\(goalID)"),
           let tasks = try? JSONDecoder().decode(Set<String>.self, from: data) {
            completedTasks = tasks
        }
    }
    
    private func toggleTask(_ taskID: String) {
        if completedTasks.contains(taskID) {
            completedTasks.remove(taskID)
        } else {
            completedTasks.insert(taskID)
        }
        saveCompletedTasks()
    }
    
    private func saveCompletedTasks() {
        if let goalID = goal.id?.uuidString,
           let data = try? JSONEncoder().encode(completedTasks) {
            UserDefaults.standard.set(data, forKey: "completed_tasks_\(goalID)")
            
            // Update completed count for progress calculation
            let completedCount = completedTasks.count
            UserDefaults.standard.set(completedCount, forKey: "completed_\(goalID)")
        }
    }
}

#Preview {
    NavigationStack {
        GoalDetailView(goal: {
            let context = PersistenceController.preview.container.viewContext
            let goal = Goal(context: context)
            goal.id = UUID()
            goal.title = "Learn Swift"
            goal.deadline = Calendar.current.date(byAdding: .month, value: 3, to: Date())
            goal.createdAt = Date()
            goal.monthlyGoalsArray = ["Master basics", "Build first app"]
            goal.weeklyGoalsArray = [
                ["Variables", "Functions", "Classes", "Protocols"],
                ["SwiftUI basics", "Navigation", "Data flow", "UI components"]
            ]
            return goal
        }())
    }
}
