//
//  AddGoalView.swift
//  GoalBreaker
//
//  Created by GoalBreaker on 2026-01-02.
//

import SwiftUI
import CoreData

struct AddGoalView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var goalTitle = ""
    @State private var deadline = Calendar.current.date(byAdding: .month, value: 3, to: Date()) ?? Date()
    @State private var isProcessing = false
    @State private var showPreview = false
    @State private var monthlyGoals: [String] = []
    @State private var weeklyGoals: [[String]] = []
    @State private var errorMessage: String?
    @State private var showError = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Goal Details") {
                    TextField("Goal Title", text: $goalTitle)
                    DatePicker("Deadline", selection: $deadline, in: Date()..., displayedComponents: .date)
                }
                
                if showPreview {
                    Section("Preview - Monthly Goals") {
                        ForEach(Array(monthlyGoals.enumerated()), id: \.offset) { index, monthly in
                            VStack(alignment: .leading) {
                                Text("Month \(index + 1)")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                Text(monthly)
                                    .font(.subheadline)
                            }
                        }
                    }
                    
                    Section("Preview - Weekly Tasks") {
                        ForEach(Array(weeklyGoals.enumerated()), id: \.offset) { monthIndex, weeks in
                            DisclosureGroup("Month \(monthIndex + 1) Weeks") {
                                ForEach(Array(weeks.enumerated()), id: \.offset) { weekIndex, task in
                                    Text("Week \(weekIndex + 1): \(task)")
                                        .font(.caption)
                                }
                            }
                        }
                    }
                }
                
                Section {
                    if isProcessing {
                        HStack {
                            Spacer()
                            ProgressView()
                                .padding()
                            Text("Breaking down your goal with AI...")
                            Spacer()
                        }
                    } else if showPreview {
                        Button("Save Goal") {
                            saveGoal()
                        }
                        .disabled(goalTitle.isEmpty)
                        
                        Button("Regenerate") {
                            Task {
                                await breakDownGoal()
                            }
                        }
                    } else {
                        Button("Break Down with AI") {
                            Task {
                                await breakDownGoal()
                            }
                        }
                        .disabled(goalTitle.isEmpty)
                    }
                }
            }
            .navigationTitle("New Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Error", isPresented: $showError, presenting: errorMessage) { _ in
                Button("OK", role: .cancel) {}
            } message: { message in
                Text(message)
            }
        }
    }
    
    private func breakDownGoal() async {
        isProcessing = true
        errorMessage = nil
        
        let result = await AIGoalBreaker.breakDownGoal(goal: goalTitle, deadline: deadline)
        
        await MainActor.run {
            monthlyGoals = result.monthly
            weeklyGoals = result.weekly
            showPreview = true
            isProcessing = false
            
            if monthlyGoals.isEmpty || weeklyGoals.isEmpty {
                errorMessage = "Failed to break down goal. Using fallback structure."
                showError = true
            }
        }
    }
    
    private func saveGoal() {
        let newGoal = Goal(context: viewContext)
        newGoal.id = UUID()
        newGoal.title = goalTitle
        newGoal.deadline = deadline
        newGoal.createdAt = Date()
        newGoal.monthlyGoalsArray = monthlyGoals
        newGoal.weeklyGoalsArray = weeklyGoals
        
        do {
            try viewContext.save()
            NotificationManager.shared.scheduleDailyReminders(for: newGoal)
            dismiss()
        } catch {
            errorMessage = "Failed to save goal: \(error.localizedDescription)"
            showError = true
        }
    }
}

#Preview {
    AddGoalView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
