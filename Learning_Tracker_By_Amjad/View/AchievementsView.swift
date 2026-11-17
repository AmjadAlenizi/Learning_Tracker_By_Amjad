//
//  AchievementsView.swift
//  Learning_Tracker_By_Amjad
//
//  Created by Amjad on 06/06/1448 AH.
//

import SwiftUI

// MARK: - Achievements Screen

struct AchievementsView: View {

    // MARK: - ViewModel

    var viewModel: LearningGoalViewModel

    // MARK: - User Interface

    var body: some View {

        ScrollView {

            VStack(alignment: .leading, spacing: 24) {

                if viewModel.achievements.isEmpty {

                    // MARK: - Empty State
                   ContentUnavailableView {
                       Label {
                           Text("No Achievements Yet")
                       } icon: {
                           Image(systemName: "trophy")
                               .foregroundStyle(.orange)
                       }
                   } description: {
                       Text(
                           "Complete your learning goal to earn your first achievement!"
                       )
                   }
                   .frame(maxWidth: .infinity)
                   .padding(.top, 80)

                   } else {

                    // MARK: - Completed Goals

                    LazyVStack(spacing: 12) {

                        ForEach(
                            viewModel.achievements.sorted {
                                $0.goalStartDate > $1.goalStartDate
                            }
                        ) { achievement in

                            achievementRow(achievement)

                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Achievements")
        .navigationBarTitleDisplayMode(.large)
    }

    // MARK: - Achievement Row

    private func achievementRow(
        _ achievement: Achievement
    ) -> some View {

        HStack(spacing: 16) {

            // MARK: - Trophy Icon

            Image(systemName: "trophy.fill")
                .font(.system(size: 28))
                .foregroundStyle(.orange)
                .frame(width: 52, height: 52)
                .background(
                    Color.orange.opacity(0.15),
                    in: RoundedRectangle(cornerRadius: 14)
                )
                .accessibilityHidden(true)

            // MARK: - Goal Information

            VStack(alignment: .leading, spacing: 6) {

                Text(achievement.title)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text(achievement.duration.displayName)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 0)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            Color(.secondarySystemGroupedBackground),
            in: RoundedRectangle(cornerRadius: 20)
        )
        .accessibilityElement(children: .combine)
    }
}
