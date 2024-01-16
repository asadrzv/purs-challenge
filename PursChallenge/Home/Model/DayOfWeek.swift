//
//  DayOfWeek.swift
//  PursChallenge
//
//  Created by Asad Rizvi on 1/11/24.
//

import Foundation

/// The days of the week.
enum DayOfWeek: String, Codable, CaseIterable, CustomStringConvertible {
    case monday = "MON"
    case tuesday = "TUE"
    case wednesday = "WED"
    case thursday = "THU"
    case friday = "FRI"
    case saturday = "SAT"
    case sunday = "SUN"
    
    /// Description for DayOfWeek value.
    var description: String {
        switch self {
        case .monday:
            return "Monday"
        case .tuesday:
            return "Tuesday"
        case .wednesday:
            return "Wednesday"
        case .thursday:
            return "Thursday"
        case .friday:
            return "Friday"
        case .saturday:
            return "Saturday"
        case .sunday:
            return "Sunday"
        }
    }
    
    /// The number associated with the DayOfWeek value used to order the days
    var order: Int {
        switch self {
        case .monday:
            return 0
        case .tuesday:
            return 1
        case .wednesday:
            return 2
        case .thursday:
            return 3
        case .friday:
            return 4
        case .saturday:
            return 5
        case .sunday:
            return 6
        }
    }
}
