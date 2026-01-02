# GoalBreaker

An iOS app that helps users break down long-term goals into actionable monthly and weekly plans using AI, with reminders and weekly reviews.

## Features

- **AI-Powered Goal Breakdown**: Uses OpenAI's GPT-3.5 to automatically break down your long-term goals into monthly milestones and weekly tasks
- **Goal Management**: Create, view, and track multiple goals with deadlines
- **Progress Tracking**: Visual progress indicators showing completed tasks
- **Smart Reminders**: Daily notifications for tasks and weekly review prompts
- **Weekly Reviews**: Reflect on your progress with structured weekly review sessions
- **Core Data Persistence**: All goals and reviews are saved locally on your device

## Requirements

- iOS 17.0 or later
- Xcode 15.0 or later
- Swift 5.0 or later
- OpenAI API key (for AI-powered goal breakdown)

## Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/remcobrilstra/GoalBreaker.git
   cd GoalBreaker
   ```

2. Open the project in Xcode:
   ```bash
   open GoalBreaker.xcodeproj
   ```

3. Add your OpenAI API key:
   - Open `GoalBreaker/Constants.swift`
   - Replace `"your-api-key-here"` with your actual OpenAI API key:
     ```swift
     static let openAIAPIKey = "sk-your-actual-api-key-here"
     ```

4. Build and run the project on a simulator or device

## Project Structure

```
GoalBreaker/
├── GoalBreaker/
│   ├── GoalBreakerApp.swift          # Main app entry point
│   ├── ContentView.swift             # Root navigation view
│   ├── Constants.swift               # Configuration constants (API key)
│   ├── Info.plist                    # App configuration
│   │
│   ├── Views/
│   │   ├── HomeView.swift            # Main goal list screen
│   │   ├── AddGoalView.swift         # Create new goal with AI
│   │   ├── GoalDetailView.swift      # View goal details and tasks
│   │   └── ReviewView.swift          # Weekly review interface
│   │
│   ├── Models/
│   │   ├── PersistenceController.swift      # Core Data stack
│   │   ├── GoalBreaker.xcdatamodeld/        # Core Data model
│   │   ├── Goal+CoreDataClass.swift         # Goal entity
│   │   ├── Goal+CoreDataProperties.swift    # Goal properties
│   │   ├── Review+CoreDataClass.swift       # Review entity
│   │   └── Review+CoreDataProperties.swift  # Review properties
│   │
│   ├── Utilities/
│   │   ├── AIGoalBreaker.swift       # OpenAI integration
│   │   ├── NotificationManager.swift # Notification handling
│   │   └── DateExtensions.swift      # Date utility functions
│   │
│   └── Assets.xcassets/              # App assets and icons
```

## Core Data Model

### Goal Entity
- `id` (UUID): Unique identifier
- `title` (String): Goal description
- `deadline` (Date): Target completion date
- `monthlyGoals` (String): JSON-encoded array of monthly milestones
- `weeklyGoals` (String): JSON-encoded 2D array of weekly tasks
- `createdAt` (Date): Creation timestamp

### Review Entity
- `id` (UUID): Unique identifier
- `weekStartDate` (Date): Week start date
- `goalsSummary` (String): Summary of week's goals
- `userNotes` (String): User's reflection notes

## How It Works

### Creating a Goal

1. Tap the "+" button on the home screen
2. Enter your goal title and deadline
3. Tap "Break Down with AI"
4. The app uses OpenAI to generate monthly milestones and weekly tasks
5. Review the AI-generated breakdown
6. Save the goal to begin tracking

### Tracking Progress

- View all your goals on the home screen
- Tap a goal to see detailed monthly and weekly breakdowns
- Check off tasks as you complete them
- Track overall progress with visual indicators

### Weekly Reviews

- Access weekly reviews from the calendar icon
- Review the current week's tasks from all active goals
- Add personal notes and reflections
- Save your review for future reference

### Notifications

- **Daily Reminders**: Receive notifications for your weekly tasks at 8 AM
- **Weekly Review**: Get reminded every Sunday at 7 PM to review your progress

## Technologies Used

- **SwiftUI**: Modern declarative UI framework
- **Core Data**: Local data persistence
- **UserNotifications**: Reminder system
- **URLSession**: OpenAI API integration
- **Combine**: Reactive programming (via @FetchRequest)

## API Integration

The app integrates with OpenAI's Chat Completions API to break down goals:

- **Endpoint**: `https://api.openai.com/v1/chat/completions`
- **Model**: GPT-3.5 Turbo
- **Authentication**: Bearer token (from Constants.swift)

If the API call fails or you don't have an API key, the app provides a fallback structure with generic monthly and weekly milestones.

## License

This project is open source and available under the MIT License.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Support

For issues, questions, or suggestions, please open an issue on GitHub.
