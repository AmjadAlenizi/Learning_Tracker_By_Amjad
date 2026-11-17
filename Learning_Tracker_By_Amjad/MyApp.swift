import SwiftUI

@main
struct MyApp: App {

    @State private var viewModel = LearningGoalViewModel()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if viewModel.hasStartedGoal {
                    ActivityView(viewModel: viewModel)
                } else {
                    OnboardingView(viewModel: viewModel)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}
