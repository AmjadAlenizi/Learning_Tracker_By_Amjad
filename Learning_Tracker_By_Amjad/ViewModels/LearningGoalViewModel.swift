
import Foundation
import Observation

// MARK: - Learning Goal ViewModel

@Observable
class LearningGoalViewModel {

    // MARK: - Learning Goal

    private(set) var goal = LearningGoal()
    
    // MARK: - Current Date

    private(set) var currentDate = Date.now

    // MARK: - Refresh Current Date
    func refreshCurrentDate() {
        currentDate = Date.now
    }
    func updateGoal(newTitle: String) {
        goal.title = newTitle
    }

    // MARK: - Learning Progress

    // Stores dates on which learning was logged
    var learnedDates: [Date] = []

    // Checks whether learning has been logged today
    var hasLearnedToday: Bool {
        learnedDates.contains { date in
            Calendar.current.isDateInToday(date)
        }
    }

    // Stores dates on which Freeze was used
    var frozenDates: [Date] = []

    // Checks whether Freeze has been logged today
    var hasFrozenToday: Bool {
        frozenDates.contains { date in
            Calendar.current.isDateInToday(date)
        }
    }

    // Tracks consecutive learning days
    private(set) var currentStreak: Int = 0

    // MARK: - Log Learning

    func logLearning() {
        guard !hasLearnedToday else {
            return
        }

        let calendar = Calendar.current
        let today = Date.now

        if let lastLearnedDate = learnedDates.last {

            // Start checking the day after the last Learned
            var checkDate = calendar.date(
                byAdding: .day,
                value: 1,
                to: calendar.startOfDay(for: lastLearnedDate)
            )

            var streakContinues = true

            // Check all days between last Learned and today
            while let dateToCheck = checkDate,
                  dateToCheck < calendar.startOfDay(for: today) {

                let isFrozen = frozenDates.contains { date in
                    calendar.isDate(
                        date,
                        inSameDayAs: dateToCheck
                    )
                }

                // A missed day breaks the streak
                if !isFrozen {
                    streakContinues = false
                    break
                }

                // Move to the next calendar day
                checkDate = calendar.date(
                    byAdding: .day,
                    value: 1,
                    to: dateToCheck
                )
            }

            if streakContinues {
                currentStreak += 1
            } else {
                currentStreak = 1
            }

        } else {
            // First Learned day
            currentStreak = 1
        }

        learnedDates.append(today)
    }

    // MARK: - Log Freeze

    func logFreeze() {
        guard !hasFrozenToday else {
            return
        }

        guard !hasLearnedToday else {
            return
        }

        guard remainingFreezes > 0 else {
            return
        }

        frozenDates.append(Date.now)
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

    var remainingFreezes: Int {
        freezeLimit - frozenDates.count
    }

    // MARK: - Learning Duration

    func updateDuration(newDuration: LearningDuration) {
        goal.duration = newDuration
    }

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

        // Update learning goal
        goal.title = trimmedTitle
        goal.duration = newDuration
        goal.startDate = Date.now

        // Reset progress for the new goal
        currentStreak = 0
        learnedDates.removeAll()
        frozenDates.removeAll()
    }
}
