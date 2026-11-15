
import SwiftUI

// MARK: - Goal Completed View

struct GoalCompletedView: View {

    // MARK: - ViewModel

    var viewModel: LearningGoalViewModel

    // MARK: - User Interface

    var body: some View {

        VStack(spacing: 0) {

            // MARK: - Success Icon

            Image("hands.clap")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .accessibilityHidden(true)

            // MARK: - Success Message

            Text("Well done!")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
                .padding(.top, 16)

            // MARK: - Subtitle

            Text("Ready for your next goal?")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.top, 4)

            // MARK: - Set a Goal Navigation

            NavigationLink {
                EditGoalView(viewModel: viewModel)
            } label: {

                Label(
                    "Set a goal",
                    systemImage: "square.and.pencil"
                )
                .font(.body)
                .foregroundStyle(.white)
                .padding(.horizontal, 24)
                .frame(minHeight: 48)
                .background(.orange)
                .clipShape(Capsule())
            }
            .buttonStyle(.plain)
            .padding(.top, 72)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
        .padding(.top, 64)
    }
}

// MARK: - SwiftUI Preview

#Preview {
    NavigationStack {
        ZStack {
            Color("AppBackground")
                .ignoresSafeArea()

            GoalCompletedView(
                viewModel: LearningGoalViewModel()
            )
        }
    }
}
