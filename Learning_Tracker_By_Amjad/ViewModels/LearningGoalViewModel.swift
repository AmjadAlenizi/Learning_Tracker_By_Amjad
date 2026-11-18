
import Foundation
import Observation

// MARK: - Learning Goal ViewModel

@Observable
class LearningGoalViewModel {
    
    // MARK: - Learning Goal
    
    private(set) var goal = LearningGoal()
    
    private(set) var hasStartedGoal: Bool = false
    
    private(set) var achievements:[Achievement] = []
    
    // MARK: - Current Date
    
    private(set) var currentDate = Date.now
    
    // MARK: - Learning Progress
    
    var learnedDates: [Date] = []
    
    var frozenDates: [Date] = []
    
    private(set) var currentStreak: Int = 0
    
    // MARK: - Calendar History

    private(set) var allLearnedDates: [Date] = []
    private(set) var allFrozenDates: [Date] = []
    
    // MARK: - UserDefaults Keys
    
    private enum StorageKeys {
        static let hasStartedGoal = "hasStartedGoal"
        static let goalTitle = "goalTitle"
        static let goalDuration = "goalDuration"
        static let goalStartDate = "goalStartDate"
        static let learnedDates = "learnedDates"
        static let frozenDates = "frozenDates"
        static let allLearnedDates = "allLearnedDates"
        static let allFrozenDates = "allFrozenDates"
        static let currentStreak = "currentStreak"
        static let achievements = "achievements"
    }
    
    // MARK: - Initializer
    
    init() {
        loadSavedData()
        refreshStreak()
    }
    
    // MARK: - Load Saved Data
    
    private func loadSavedData() {
        
        let defaults = UserDefaults.standard
        
        hasStartedGoal = defaults.bool(
            forKey: StorageKeys.hasStartedGoal
        )
        
        if let savedTitle = defaults.string(
            forKey: StorageKeys.goalTitle
        ) {
            goal.title = savedTitle
        }
        
        if let savedDuration = defaults.string(
            forKey: StorageKeys.goalDuration
        ) {
            switch savedDuration {
            case "week":
                goal.duration = .week
            case "month":
                goal.duration = .month
            case "year":
                goal.duration = .year
            default:
                break
            }
        }
        
        if let savedStartDate = defaults.object(
            forKey: StorageKeys.goalStartDate
        ) as? Date {
            goal.startDate = savedStartDate
        }
        
        learnedDates = defaults.array(
            forKey: StorageKeys.learnedDates
        ) as? [Date] ?? []
        
        frozenDates = defaults.array(
            forKey: StorageKeys.frozenDates
        ) as? [Date] ?? []
        
        allLearnedDates = defaults.array(
            forKey: StorageKeys.allLearnedDates
        ) as? [Date] ?? learnedDates
        
        allFrozenDates = defaults.array(
            forKey: StorageKeys.allFrozenDates
        ) as? [Date] ?? frozenDates
        
        currentStreak = defaults.integer(
            forKey: StorageKeys.currentStreak
        )
        
        saveProgress()
        
        let decoder = JSONDecoder()
        
        if let savedData = defaults.data(forKey: StorageKeys.achievements) {
            if let savedAchievements = try? decoder.decode([Achievement].self, from: savedData) {
                achievements = savedAchievements
            }
        }
    }
    
    // MARK: - Save Goal Data
    
    private func saveGoalData() {
        
        let defaults = UserDefaults.standard
        
        defaults.set(
            hasStartedGoal,
            forKey: StorageKeys.hasStartedGoal
        )
        
        defaults.set(
            goal.title,
            forKey: StorageKeys.goalTitle
        )
        
        let durationValue: String
        
        switch goal.duration {
        case .week:
            durationValue = "week"
        case .month:
            durationValue = "month"
        case .year:
            durationValue = "year"
        }
        
        defaults.set(
            durationValue,
            forKey: StorageKeys.goalDuration
        )
        
        defaults.set(
            goal.startDate,
            forKey: StorageKeys.goalStartDate
        )
    }
    
    // MARK: - Save Learning Progress
    
