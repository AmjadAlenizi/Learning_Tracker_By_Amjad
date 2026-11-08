//
//  ActivityView.swift
//  MyApp
//
//  Created by Amjad on 28/05/1448 AH.
//

import SwiftUI

struct ActivityView: View {
    
    // MARK: - Calendar Properties
    // Uses the device's current calendar
    private let calendar = Calendar.current

    // Gets today's date
    private let today = Date.now
    
    // MARK: - Start of Week
    // Finds the first day of the current week
    private var startOfWeek: Date {
        calendar.dateInterval(of: .weekOfYear, for: today)!.start
    }
    
    // MARK: - Week Dates
    // Generates the seven dates of the current week
    private var weekDates: [Date] {
        (0..<7).compactMap { day in
            calendar.date(byAdding: .day, value: day, to: startOfWeek)
        }
    }
    
    var body: some View {
        // MARK: - Main Activity Content
        // Arranges the activity elements vertically
        VStack(alignment: .leading, spacing: 16) {
            // MARK: - Activity Header
            // Displays the screen title
            HStack{
                Text("Activity")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
                // MARK: - Calendar Button
                // Opens the learning history calendar
                Button {
                    // Navigation will be added later
                } label: {
                    Image(systemName: "calendar")
                        .font(.system(size: 22))
                        .foregroundStyle(.primary)
                        .tint(.primary)
                }
                // MARK: - Edit Goal Button
                // Opens the learning goal editing screen
                Button {
                    // Navigation will be added later
                } label: {
                    Image(systemName: "square.and.pencil")
                        .font(.system(size: 22))
                }
                .tint(.primary)
            }
            // MARK: - Weekly Calendar
            // Displays the current month and year
            Text(Date.now, format: .dateTime.month(.wide).year())
                .font(.headline)
                .foregroundStyle(.primary)
            
            // MARK: - Week Days
            // Arranges the seven days horizontally
            HStack(spacing: 0) {
                ForEach(weekDates, id: \.self) { day in
                    VStack(spacing: 8) {
                        Text(day, format: .dateTime.weekday(.narrow))
                            .font(.caption)

                        Text(day, format: .dateTime.day())
                            .font(.body)
                            .fontWeight(calendar.isDateInToday(day) ? .bold: .regular)
                        
                            .foregroundStyle(calendar.isDateInToday(day) ? .primary : .primary)
                            .frame(width: 36,height: 36)
                        
                        // Highlights today's date
                        .background {
                            Circle()
                                .fill(calendar.isDateInToday(day) ? Color.orange : Color.clear)
                        }
                        
                    }
                    .frame(maxWidth: .infinity)
                }

            }
            .padding(.top, 8)
        }
        .frame(maxWidth: .infinity,
               maxHeight: .infinity,
               alignment: .topLeading)
        .padding(.top,24)
        .padding(.horizontal, 24)
        
        // MARK: - Learning Statistics
        // Arranges learned and frozen counters horizontally
        HStack(spacing: 16) {

        }
    }
}

#Preview {
    ActivityView()
}
