//
//  Achievement.swift
//  Learning_Tracker_By_Amjad
//
//  Created by Amjad on 06/06/1448 AH.
//

import Foundation
struct Achievement: Codable,Identifiable{
    
    let id: UUID 

    let title: String
    
    let duration:LearningDuration
    
    let goalStartDate :Date

}
