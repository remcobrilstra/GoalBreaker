# GoalBreaker - Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                        GoalBreakerApp.swift                      │
│                         (@main entry point)                      │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │ • Initialize PersistenceController                         │ │
│  │ • Request notification permissions                         │ │
│  │ • Schedule weekly review notifications                     │ │
│  │ • Inject Core Data context into environment                │ │
│  └────────────────────────────────────────────────────────────┘ │
└──────────────────────────┬──────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────────┐
│                       ContentView.swift                          │
│                    (NavigationStack Root)                        │
└──────────────────────────┬──────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────────┐
│                        HomeView.swift                            │
│                    (Main Goal List Screen)                       │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │ @FetchRequest: Fetch all goals from Core Data             │ │
│  │                                                             │ │
│  │ Display:                                                    │ │
│  │  • List of goals with progress bars                        │ │
│  │  • Title, deadline, completion percentage                  │ │
│  │  • Empty state if no goals                                 │ │
│  │                                                             │ │
│  │ Actions:                                                    │ │
│  │  • [+] Button → Opens AddGoalView                          │ │
│  │  • [📅] Button → Opens ReviewView                          │ │
│  │  • Tap Goal → Navigate to GoalDetailView                   │ │
│  │  • Swipe to Delete → Remove goal                           │ │
│  └────────────────────────────────────────────────────────────┘ │
└─────┬────────────────────────┬────────────────────────┬─────────┘
      │                        │                        │
      ▼                        ▼                        ▼
┌─────────────┐    ┌──────────────────┐    ┌──────────────────┐
│ AddGoalView │    │ GoalDetailView   │    │   ReviewView     │
└─────────────┘    └──────────────────┘    └──────────────────┘


┌─────────────────────────────────────────────────────────────────┐
│                       AddGoalView.swift                          │
│                  (Create New Goal with AI)                       │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │ Input:                                                      │ │
│  │  • TextField: Goal title                                   │ │
│  │  • DatePicker: Deadline                                    │ │
│  │                                                             │ │
│  │ Process:                                                    │ │
│  │  1. User enters goal and deadline                          │ │
│  │  2. Taps "Break Down with AI"                              │ │
│  │  3. Calls AIGoalBreaker.breakDownGoal() ─────┐             │ │
│  │  4. Shows loading state                      │             │ │
│  │  5. Displays preview of AI suggestions       │             │ │
│  │  6. User can Save or Regenerate              │             │ │
│  │                                               │             │ │
│  │ Output:                                       │             │ │
│  │  • Saves Goal to Core Data                   │             │ │
│  │  • Schedules notifications ────────────┐     │             │ │
│  │  • Returns to HomeView                 │     │             │ │
│  └──────────────────────────────────────┼─┼─────┘             │ │
└───────────────────────────────────────┼─┼───────────────────────┘
                                        │ │
                                        │ └──────────────┐
                                        │                │
                                        ▼                ▼
                        ┌──────────────────────────────────────┐
                        │    AIGoalBreaker.swift               │
                        │    (OpenAI Integration)              │
                        │  ┌────────────────────────────────┐  │
                        │  │ async breakDownGoal()          │  │
                        │  │  1. Calculate months           │  │
                        │  │  2. Build OpenAI prompt        │  │
                        │  │  3. POST to OpenAI API         │  │
                        │  │  4. Parse JSON response        │  │
                        │  │  5. Return (monthly, weekly)   │  │
                        │  │  6. Fallback on error          │  │
                        │  └────────────────────────────────┘  │
                        │                                      │
                        │  Uses: Constants.openAIAPIKey        │
                        │  URL: api.openai.com/v1/chat/...    │
                        │  Model: gpt-3.5-turbo                │
                        └──────────────────────────────────────┘
                                        ▲
                                        │
                        ┌───────────────────────────────────────┐
                        │     Constants.swift                   │
                        │  ┌─────────────────────────────────┐  │
                        │  │ static let openAIAPIKey =       │  │
                        │  │   "your-api-key-here"           │  │
                        │  └─────────────────────────────────┘  │
                        └───────────────────────────────────────┘


┌─────────────────────────────────────────────────────────────────┐
│                    GoalDetailView.swift                          │
│                 (View & Track Goal Progress)                     │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │ @ObservedObject goal: Goal                                 │ │
│  │                                                             │ │
│  │ Display:                                                    │ │
│  │  • Goal title, deadline, created date                      │ │
│  │  • Sections for each month                                 │ │
│  │  • Weekly tasks in each section                            │ │
│  │  • Checkboxes for each task                                │ │
│  │                                                             │ │
│  │ Actions:                                                    │ │
│  │  • Tap checkbox → Toggle completion                        │ │
│  │  • Save state to UserDefaults                              │ │
│  │  • Update progress bar                                     │ │
│  │  • Visual feedback (strikethrough, green checkmark)        │ │
│  └────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘


┌─────────────────────────────────────────────────────────────────┐
│                      ReviewView.swift                            │
│                  (Weekly Review Interface)                       │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │ @FetchRequest: Fetch all active goals                      │ │
│  │                                                             │ │
│  │ Process:                                                    │ │
│  │  1. Get current week start date (Monday)                   │ │
│  │  2. Filter goals with upcoming deadlines                   │ │
│  │  3. Calculate current week's tasks                         │ │
│  │  4. Auto-populate summary                                  │ │
│  │                                                             │ │
│  │ Display:                                                    │ │
│  │  • Current week's goals (auto-populated)                   │ │
│  │  • TextEditor for user notes                               │ │
│  │                                                             │ │
│  │ Actions:                                                    │ │
│  │  • Save Review entity to Core Data                         │ │
│  │  • Clear notes after save                                  │ │
│  │  • Show success alert                                      │ │
│  └────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘


