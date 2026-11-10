
import SwiftUI
import Playgrounds

// MARK: - Onboarding Screen
struct ContentView: View {

    // MARK: - State Properties

    // Stores the learning goal entered by the user
    @State private var learningGoal = ""

    // Stores the selected learning duration
    @State private var selectedDuration = "Week"
    
    // Controls navigation to the Activity screen
    @State private var showActivity = false

    // MARK: - User Interface
    var body: some View {
        NavigationStack{
            ZStack {
                
                // MARK: - App Background
                
                // Uses the appropriate background color for Light and Dark Mode
                Color("AppBackground")
                    .ignoresSafeArea()
                
                // MARK: - Main Content
                
                // Arranges the onboarding elements vertically
                VStack(alignment: .leading, spacing: 8) {
                    
                    // MARK: - Welcome Section
                    
                    // Displays the orange flame icon
                    Image(systemName: "flame.fill")
                        .font(.system(size: 48))
                        .foregroundStyle(.orange)
                        .padding(.bottom, 16)
                    
                    // Displays the welcome title
                    Text("Hello Learner")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    // Displays the onboarding description
                    Text("This app will help you learn everyday!")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    // MARK: - Learning Goal Input
                    
                    // Displays the learning goal label
                    Text("I want to learn")
                        .font(.headline)
                    
                    // Allows the user to enter a learning goal
                    TextField("Swift", text: $learningGoal)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background {
                            
                            // Draws an adaptive border around the text field
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color("InputBorder"), lineWidth: 1)
                        }
                    
                    // MARK: - Learning Duration Selection
                    
                    // Displays the duration selection label
                    Text("I want to learn for a")
                        .font(.headline)
                    
                    // Arranges the duration options horizontally
                    HStack(spacing: 12) {
                        
                        // Selects a weekly learning goal
                        Button("Week") {
                            selectedDuration = "Week"
                        }
                        .foregroundStyle(selectedDuration == "Week" ? .orange: .secondary)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity)
                        .background(selectedDuration == "Week" ? Color.orange.opacity(0.15) : Color.clear)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        
                        // Selects a monthly learning goal
                        Button("Month") {
                            selectedDuration = "Month"
                        }
                        .foregroundStyle(selectedDuration == "Month" ? .orange: .secondary)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity)
                        .background(
                            selectedDuration == "Month" ? Color.orange.opacity(0.15)
                            :Color.clear)
                        .clipShape(RoundedRectangle(cornerRadius: 24)
                        )
                        
                        // Selects a yearly learning goal
                        Button("Year") {
                            selectedDuration = "Year"
                        }
                        .foregroundStyle(selectedDuration == "Year" ? .orange: .secondary)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity)
                        .background(
                            selectedDuration == "Year" ? Color.orange.opacity(0.15)
                            :Color.clear)
                        .clipShape(RoundedRectangle(cornerRadius: 24)
                        )
                    }
                    
                    // MARK: - Flexible Spacing
                    // Pushes the Start Learning button toward the bottom
                    Spacer()
                    
                    // MARK: - Start Learning Button
                    
                    //Start the learning journey
                    Button("Start Learning"){
                        if !learningGoal.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            showActivity = true
                        }
                    }
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .padding(.bottom, 8)
                    
                    // MARK: - Onboarding Footer
                    // Reminds the user that the learning goal can be edited later
                    Text("You can edit your desire later")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                
                // MARK: - Layout and Appearance
                
                // Aligns the content to the top-left of the available space
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(maxHeight: .infinity, alignment: .top)
                
                // Adds horizontal spacing around the content
                .padding(.horizontal, 24)
                
                // Uses the appropriate text color for Light and Dark Mode
                .foregroundStyle(.primary)
            } // End of ZStack
            .navigationDestination(isPresented: $showActivity) {
                ActivityView()
            }
        } // End of NavigationStack

    }
}

// MARK: - SwiftUI Preview

// Displays ContentView in the Xcode preview
#Preview {
    ContentView()
}
// MARK: - Playground

#Playground {
    _ = 1 + 2
}
