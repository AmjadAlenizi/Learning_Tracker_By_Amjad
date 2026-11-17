
//
//  CalendarView.swift
//  Learning_Tracker_By_Amjad
//
//  Created by Amjad on 05/06/1448 AH.
//

import SwiftUI

// MARK: - Calendar Screen

struct CalendarView: View {
    
    // MARK: - ViewModel
    
    var viewModel: LearningGoalViewModel
    
    // MARK: - Colors (Matching ActivityView)
    
    private let todayBackground = Color.orange.opacity(0.2)
    private let learnedBackground = Color.orange.opacity(0.2)
    private let frozenBackground = Color.cyan.opacity(0.2)
    
    // MARK: - Calendar Properties
    
    private let calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 1
        calendar.locale = Locale(identifier: "en_US")
        return calendar
    }()
    
    private let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.calendar = Calendar(identifier: .gregorian)
        return formatter
    }()
    
    private let currentYear = Calendar(identifier: .gregorian)
        .component(.year, from: Date.now)
    
    // MARK: - Date Helpers
    
    private func firstDayOfMonth(month: Int) -> Date? {
        let components = DateComponents(
            year: currentYear,
            month: month,
            day: 1
        )
        return calendar.date(from: components)
    }
    
    private func daysInMonth(month: Int) -> Int {
        guard let firstDay = firstDayOfMonth(month: month),
              let range = calendar.range(
                of: .day,
                in: .month,
                for: firstDay
              ) else {
            return 0
        }
        
        return range.count
    }
    
    private func leadingEmptyDays(month: Int) -> Int {
        guard let firstDay = firstDayOfMonth(month: month) else {
            return 0
        }
        
        let weekday = calendar.component(
            .weekday,
            from: firstDay
        )
        
        return weekday - 1
    }
    
    // MARK: - Calendar Grid
    
    private let columns: [GridItem] = Array(
        repeating: GridItem(.flexible(), spacing: 0),
        count: 7
    )
    
    // MARK: - Day Appearance
    
    private func dayBackground(
        isLearned: Bool,
        isFrozen: Bool,
        isToday: Bool
    ) -> Color {
        if isLearned {
            return learnedBackground
        } else if isFrozen {
            return frozenBackground
        } else if isToday {
            return todayBackground
        } else {
            return .clear
        }
    }
    
    private func dayTextColor(
        isLearned: Bool,
        isFrozen: Bool,
        isToday: Bool
    ) -> Color {
        if isLearned {
            return .orange
        } else if isFrozen {
            return .cyan
        } else if isToday {
            return .orange
        } else {
            return .primary
        }
    }
    
    // MARK: - Day View
    
    private func dayView(
        day: Int,
        month: Int
    ) -> some View {
        
        let components = DateComponents(
            year: currentYear,
            month: month,
            day: day
        )
        
        let date = calendar.date(from: components)
        
        let isToday = date.map {
            calendar.isDate($0, inSameDayAs: Date.now)
        } ?? false
        
        let isLearned = date.map { date in
            viewModel.allLearnedDates.contains {
                calendar.isDate($0, inSameDayAs: date)
            }
        } ?? false
        
        let isFrozen = date.map { date in
            viewModel.allFrozenDates.contains {
                calendar.isDate($0, inSameDayAs: date)
            }
        } ?? false
        
        return Text("\(day)")
            .font(.body)
            .fontWeight(isToday ? .bold : .regular)
            .foregroundStyle(
                dayTextColor(
                    isLearned: isLearned,
                    isFrozen: isFrozen,
                    isToday: isToday
                )
            )
            .frame(width: 36, height: 36)
            .background {
                Circle()
                    .fill(
                        dayBackground(
                            isLearned: isLearned,
                            isFrozen: isFrozen,
                            isToday: isToday
                        )
                    )
            }
            .frame(maxWidth: .infinity)
    }
    
    // MARK: - User Interface
    
    var body: some View {
        
        ScrollViewReader { proxy in
            
            ScrollView(.vertical) {
                
                LazyVStack(alignment: .leading, spacing: 24) {
                    
                    // MARK: - Months
                    
                    ForEach(1...12, id: \.self) { month in
                        
                        VStack(alignment: .leading, spacing: 16) {
                            
                            // MARK: - Month Header
                            
                            Text(
                                "\(monthFormatter.monthSymbols[month - 1]) \(currentYear)"
                            )
                            .font(.headline)
                            .foregroundStyle(.primary)
                            
                            // MARK: - Weekday Headers
                            
                            HStack(spacing: 0) {
                                
                                ForEach(
                                    calendar.shortStandaloneWeekdaySymbols.indices,
                                    id: \.self
                                ) { index in
                                    
                                    Text(
                                        calendar.shortStandaloneWeekdaySymbols[index]
                                            .uppercased()
                                    )
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .frame(maxWidth: .infinity)
                                }
                            }
                            
                            // MARK: - Calendar Days
                            
                            LazyVGrid(
                                columns: columns,
                                spacing: 12
                            ) {
                                
                                // Empty Days
                                
                                ForEach(
                                    0..<leadingEmptyDays(month: month),
                                    id: \.self
                                ) { _ in
                                    
                                    Color.clear
                                        .frame(height: 36)
                                }
                                
                                // Actual Days
                                
                                ForEach(
                                    1...daysInMonth(month: month),
                                    id: \.self
                                ) { day in
                                    
                                    dayView(
                                        day: day,
                                        month: month
                                    )
                                }
                            }
                        }
                        .id(month)
                        
                        Divider()
                    }
                }
                .padding()
            }
            .onAppear {
                let currentMonth = calendar.component(
                    .month,
                    from: Date.now
                )
                
                proxy.scrollTo(
                    currentMonth,
                    anchor: .top
                )
            }
        }
    }
}

// MARK: - SwiftUI Preview

#Preview {
    CalendarView(viewModel: LearningGoalViewModel())
        .preferredColorScheme(.dark)
}
