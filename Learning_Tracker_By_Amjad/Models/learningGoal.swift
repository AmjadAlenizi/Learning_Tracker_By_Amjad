//
//  learningGoal.swift
//  Learning_Tracker_By_Amjad
//
//  Created by Amjad on 30/05/1448 AH.
//

import Foundation

struct LearningGoal {
    var title: String = ""
    var duration: LearningDuration = .week
    var startDate: Date = Date.now
}
enum LearningDuration {
    case week
    case month
    case year
}

func testGoal() {
    var myGoal = LearningGoal()
    myGoal.title = "Swift"
    print(myGoal.title)
}