┌─────────────────────────────────────────────────────────────────┐
│                   NotificationManager.swift                      │
│                  (Notification Scheduling)                       │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │ Singleton: NotificationManager.shared                      │ │
│  │                                                             │ │
│  │ Functions:                                                  │ │
│  │  • requestAuthorization()                                  │ │
│  │    - Ask user for notification permission                  │ │
│  │                                                             │ │
│  │  • scheduleDailyReminders(for: Goal)                       │ │
│  │    - For each week's task                                  │ │
│  │    - Schedule at Monday 8:00 AM                            │ │
│  │    - Content: task description                             │ │
│  │                                                             │ │
│  │  • scheduleWeeklyReview()                                  │ │
│  │    - Every Sunday at 7:00 PM                               │ │
│  │    - Repeat: true                                          │ │
│  │    - Content: "Weekly Review Time"                         │ │
│  │                                                             │ │
│  │  • cancelNotifications(for: Goal)                          │ │
│  │    - Remove all notifications for deleted goal             │ │
│  └────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘


┌─────────────────────────────────────────────────────────────────┐
│                   PersistenceController.swift                    │
│                    (Core Data Stack)                             │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │ Singleton: PersistenceController.shared                    │ │
│  │                                                             │ │
│  │ Container: NSPersistentContainer("GoalBreaker")            │ │
│  │                                                             │ │
│  │ Features:                                                   │ │
│  │  • Automatic context merging                               │ │
│  │  • Preview instance with sample data                       │ │
│  │  • In-memory store for previews                            │ │
│  └────────────────────────────────────────────────────────────┘ │
└──────────────────────────┬──────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────────┐
│               GoalBreaker.xcdatamodeld                           │
│                  (Core Data Model)                               │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │ Goal Entity                     Review Entity              │ │
│  │ ──────────────                  ───────────────            │ │
│  │ • id: UUID                      • id: UUID                 │ │
│  │ • title: String                 • weekStartDate: Date      │ │
│  │ • deadline: Date                • goalsSummary: String     │ │
│  │ • monthlyGoals: String (JSON)   • userNotes: String        │ │
│  │ • weeklyGoals: String (JSON)                               │ │
│  │ • createdAt: Date                                          │ │
│  │                                                             │ │
│  │ Helper Properties:                                          │ │
│  │ • monthlyGoalsArray: [String]                              │ │
│  │ • weeklyGoalsArray: [[String]]                             │ │
│  └────────────────────────────────────────────────────────────┘ │
│                                                                  │
│  Generated Classes:                                              │
│  • Goal+CoreDataClass.swift                                     │
│  • Goal+CoreDataProperties.swift                                │
│  • Review+CoreDataClass.swift                                   │
│  • Review+CoreDataProperties.swift                              │
└─────────────────────────────────────────────────────────────────┘


┌─────────────────────────────────────────────────────────────────┐
│                    DateExtensions.swift                          │
│                   (Date Utility Functions)                       │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │ Extension Date {                                           │ │
│  │   var weekOfYear: Int                                      │ │
│  │   var startOfWeek: Date        // Monday                   │ │
│  │   var startOfMonth: Date                                   │ │
│  │   var isInCurrentWeek: Bool                                │ │
│  │   func monthDiff(from: Date) -> Int                        │ │
│  │ }                                                           │ │
│  └────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘


┌─────────────────────────────────────────────────────────────────┐
│                        Data Flow                                 │
└─────────────────────────────────────────────────────────────────┘

   User Creates Goal
        │
        ▼
   AddGoalView
        │
        ├──► AIGoalBreaker ──► OpenAI API ──► Returns breakdown
        │                                            │
        │                                            ▼
        │                                    Display preview
        │                                            │
        ▼                                            ▼
   Save to Core Data ◄─────────────────────────── User confirms
        │
        ├──► Create Goal entity with JSON
        │
        └──► NotificationManager.scheduleDailyReminders()
                                │
                                ▼
                      Schedule UNNotifications


   User Views Goals
        │
        ▼
   HomeView
        │
        ├──► @FetchRequest ──► Core Data ──► Fetch Goals
        │                                            │
        │                                            ▼
        │                                     Display list
        │
        └──► User taps goal ──► GoalDetailView
                                      │
                                      ├──► Display tasks
                                      │
                                      └──► User checks task
                                              │
                                              ▼
                                        Save to UserDefaults


   Weekly Review
        │
        ├──► Notification fires (Sunday 7 PM)
        │         │
        │         ▼
        │    User opens app
        │         │
        ▼         ▼
   ReviewView
        │
        ├──► @FetchRequest ──► Fetch active goals
        │
        ├──► Calculate current week tasks
        │
        ├──► Auto-populate summary
        │
        └──► User adds notes ──► Save Review entity
                                       │
                                       ▼
                                  Core Data


┌─────────────────────────────────────────────────────────────────┐
│                      Technology Stack                            │
└─────────────────────────────────────────────────────────────────┘

   SwiftUI                     Core Data                Async/Await
   ───────                     ─────────                ───────────
   • @main                     • NSPersistentContainer  • async/await
   • NavigationStack           • @FetchRequest          • Task {}
   • @State                    • NSManagedObject        • URLSession.data()
   • @ObservedObject           • JSON encoding          • MainActor
   • @Environment              
   • Form, List, Section       
   • Alert, Sheet              
   • Preview providers         


   UserNotifications           Foundation               URLSession
   ─────────────────           ──────────               ──────────
   • UNUserNotificationCenter  • Date, Calendar         • HTTP POST
   • UNNotificationRequest     • UserDefaults           • JSON encoding
   • UNCalendarTrigger         • UUID, String           • Bearer auth
   • Authorization             • Codable                • Error handling
