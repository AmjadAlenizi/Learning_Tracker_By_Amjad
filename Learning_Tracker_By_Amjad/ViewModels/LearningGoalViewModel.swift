
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

    // Records today's learning only once
    func logLearning() {
        guard !hasLearnedToday else {
            return
        }

        learnedDates.append(Date.now)
    }

    // Records today's Freeze only once
    func logFreeze() {
        guard !hasFrozenToday else {
            return
        }
        guard !hasLearnedToday else {
            return
        }
       
        guard remainingFreezes > 0 else {
            return }

        frozenDates.append(Date.now)
    }
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
    var remainingFreezes: Int{
        return freezeLimit - frozenDates.count
    }

    // MARK: - Learning Duration
    func updateDuration(newDuration: LearningDuration) {
        goal.duration = newDuration
    }
}
