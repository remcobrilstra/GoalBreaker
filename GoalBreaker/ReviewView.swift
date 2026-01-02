//
//  ReviewView.swift
//  GoalBreaker
//
//  Created by GoalBreaker on 2026-01-02.
//

import SwiftUI
import CoreData

struct ReviewView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Goal.createdAt, ascending: false)],
        animation: .default)
    private var goals: FetchedResults<Goal>
    
    @State private var userNotes = ""
    @State private var showingSaved = false
    
    var currentWeekStart: Date {
        Date().startOfWeek
    }
    
    var currentWeekGoals: String {
        var summary = "Week of \(currentWeekStart.formatted(date: .abbreviated, time: .omitted)):\n\n"
        
        for goal in goals {
            if let deadline = goal.deadline, deadline >= Date() {
                summary += "📌 \(goal.title ?? "Untitled")\n"
                
                let weeklyGoals = goal.weeklyGoalsArray
                let monthsSinceCreation = goal.createdAt?.monthDiff(from: Date()) ?? 0
                let weeksSinceCreation = Calendar.current.dateComponents([.weekOfYear], from: goal.createdAt ?? Date(), to: Date()).weekOfYear ?? 0
                
                if weeksSinceCreation < weeklyGoals.flatMap({ $0 }).count {
                    let monthIndex = min(weeksSinceCreation / 4, weeklyGoals.count - 1)
                    let weekIndex = weeksSinceCreation % 4
                    
                    if monthIndex < weeklyGoals.count && weekIndex < weeklyGoals[monthIndex].count {
                        summary += "  - \(weeklyGoals[monthIndex][weekIndex])\n"
                    }
                }
                summary += "\n"
            }
        }
        
        return summary
    }
    
    var body: some View {
        Form {
            Section("This Week's Goals") {
                Text(currentWeekGoals)
                    .font(.body)
                    .textSelection(.enabled)
            }
            
            Section("Your Notes") {
                TextEditor(text: $userNotes)
                    .frame(minHeight: 150)
            }
            
            Section {
                Button("Save Review") {
                    saveReview()
                }
                .disabled(userNotes.isEmpty)
            }
        }
        .navigationTitle("Weekly Review")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Review Saved", isPresented: $showingSaved) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Your weekly review has been saved successfully.")
        }
    }
    
    private func saveReview() {
        let newReview = Review(context: viewContext)
        newReview.id = UUID()
        newReview.weekStartDate = currentWeekStart
        newReview.goalsSummary = currentWeekGoals
        newReview.userNotes = userNotes
        
        do {
            try viewContext.save()
            userNotes = ""
            showingSaved = true
        } catch {
            print("Error saving review: \(error)")
        }
    }
}

#Preview {
    NavigationStack {
        ReviewView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
