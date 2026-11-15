
import Foundation
import Observation

// MARK: - Learning Goal ViewModel

@Observable
class LearningGoalViewModel {

    // MARK: - Learning Goal

    private(set) var goal = LearningGoal()
    
    func updateGoal(newTitle: String) {
        goal.title = newTitle
    }
    
    // MARK: - Learning Progress

    // Stores all dates on which learning was logged
    var learnedDates: [Date] = []

    // Checks whether learning has been logged today
    var hasLearnedToday: Bool {
        learnedDates.contains { date in
            Calendar.current.isDateInToday(date)
        }
    }

    // Stores all dates on which Freeze was used
    var frozenDates: [Date] = []

    // Checks whether Freeze has been logged today
    var hasFrozenToday: Bool {
        frozenDates.contains { date in
            Calendar.current.isDateInToday(date)
        }
    }

    // Tracks the current number of consecutive learning days
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
                    calendar.isDate(date, inSameDayAs: dateToCheck)
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
}
