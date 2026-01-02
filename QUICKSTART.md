# GoalBreaker - Quick Start Guide

## Getting Started in 5 Minutes

### Step 1: Setup (1 minute)

1. **Get an OpenAI API Key**
   - Visit https://platform.openai.com/api-keys
   - Sign up or log in
   - Create a new API key
   - Copy the key (starts with `sk-`)

2. **Configure the App**
   - Open `GoalBreaker/Constants.swift`
   - Replace `"your-api-key-here"` with your API key:
     ```swift
     static let openAIAPIKey = "sk-your-actual-key-here"
     ```

3. **Build and Run**
   - Open `GoalBreaker.xcodeproj` in Xcode
   - Select a simulator or device (iOS 17+)
   - Press ⌘R to build and run

### Step 2: Create Your First Goal (2 minutes)

1. **Tap the "+" Button**
   - On the home screen, tap the plus icon in the top-right

2. **Enter Goal Details**
   - Goal Title: "Learn Swift Programming"
   - Deadline: Select a date 3 months from now
   - Tap "Break Down with AI"

3. **Review AI Breakdown**
   - The app will generate monthly milestones
   - Each month will have 4 weekly tasks
   - Review the suggestions

4. **Save Your Goal**
   - If satisfied, tap "Save Goal"
   - If not, tap "Regenerate" for new suggestions

### Step 3: Track Your Progress (1 minute)

1. **View Goal Details**
   - Tap on your newly created goal
   - See all monthly and weekly tasks

2. **Complete Tasks**
   - Tap the circle next to a task to mark it complete
   - Task will show a green checkmark and strikethrough
   - Progress bar updates automatically

### Step 4: Weekly Review (1 minute)

1. **Access Reviews**
   - Tap the calendar icon in the top-left of the home screen
   - Or wait for Sunday 7 PM notification

2. **Review Your Week**
   - See current week's tasks from all goals
   - Add notes about your progress
   - Tap "Save Review"

## Features at a Glance

### 🎯 Home Screen
- **View All Goals**: See your goal list with progress
- **Quick Actions**: Add new goals or access reviews
- **Swipe to Delete**: Remove completed or abandoned goals

### ➕ Add Goal Screen
- **AI-Powered**: Let AI break down your goal
- **Preview**: See the breakdown before saving
- **Flexible**: Regenerate if you want different tasks

### 📊 Goal Detail Screen
- **Monthly View**: See goals organized by month
- **Weekly Tasks**: 4 tasks per month
- **Progress Tracking**: Check off tasks as you complete them
- **Visual Progress**: See your completion percentage

### 📝 Weekly Review
- **Auto-Summary**: Current week's tasks loaded automatically
- **Reflection**: Add your own notes and thoughts
- **History**: All reviews saved for future reference

## Notifications

### Daily Reminders
- **Time**: 8:00 AM
- **Content**: Your weekly task for the day
- **Frequency**: Based on your goal timeline

### Weekly Review
- **Time**: Sunday 7:00 PM
- **Content**: Reminder to review your week
- **Frequency**: Every Sunday

## Tips for Success

### 1. Be Specific with Goals
❌ Bad: "Get better at coding"
✅ Good: "Build 3 iOS apps using SwiftUI"

### 2. Set Realistic Deadlines
- Consider your other commitments
- Allow buffer time for unexpected delays
- 3-6 months is ideal for learning goals

### 3. Review Weekly
- Don't skip your Sunday reviews
- Honest reflection helps you improve
- Adjust your approach based on what works

### 4. Use the AI Wisely
- The AI provides suggestions, not rules
- Regenerate if tasks don't fit your style
- You can still complete tasks in any order

### 5. Track Consistently
- Check off tasks as you complete them
- Don't wait until the end of the week
- Visual progress is motivating!

## Troubleshooting

### AI Breakdown Not Working?

**Check Your API Key**
```swift
// In Constants.swift, should look like:
static let openAIAPIKey = "sk-abc123..."  // Not "your-api-key-here"
```

**Check Internet Connection**
- AI requires internet to work
- Try toggling WiFi off and on

**API Quota Exceeded?**
- Check your OpenAI account usage
- Free tier has limits

**Still Not Working?**
- The app will use fallback structure
- Generic "Month X, Week Y task" format
- You can still use all features

### Notifications Not Appearing?

**Grant Permissions**
- When first launching, tap "Allow" for notifications
- If you denied: Settings → GoalBreaker → Notifications → Enable

**Check Focus Mode**
- Ensure Focus mode allows GoalBreaker notifications
- Settings → Focus → [Your Focus] → Apps → Allow GoalBreaker

### App Crashes on Launch?

**Try These Steps**
1. Clean build folder: Product → Clean Build Folder (⇧⌘K)
2. Delete app from simulator/device
3. Rebuild and run

## Example Goals to Try

### Learning Goal
- **Title**: "Master Python Data Science"
- **Deadline**: 4 months
- **AI Will Suggest**: 
  - Month 1: Python basics, NumPy
  - Month 2: Pandas, data cleaning
  - Month 3: Matplotlib, visualization
  - Month 4: Machine learning basics

### Fitness Goal
- **Title**: "Run a Half Marathon"
- **Deadline**: 3 months
- **AI Will Suggest**:
  - Month 1: Build base mileage
  - Month 2: Add speed work
  - Month 3: Long runs and taper

### Creative Goal
- **Title**: "Write a Novel"
- **Deadline**: 6 months
- **AI Will Suggest**:
  - Month 1: Outline and characters
  - Month 2-5: Write chapters
  - Month 6: Edit and revise

## Data Management

### Where Is Data Stored?
- **Core Data**: All goals and reviews stored locally
- **UserDefaults**: Task completion status
- **No Cloud Sync**: Data stays on your device

### Backing Up
- Use iTunes/Finder to backup your device
- iCloud backup includes app data
- Alternatively, rebuild goals after restore

### Privacy
- Your data never leaves your device (except OpenAI API calls)
- API calls only send goal title and deadline
- No personal information collected

## Next Steps

1. **Create 2-3 Goals**: Don't overcommit
2. **Set Notifications**: Enable for best experience
3. **Review This Sunday**: Start the weekly habit
4. **Adjust as Needed**: The app adapts to you

## Need Help?

- **Documentation**: See README.md and IMPLEMENTATION.md
- **Issues**: Open an issue on GitHub
- **Questions**: Check existing issues first

## Enjoy GoalBreaker! 🎯

Remember: The best goal is one you actually complete. Start small, stay consistent, and celebrate progress!