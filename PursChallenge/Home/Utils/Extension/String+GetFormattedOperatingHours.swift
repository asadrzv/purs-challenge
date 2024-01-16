//
//  String+GetFormattedOperatingHours.swift
//  PursChallenge
//
//  Created by Asad Rizvi on 1/11/24.
//

import SwiftUI

extension String {
    
    /// Converts the business operating hour String value to a Date using the user's local date settings.
    /// This assumes '00:00:00' is only used for start of day time and '24:00:00' is only used for end of day time.
    ///
    /// - Returns:
    ///   - The the String formatted as a Date. Returns nil if conversion failed.
    func getFormattedOperatingHours() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss" // Format time string for 24-hour clock
        
        // Handle end of day case of String being midnight but '24:00:00'
        // Assuming '24:00:00' is only used for end of day time
        if self == "24:00:00" {
            let midnightTime = Calendar.current.startOfDay(for: Date())
            return midnightTime
        }
        
        guard let date = dateFormatter.date(from: self) else {
            // Failed to convert String to Date
            return nil
        }
        
        // Get date components for hour/minute/second
        let hour = Calendar.current.component(.hour, from: date)
        let minute = Calendar.current.component(.minute, from: date)
        let second = Calendar.current.component(.second, from: date)
        
        // Add date components to current date
        // This formats all dates to use current day in case we need to compare times
        guard let formattedDate = Calendar.current.date(
            bySettingHour: hour,
            minute: minute,
            second: second,
            of: .now
        ) else {
            return nil
        }
        
        // Return formatted String as Date
        return formattedDate
    }
}

struct String_getDate_Previews: PreviewProvider {
    
    static let dateString: String = "24:00:00"
    static var date: Date = dateString.getFormattedOperatingHours() ?? .now
    
    static var previews: some View {
        ZStack {
            Text(date.formatted(date: .abbreviated, time: .shortened))
        }
    }
}
