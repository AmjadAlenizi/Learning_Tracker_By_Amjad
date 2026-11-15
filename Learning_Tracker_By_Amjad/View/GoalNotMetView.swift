//
//  GoalNotMetView.swift
//  Learning_Tracker_By_Amjad
//
//  Created by Amjad on 05/06/1448 AH.
//

import SwiftUI

// MARK: - Goal Not Met View

struct GoalNotMetView: View {

    // MARK: - ViewModel

    var viewModel: LearningGoalViewModel

    // MARK: - User Interface

    var body: some View {

        VStack(spacing: 0) {

            // MARK: - Failure Icon

            Image(systemName: "xmark.seal")
                .font(.system(size: 60))
                .foregroundStyle(.orange)
                .accessibilityHidden(true)

            // MARK: - Failure Message

            Text("You didn't reach your goal this time.")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
                .multilineTextAlignment(.center)
                .padding(.top, 16)

            // MARK: - Subtitle

            Text("Want to set another goal?")
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

            GoalNotMetView(
                viewModel: LearningGoalViewModel()
            )
        }
    }
}