    private func saveProgress() {
        
        let defaults = UserDefaults.standard
        
        defaults.set(
            learnedDates,
            forKey: StorageKeys.learnedDates
        )
        
        defaults.set(
            frozenDates,
            forKey: StorageKeys.frozenDates
        )
        
        defaults.set(
            allLearnedDates,
            forKey: StorageKeys.allLearnedDates
        )
        
        defaults.set(
            allFrozenDates,
            forKey: StorageKeys.allFrozenDates
        )
        
        defaults.set(
            currentStreak,
            forKey: StorageKeys.currentStreak
        )
        
    }
    
    private func saveAchievements() {
        let encoder = JSONEncoder()
        
        if let data = try? encoder.encode(achievements) {
            
            UserDefaults.standard.set(
                data,
                forKey: StorageKeys.achievements
            )
            
        }
    }
    
    // MARK: - Record Completed Goal

    func recordCompletedGoalIfNeeded() {
        guard hasStartedGoal, hasGoalSucceeded else {
               return
        }
        let alreadyRecorded = achievements.contains { achievement in
            achievement.goalStartDate == goal.startDate
        }
        guard !alreadyRecorded else {
            return
        }
        let newAchievement = Achievement(id : UUID() , title : goal.title, duration : goal.duration, goalStartDate : goal.startDate)
        
        achievements.append(newAchievement)
        
        saveAchievements()
    }

        // MARK: - Refresh Current Date
    
    func refreshCurrentDate() {
        currentDate = Date.now
        refreshStreak()
        recordCompletedGoalIfNeeded()
    }

        
        // MARK: - Update Goal
        
        func updateGoal(newTitle: String) {
            goal.title = newTitle
            saveGoalData()
        }
        
        // MARK: - Start Goal
        
        func startGoal() {
            
            guard !goal.title.trimmingCharacters(
                in: .whitespacesAndNewlines
            ).isEmpty else {
                return
            }
            
            hasStartedGoal = true
            goal.startDate = Date.now
            
            saveGoalData()
            saveProgress()
        }
        
        // MARK: - Has Learned Today
        
        var hasLearnedToday: Bool {
            
            learnedDates.contains { date in
                Calendar.current.isDateInToday(date)
            }
        }
        
        // MARK: - Has Frozen Today
        
        var hasFrozenToday: Bool {
            
            frozenDates.contains { date in
                Calendar.current.isDateInToday(date)
            }
        }
    
    
    // MARK: - Streak Expiration

    private let streakGracePeriod: TimeInterval = 32 * 60 * 60

    private func streakDeadline(after lastLearning: Date) -> Date {
        let calendar = Calendar.current
        var deadline = lastLearning.addingTimeInterval(streakGracePeriod)

        for freeze in frozenDates.sorted() {
            let freezeStart = calendar.startOfDay(for: freeze)

            guard let freezeEnd = calendar.date(
                byAdding: .day,
                value: 1,
                to: freezeStart
            ) else {
                continue
            }

            // A Freeze must begin before the streak expires.
            if freezeStart <= deadline && freezeEnd > lastLearning {
                // Protect the full frozen day, then allow 32 hours.
                deadline = max(
                    deadline,
                    freezeEnd.addingTimeInterval(streakGracePeriod)
                )
            }
        }

        return deadline
    }

    private func isStreakValid(at date: Date) -> Bool {
        guard let lastLearning = learnedDates.max() else {
            return false
        }

        return date <= streakDeadline(after: lastLearning)
    }

    func refreshStreak() {
        guard currentStreak > 0 else { return }

        if !isStreakValid(at: .now) {
            currentStreak = 0
            saveProgress()
        }
    }
        
        // MARK: - Log Learning
        
        func logLearning() {
            
            guard hasStartedGoal,
                  !hasGoalEnded,
                  !hasLearnedToday else {
                return
            }
            
            let calendar = Calendar.current
            let today = Date.now
            
            // MARK: - Calculate Learning Streak

            if learnedDates.isEmpty {
                currentStreak = 1
            } else if isStreakValid(at: today) {
                currentStreak += 1
            } else {
                currentStreak = 1
            }
            
            // MARK: - Replace Today's Freeze with Learned.
            
            frozenDates.removeAll { date in
                calendar.isDateInToday(date)
            }
            allFrozenDates.removeAll { date in
                calendar.isDateInToday(date)
            }
            
            // Record today's learning
            
            learnedDates.append(today)
            
            allLearnedDates.append(today)
            
            // Save updated progress
            
            saveProgress()
        }
        
