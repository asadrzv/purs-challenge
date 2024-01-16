//
//  Date+DayOfWeek.swift
//  PursChallenge
//
//  Created by Asad Rizvi on 1/11/24.
//

import SwiftUI

extension Date {
    
    /// The DayOfWeek value for the current day.
    var dayOfWeek: DayOfWeek {
        // Get the value of the current day with Sunday (1) - Saturday (7)
        let dayValue = Calendar.current.dateComponents([.weekday], from: self).weekday ?? 1
        
        // Subtract two to match DayOfWeek index value
        let dayIndex = dayValue - 2
        
        return DayOfWeek.allCases[dayIndex]
    }
}

struct Date_DayOfWeek_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Text(Date.now.dayOfWeek.description)
        }
    }
}
