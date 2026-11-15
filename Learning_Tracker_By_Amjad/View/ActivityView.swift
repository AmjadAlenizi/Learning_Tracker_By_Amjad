
import SwiftUI

// MARK: - Activity Screen

struct ActivityView: View {
    
    // MARK: - Properties
    
    var viewModel: LearningGoalViewModel
    
    @Environment(\.scenePhase) private var scenePhase
    
    private let calendar = Calendar.current
    
    private var today: Date {
        viewModel.currentDate
    }
    
    private var startOfWeek: Date {
        calendar.dateInterval(
            of: .weekOfYear,
            for: today
        )!.start
    }
    
    private var weekDates: [Date] {
        (0..<7).compactMap { day in
            calendar.date(
                byAdding: .day,
                value: day,
                to: startOfWeek
            )
        }
    }
    
    // MARK: - Date Helpers
    
    private func isLearned(_ day: Date) -> Bool {
        viewModel.learnedDates.contains { learnedDate in
            calendar.isDate(
                learnedDate,
                inSameDayAs: day
            )
        }
    }
    
    private func isFreezed(_ day: Date) -> Bool {
        viewModel.frozenDates.contains { frozenDate in
            calendar.isDate(
                frozenDate,
                inSameDayAs: day
            )
        }
    }
    
    // MARK: - User Interface
    
    var body: some View {
        TimelineView(.periodic(from: .now, by: 60)) { context in
            activityContent
                .onChange(of: context.date) {
                    viewModel.refreshCurrentDate()
                }
        }
        .onAppear {
            viewModel.refreshCurrentDate()
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .active {
                viewModel.refreshCurrentDate()
            }
        }
    }
    
    // MARK: - Activity Content
    
    private var activityContent: some View {
        GeometryReader { geometry in
            
            let isRegularHeight = geometry.size.height >= 700
            
            VStack(alignment: .leading, spacing: 0) {
                
                // MARK: - Header and Calendar
                
                VStack(alignment: .leading, spacing: 16) {
                    
                    HStack {
                        Text("Activity")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        NavigationLink {
                            CalendarView(viewModel: viewModel)
                        } label: {
                            Image(systemName: "calendar")
                                .font(.system(size: 22))
                                .foregroundStyle(.primary)
                                .frame(minWidth: 44, minHeight: 44)
                        }
                        .accessibilityLabel("Calendar")
                        
                        NavigationLink {
                            EditGoalView(viewModel: viewModel)
                        } label: {
                            Image(systemName: "square.and.pencil")
                                .font(.system(size: 22))
                                .foregroundStyle(.primary)
                                .frame(minWidth: 44, minHeight: 44)
                        }
                        .accessibilityLabel("Edit Learning Goal")
                    }
                    .tint(.primary)
                    
                    Text(
                        today,
                        format: .dateTime.month(.wide).year()
                    )
                    .font(.headline)
                    .foregroundStyle(.primary)
                    
                    // MARK: - Weekly Calendar
                    
                    HStack(spacing: 0) {
                        ForEach(weekDates, id: \.self) { day in
                            VStack(spacing: 8) {
                                
                                Text(
                                    day,
                                    format: .dateTime.weekday(.narrow)
                                )
                                .font(.caption)
                                
                                Text(
                                    day,
                                    format: .dateTime.day()
                                )
                                .font(.body)
                                .fontWeight(
                                    calendar.isDateInToday(day)
                                    ? .bold
                                    : .regular
                                )
                                .foregroundStyle(
                                    isLearned(day)
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
                    
                    // MARK: - Learning Statistics
                    
                    HStack(spacing: 16) {
                        
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
                }
                
                Spacer(minLength: isRegularHeight ? 24 : 12)
                
                // MARK: - Goal Status
                
                if viewModel.hasGoalEnded {
                    
                    if viewModel.hasGoalSucceeded {
                        GoalCompletedView(viewModel: viewModel)
                    } else {
                        GoalNotMetView(viewModel: viewModel)
                    }
                    
                } else {
                    
                    // MARK: - Learning Actions
                    
                    VStack(spacing: 0) {
                        
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
                            .frame(
                                width: min(
                                    geometry.size.width - 48,
                                    330
                                ),
                                height: min(
                                    geometry.size.width - 48,
                                    330
                                )
                            )
                            .background(
                                viewModel.hasLearnedToday
                                ? Color.gray.opacity(0.5)
                                : Color.orange
                            )
                            .clipShape(Circle())
                        }
                        .disabled(viewModel.hasLearnedToday)
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 56)
                        
                        // MARK: - Freeze Button
                        
                        Button {
                            viewModel.logFreeze()
                        } label: {
                            Text("Freeze for a day")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .padding(.horizontal, 48)
                                .frame(minHeight: 44)
                                .background(.cyan)
                                .clipShape(Capsule())
                        }
                        .disabled(
                            viewModel.hasFrozenToday ||
                            viewModel.hasLearnedToday ||
                            viewModel.remainingFreezes == 0
                        )
                        .opacity(
                            viewModel.hasFrozenToday ||
                            viewModel.hasLearnedToday ||
                            viewModel.remainingFreezes == 0
                            ? 0.2
                            : 1.0
                        )
                        .padding(.bottom, 16)
                        
                        // MARK: - Freeze Usage
                        
                        Text(
                            "\(viewModel.frozenDates.count) out of " +
                            "\(viewModel.freezeLimit) Freezes used"
                        )
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                }
                
                Spacer(minLength: isRegularHeight ? 16 : 8)
            }
            .padding(.horizontal, 16)
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .top
            )
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - SwiftUI Preview

#Preview {
    NavigationStack {
        ActivityView(
            viewModel: LearningGoalViewModel()
        )
    }
}
