//
//  HomeView.swift
//  GoalBreaker
//
//  Created by GoalBreaker on 2026-01-02.
//

import SwiftUI
import CoreData

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Goal.createdAt, ascending: false)],
        animation: .default)
    private var goals: FetchedResults<Goal>
    
    @State private var showingAddGoal = false
    
    var body: some View {
        List {
            ForEach(goals) { goal in
                NavigationLink(destination: GoalDetailView(goal: goal)) {
                    GoalRowView(goal: goal)
                }
            }
            .onDelete(perform: deleteGoals)
        }
        .navigationTitle("GoalBreaker")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingAddGoal = true }) {
                    Label("Add Goal", systemImage: "plus")
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                NavigationLink(destination: ReviewView()) {
                    Label("Weekly Review", systemImage: "calendar")
                }
            }
        }
        .sheet(isPresented: $showingAddGoal) {
            AddGoalView()
        }
        .overlay {
            if goals.isEmpty {
                ContentUnavailableView {
                    Label("No Goals", systemImage: "target")
                } description: {
                    Text("Add your first goal to get started!")
                }
            }
        }
    }
    
    private func deleteGoals(offsets: IndexSet) {
        withAnimation {
            offsets.map { goals[$0] }.forEach { goal in
                NotificationManager.shared.cancelNotifications(for: goal)
                viewContext.delete(goal)
            }
            
            do {
                try viewContext.save()
            } catch {
                print("Error deleting goal: \(error)")
            }
        }
    }
}

struct GoalRowView: View {
    let goal: Goal
    
    var progress: Double {
        let totalWeeks = goal.weeklyGoalsArray.flatMap { $0 }.count
        guard totalWeeks > 0 else { return 0 }
        
        // Calculate based on completed weeks (simplified)
        let completedWeeks = UserDefaults.standard.integer(forKey: "completed_\(goal.id?.uuidString ?? "")")
        return Double(completedWeeks) / Double(totalWeeks)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(goal.title ?? "Untitled Goal")
                    .font(.headline)
                    .foregroundColor(.blue)
                Spacer()
                Image(systemName: "calendar")
                    .foregroundColor(.gray)
            }
            
            if let deadline = goal.deadline {
                Text("Due: \(deadline.formatted(date: .abbreviated, time: .omitted))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            ProgressView(value: progress)
                .tint(.green)
            
            Text("\(Int(progress * 100))% Complete")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationStack {
        HomeView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