        // MARK: - Log Freeze
        
        func logFreeze() {
            
            guard hasStartedGoal,
                  !hasGoalEnded,
                  !hasFrozenToday,
                  !hasLearnedToday,
                  remainingFreezes > 0 else {
                return
            }
            

            refreshStreak()

            // Allow Freeze on the first day of a new goal.
            // Prevent Freeze from restoring an expired streak.

            guard learnedDates.isEmpty ||
                  (currentStreak > 0 && isStreakValid(at: .now)) else {
                return
            }

            frozenDates.append(Date.now)
            allFrozenDates.append(Date.now)
            
            saveProgress()
        }
        
        // MARK: - Freeze Limit
        
        var freezeLimit: Int {
            
            switch goal.duration {
                
            case .week:
                return 2
                
            case .month:
                return 8
                
            case .year:
                return 96
            }
        }
        
        // MARK: - Remaining Freezes
        
        var remainingFreezes: Int {
            max(0, freezeLimit - frozenDates.count)
        }
        
        // MARK: - Update Learning Duration
        
        func updateDuration(newDuration: LearningDuration) {
            
            goal.duration = newDuration
            
            saveGoalData()
        }
        
        // MARK: - Goal Duration Days
        
        var goalDurationDays: Int {
            
            let calendar = Calendar.current
            let endDate: Date?
            
            switch goal.duration {
                
            case .week:
                endDate = calendar.date(
                    byAdding: .day,
                    value: 7,
                    to: goal.startDate
                )
                
            case .month:
                endDate = calendar.date(
                    byAdding: .month,
                    value: 1,
                    to: goal.startDate
                )
                
            case .year:
                endDate = calendar.date(
                    byAdding: .year,
                    value: 1,
                    to: goal.startDate
                )
            }
            
            guard let endDate else {
                return 0
            }
            
            return calendar.dateComponents(
                [.day],
                from: calendar.startOfDay(for: goal.startDate),
                to: calendar.startOfDay(for: endDate)
            ).day ?? 0
        }
        
        // MARK: - Completed Learning Days
        
        var completedDays: Int {
            
            let calendar = Calendar.current
            
            let startDate = calendar.startOfDay(
                for: goal.startDate
            )
            
            guard let endDate = calendar.date(
                byAdding: .day,
                value: goalDurationDays,
                to: startDate
            ) else {
                return 0
            }
            
            let allDates = learnedDates + frozenDates
            
            let validDays = allDates.filter { date in
                
                let day = calendar.startOfDay(for: date)
                
                return day >= startDate && day < endDate
            }
            
            let uniqueDays = Set(
                validDays.map {
                    calendar.startOfDay(for: $0)
                }
            )
            
            return uniqueDays.count
        }
        
        // MARK: - Goal End Check
        
        var hasGoalEnded: Bool {
            
            let calendar = Calendar.current
            
            guard let endDate = calendar.date(
                byAdding: .day,
                value: goalDurationDays,
                to: calendar.startOfDay(for: goal.startDate)
            ) else {
                return false
            }
            
            return currentDate >= endDate
        }
        
        // MARK: - Goal Success Check
        
        var hasGoalSucceeded: Bool {
            
            hasGoalEnded &&
            goalDurationDays > 0 &&
            completedDays == goalDurationDays
        }
        
        // MARK: - Confirm Goal Update
        
        func confirmGoalUpdate(
            newTitle: String,
            newDuration: LearningDuration
        ) {
            
            let trimmedTitle = newTitle.trimmingCharacters(
                in: .whitespacesAndNewlines
            )
            
            guard !trimmedTitle.isEmpty else {
                return
            }
            recordCompletedGoalIfNeeded()
            
            // Update learning goal
            
            goal.title = trimmedTitle
            goal.duration = newDuration
            goal.startDate = Date.now
            hasStartedGoal = true
            
            // Reset progress for the new goal
            
            currentStreak = 0
            
            learnedDates.removeAll()
            
            frozenDates.removeAll()
            
            // Save new goal and reset progress
            
            saveGoalData()
            saveProgress()
        }
    }
