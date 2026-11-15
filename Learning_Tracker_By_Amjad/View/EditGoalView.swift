//
//  EditGoalView.swift
//  Learning_Tracker_By_Amjad
//
//  Created by Amjad on 05/06/1448 AH.
//


import SwiftUI

// MARK: - Edit Learning Goal Screen

struct EditGoalView: View {

    // MARK: - Properties

    var viewModel: LearningGoalViewModel

    @Environment(\.dismiss) private var dismiss

    // Temporary edits - original goal stays unchanged
    @State private var editedTitle: String
    @State private var editedDuration: LearningDuration
    @State private var showUpdateAlert = false

    // MARK: - Initializer

    init(viewModel: LearningGoalViewModel) {
        self.viewModel = viewModel
        _editedTitle = State(initialValue: viewModel.goal.title)
        _editedDuration = State(initialValue: viewModel.goal.duration)
    }

    // MARK: - User Interface

    var body: some View {

        ZStack {
            Color("AppBackground")
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 32) {

                // MARK: - Header

                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.headline)
                            .foregroundStyle(.primary)
                            .frame(width: 44, height: 44)
                            .glassEffect(.regular, in: Circle())
                    }
                    .accessibilityLabel("Back")

                    Spacer()

                    Text("Learning Goal")
                        .font(.headline)

                    Spacer()

                    Button {
                        showUpdateAlert = true
                    } label: {
                        Image(systemName: "checkmark")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(width: 44, height: 44)
                            .background(.orange, in: Circle())
                    }
                    .disabled(
                        editedTitle.trimmingCharacters(
                            in: .whitespacesAndNewlines
                        ).isEmpty
                    )
                    .accessibilityLabel("Update goal")
                }

                // MARK: - Goal Input

                VStack(alignment: .leading, spacing: 12) {

                    Text("I want to learn")
                        .font(.subheadline)

                    TextField("Swift", text: $editedTitle)
                        .textInputAutocapitalization(.sentences)
                        .padding(.vertical, 8)

                    Divider()
                }

                // MARK: - Duration Selection

                VStack(alignment: .leading, spacing: 12) {

                    Text("I want to learn it in a")
                        .font(.subheadline)

                    HStack(spacing: 12) {

                        ForEach(
                            [LearningDuration.week,
                             .month,
                             .year],
                            id: \.self
                        ) { duration in

                            Button {
                                editedDuration = duration
                            } label: {
                                Text(duration.displayName)
                                    .foregroundStyle(
                                        editedDuration == duration
                                        ? Color.white
                                        : Color.secondary
                                    )
                                    .padding(.horizontal, 20)
                                    .frame(minHeight: 44)
                                    .background {
                                        Capsule()
                                            .fill(
                                                editedDuration == duration
                                                ? Color.orange
                                                : Color.primary.opacity(0.08)
                                            )
                                    }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 12)
            .frame(maxWidth: 600)
        }
        .foregroundStyle(.primary)
        .navigationBarBackButtonHidden(true)

        // MARK: - Update Confirmation

        .alert("Update goal", isPresented: $showUpdateAlert) {
            Button("Dismiss", role: .cancel) {}

            Button("Update") {
                viewModel.confirmGoalUpdate(
                    newTitle: editedTitle,
                    newDuration: editedDuration
                )
                dismiss()
            }
        } message: {
            Text("If you update now, your streak will start over.")
        }
    }
}

#Preview {
    EditGoalView(viewModel: LearningGoalViewModel())
}
