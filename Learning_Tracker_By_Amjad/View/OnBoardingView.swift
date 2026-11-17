
import SwiftUI

// MARK: - Onboarding Screen

struct OnboardingView: View {

    // MARK: - State Properties

    // Stores and manages the learning goal
    var viewModel : LearningGoalViewModel

    // Controls navigation to the Activity screen
    @State private var showActivity = false

    // MARK: - User Interface

    var body: some View {

        NavigationStack {

            ZStack {

                // MARK: - App Background

                Color("AppBackground")
                    .ignoresSafeArea()

                // MARK: - Main Content

                VStack(alignment: .leading, spacing: 8) {

                    // MARK: - Welcome Section

                    Image(systemName: "flame.fill")
                        .font(.system(size: 48))
                        .foregroundStyle(.orange)
                        .padding(.bottom, 16)

                    Text("Hello Learner")
                        .font(.title)
                        .fontWeight(.bold)

                    Text("This app will help you learn everyday!")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    // MARK: - Learning Goal Input

                    Text("I want to learn")
                        .font(.headline)

                    TextField(
                        "Swift",
                        text: Binding(
                            get: {
                                viewModel.goal.title
                            },
                            set: { newValue in
                                viewModel.updateGoal(newTitle: newValue)
                            }
                        )
                    )
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background {
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(
                                Color("InputBorder"),
                                lineWidth: 1
                            )
                    }

                    // MARK: - Learning Duration Selection

                    Text("I want to learn for a")
                        .font(.headline)

                    HStack(spacing: 12) {

                        // Week Button

                        Button("Week") {
                            viewModel.updateDuration(newDuration: .week)
                        }
                        .foregroundStyle(
                            viewModel.goal.duration == .week
                            ? .orange : .secondary
                        )
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity)
                        .background(
                            viewModel.goal.duration == .week
                            ? Color.orange.opacity(0.15)
                            : Color.clear
                        )
                        .clipShape(
                            RoundedRectangle(cornerRadius: 24)
                        )

                        // Month Button

                        Button("Month") {
                            viewModel.updateDuration(newDuration: .month)
                        }
                        .foregroundStyle(
                            viewModel.goal.duration == .month
                            ? .orange : .secondary
                        )
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity)
                        .background(
                            viewModel.goal.duration == .month
                            ? Color.orange.opacity(0.15)
                            : Color.clear
                        )
                        .clipShape(
                            RoundedRectangle(cornerRadius: 24)
                        )

                        // Year Button

                        Button("Year") {
                            viewModel.updateDuration(newDuration: .year)
                        }
                        .foregroundStyle(
                            viewModel.goal.duration == .year
                            ? .orange : .secondary
                        )
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity)
                        .background(
                            viewModel.goal.duration == .year
                            ? Color.orange.opacity(0.15)
                            : Color.clear
                        )
                        .clipShape(
                            RoundedRectangle(cornerRadius: 24)
                        )
                    }

                    // MARK: - Flexible Spacing

                    Spacer()

                    // MARK: - Start Learning Button

                    Button("Start Learning") {

                        if !viewModel.goal.title
                            .trimmingCharacters(in: .whitespacesAndNewlines)
                            .isEmpty {
                            viewModel.startGoal()

                            showActivity = true
                        }
                    }
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 24)
                    )
                    .padding(.bottom, 8)

                    // MARK: - Onboarding Footer

                    Text("You can edit your desire later")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .frame(
                            maxWidth: .infinity,
                            alignment: .center
                        )
                }

                // MARK: - Layout and Appearance

                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
                .frame(
                    maxHeight: .infinity,
                    alignment: .top
                )
                .padding(.horizontal, 24)
                .foregroundStyle(.primary)

            } // End of ZStack

            // MARK: - Navigation

            .navigationDestination(isPresented: $showActivity) {
                ActivityView(viewModel: viewModel)
            }

        } // End of NavigationStack
    }
}

// MARK: - SwiftUI Preview

#Preview {
    OnboardingView(viewModel: LearningGoalViewModel())
}
