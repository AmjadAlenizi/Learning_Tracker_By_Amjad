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
                        
                            .foregroundStyle(calendar.isDateInToday(day) ? .primary: .primary)
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
            .padding(.horizontal, 16)
        
        // MARK: - Learning Statistics
        // Arranges learned and frozen counters horizontally
        HStack(spacing: 16) {
            
            // MARK: - Learned Counter
            // Displays the number of learned days
            VStack(spacing: 4) {
                Image(systemName: "flame.fill")
                    .foregroundStyle(.orange)
                    .font(.title3)
                Text("0")
                    .font(.title)
                    .fontWeight(.bold)

                Text("Learned")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .glassEffect(.regular,in: RoundedRectangle(cornerRadius: 48))
            
// MARK: - Frozen Counter
// Displays the number of frozen days
            VStack(spacing: 4) {
                Image(systemName:"snowflake")
                    .foregroundStyle(.cyan)
                    .font(.title3)
                Text("0")
                    .font(.title)
                    .fontWeight(.bold)

                Text("Frozen")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .glassEffect(.regular,
                in: RoundedRectangle(cornerRadius: 48))
            
        }
// MARK: - Log as Learned Button
//Allows user to record today's learning activity
        Button {
//Learning logic will be added later
        }label: {
            Text("Log as Learned")
                .font(.headline)
                .foregroundStyle(.white)
                .frame(width: 330,height: 330)
                .padding(.vertical, 16)
                .background(.orange)
                .clipShape(Circle())
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(16)
// MARK: - Freeze Button
// Allows the user to freeze their learning streak for a day
        Button {
            // Freeze logic will be added later
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
// MARK: - Freeze Usage Counter
// Displays how many freezes have been used
        Text("0 out of 2 Freezes used")
            .font(.caption)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity)
    }
}

#Preview {
    ActivityView()
}
