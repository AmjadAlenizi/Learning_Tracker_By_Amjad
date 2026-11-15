
import SwiftUI

// MARK: - Activity Screen

struct ActivityView: View {

    // MARK: - ViewModel

    // Receives the same ViewModel from ContentView
    var viewModel: LearningGoalViewModel

    // MARK: - Calendar Properties

    private let calendar = Calendar.current
    private let today = Date.now

    // MARK: - Start of Week

    private var startOfWeek: Date {
        calendar.dateInterval(of: .weekOfYear, for: today)!.start
    }

    // MARK: - Week Dates

    private var weekDates: [Date] {
        (0..<7).compactMap { day in
            calendar.date(
                byAdding: .day,
                value: day,
                to: startOfWeek
            )
        }
    }

    // MARK: - Learned Date Check

    // Checks whether a specific day was logged as Learned
    private func isLearned(_ day: Date) -> Bool {
        viewModel.learnedDates.contains { learnedDate in
            calendar.isDate(learnedDate, inSameDayAs: day)
        }
    }
    private func isFreezed(_ day: Date) -> Bool {
        viewModel.frozenDates.contains { frozenDate in
            calendar.isDate(frozenDate, inSameDayAs: day)
        }
    }

    // MARK: - User Interface

    var body: some View {

        VStack(alignment: .leading, spacing: 16) {

            // MARK: - Activity Header

            HStack {

                Text("Activity")
                    .font(.title)
                    .fontWeight(.bold)

                Spacer()

                // MARK: - Calendar Button

                Button {
                    // Navigation will be added later
                } label: {
                    Image(systemName: "calendar")
                        .font(.system(size: 22))
                        .foregroundStyle(.primary)
                }

                // MARK: - Edit Goal Button

                Button {
                    // Navigation will be added later
                } label: {
                    Image(systemName: "square.and.pencil")
                        .font(.system(size: 22))
                        .foregroundStyle(.primary)
                }
            }

            // MARK: - Weekly Calendar

            Text(today, format: .dateTime.month(.wide).year())
                .font(.headline)
                .foregroundStyle(.primary)

            // MARK: - Week Days

            HStack(spacing: 0) {

                ForEach(weekDates, id: \.self) { day in

                    VStack(spacing: 8) {

                        Text(day, format: .dateTime.weekday(.narrow))
                            .font(.caption)

                        Text(day, format: .dateTime.day())
                            .font(.body)
                            .fontWeight(
                                calendar.isDateInToday(day)
                                ? .bold : .regular
                            )
                            .foregroundStyle(isLearned(day)
                                             ? Color.orange
                                         : isFreezed(day)
                                          ? Color.cyan
                                         : calendar.isDateInToday(day)
                                          ? Color.orange
                                             : Color.primary
                            )
                            .frame(width: 36, height: 36)
                            .background {
                                Circle()
                                    .fill(
                                         isLearned(day)
                                            ? Color.orange.opacity(0.2)
                                        : isFreezed(day)
                                         ? Color.cyan.opacity(0.2)
                                        : calendar.isDateInToday(day)
                                         ? Color.orange.opacity(0.2)
                                            : Color.clear
                                    )
                            }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.top, 8)

        }
        .padding(.horizontal, 16)

        // MARK: - Learning Statistics

        HStack(spacing: 16) {

            // MARK: - Learned Counter

            VStack(spacing: 4) {

                Image(systemName: "flame.fill")
                    .foregroundStyle(.orange)
                    .font(.title3)

                Text("\(viewModel.learnedDates.count)")
                    .font(.title)
                    .fontWeight(.bold)

                Text("Learned")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .glassEffect(
                .regular,
                in: RoundedRectangle(cornerRadius: 48)
            )

            // MARK: - Frozen Counter

            VStack(spacing: 4) {

                Image(systemName: "snowflake")
                    .foregroundStyle(.cyan)
                    .font(.title3)

                Text("\(viewModel.frozenDates.count)")
                    .font(.title)
                    .fontWeight(.bold)

                Text("Frozen")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .glassEffect(
                .regular,
                in: RoundedRectangle(cornerRadius: 48)
            )
        }

        // MARK: - Log as Learned Button

        Button {
            viewModel.logLearning()
        } label: {

            Text(
                viewModel.hasLearnedToday
                ? "Logged as Learned"
                : "Log as Learned"
            )
            .font(.headline)
            .foregroundStyle(.white)
            .frame(width: 330, height: 330)
            .padding(.vertical, 16)
            .background(
                viewModel.hasLearnedToday
                ? Color.gray.opacity(0.5)
                : Color.orange
            )
            .clipShape(Circle())
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(16)
        .disabled(viewModel.hasLearnedToday)
        

        // MARK: - Freeze Button

        Button {
            viewModel.logFreeze()
        } label: {

            Text("Freeze for a day")
                .font(.headline)
                .foregroundStyle(.white)
                .padding(.horizontal, 48)
                .padding(.vertical, 12)
                .background(.cyan)
                .clipShape(Capsule())
        }
        .frame(maxWidth: .infinity)
        .disabled (viewModel.hasFrozenToday || viewModel.hasLearnedToday || viewModel.remainingFreezes == 0)
        .opacity(
            viewModel.hasFrozenToday || viewModel.hasLearnedToday || viewModel.remainingFreezes == 0 ? 0.2 : 1.0
        )
        
        // MARK: - Freeze Usage Counter

        Text("\(viewModel.frozenDates.count) out of \(viewModel.freezeLimit) Freezes used")
            .font(.caption)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity)
    }
}

// MARK: - SwiftUI Preview

#Preview {
    ActivityView(viewModel: LearningGoalViewModel())
}
