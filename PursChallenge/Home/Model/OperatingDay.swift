//
//  OperatingDay.swift
//  PursChallenge
//
//  Created by Asad Rizvi on 1/11/24.
//

import Foundation

// MARK: - Operating Day

/// A single day of business operations with a list of all operation hours for that day.
struct OperatingDay: Codable {
    
    /// The day of week the business is open at.
    var day: DayOfWeek
    
    /// The hours a business operates at in a given day.
    var operatingShifts: [OperatingShift]
}

extension OperatingDay {
    
    /// The current shift of the day the users is in.
    var currentShift: OperatingShift? {
        // Exit is the business is closed all day, no shifts if closed
        guard !isClosedAllDay else { return nil }
        
        // Special case for open all day (midnight - midnight)
        // Since both start and end time are the same
        if isOpenAllDay {
            // Get operating shift's start/end hour
            guard let operatingShift = operatingShifts.first else { return nil }
            return operatingShift
        }
        
        let currentDate = Date.now
        // Iterate over all shifts and find the shift the current date falls between
        for operatingShift in operatingShifts {
            let startTime = operatingShift.startTime
            let endTime = operatingShift.endTime
            
            // Shift is late-night and ends on the next day
            if startTime <= currentDate && endTime < startTime {
                return operatingShift
            }
            
            // Not late-night shift
            if startTime <= currentDate && currentDate < endTime {
                return operatingShift
            }
        }
        return nil
    }
    
    /// Returns true if this operating day is today.
    var isToday: Bool {
        return self.day == Date.now.dayOfWeek
    }
    
    /// Returns true if the business is closed all day for this given day.
    var isClosedAllDay: Bool {
        return operatingShifts.isEmpty
    }
    
    /// Returns true if the business is open all day for this given day.
    var isOpenAllDay: Bool {
        // Exit if the business is closed all day, or
        // if the day has multiple operating time periods.
        // Multiple time periods indicate the business is not continuously open all day.
        guard !isClosedAllDay, operatingShifts.count == 1 else { return false }
        
        // Get operating shift's start/end hour
        guard let operatingShift = operatingShifts.first else { return false }
        
        // Return true if the shift starts and ends at midnight (00:00:00 - 24:00:00)
        return operatingShift.startTime.isMidnight && operatingShift.endTime.isMidnight
    }
}

/// Conform OperatingDay to Hashable for use in Lists
extension OperatingDay: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(day)
    }
}

// MARK: - Operating Hours

/// The business operating shift for a single period defined by a start/end time.
struct OperatingShift: Codable {
    
    /// Unique ID for the shift.
    var id: String { UUID().uuidString }
    
    /// The time (UTC) at which the business opens for day.
    var startTime: Date
    
    /// The time (UTC)  at which the business closes for day.
    var endTime: Date
}

/// Conform OperatingHours to Hashable for use in lists.
extension OperatingShift: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(startTime)
        hasher.combine(endTime)
    }
}

// MARK: - Operating Hours To Decode

/// The day/hours the business operates at decoded from the JSON data.
/// This field will be processed and stored into the Business 'operatingDays' field.
struct OperatingDaysToDecode: Codable {
    
    // MARK: - Properties
    
    /// The day of week the business is open at.
    var day: DayOfWeek
    
    /// The time (UTC) at which the business opens for day.
    var startTime: Date
    
    /// The time (UTC)  at which the business closes for day.
    var endTime: Date
}

extension OperatingDaysToDecode {
    
    // MARK: - Encoding/Decoding
    
    /// Coding keys to decode JSON key values to stored field names.
    private enum CodingKeys: String, CodingKey {
        case day = "day_of_week"
        case startTime = "start_local_time"
        case endTime = "end_local_time"
    }
    
    // MARK: - Initializer
    
    /// Initializer used to decode and process all fields from the JSON data.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode the day using the coding key
        self.day = try container.decode(DayOfWeek.self, forKey: .day)

        // Decode the start time using the coding key, then convert the String to a Date
        let startTimeString = try container.decode(String.self, forKey: .startTime)
        self.startTime = startTimeString.getFormattedOperatingHours() ?? .now
        
        // Decode the end time using the coding key, then convert the String to a Date
        let endTimeString = try container.decode(String.self, forKey: .endTime)
        self.endTime = endTimeString.getFormattedOperatingHours() ?? .now
    }
}
