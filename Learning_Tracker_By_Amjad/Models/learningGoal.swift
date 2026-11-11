
import Foundation

// MARK: - Learning Goal Model

// Stores the user's learning goal information
struct LearningGoal {

    // The subject the user wants to learn
    var title: String = ""

    // The selected learning duration
    var duration: LearningDuration = .week

    // The date the learning goal was created
    var startDate: Date = Date.now
}

// MARK: - Learning Duration

// Defines the available learning durations
enum LearningDuration {

    case week
    case month
    case year

    // Converts each duration into displayable text
    var displayName: String {
        switch self {
        case .week:
            return "Week"
        case .month:
            return "Month"
        case .year:
            return "Year"
        }
    }
}
