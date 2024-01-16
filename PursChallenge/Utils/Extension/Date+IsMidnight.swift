//
//  Date+IsMidnight.swift
//  PursChallenge
//
//  Created by Asad Rizvi on 1/14/24.
//

import Foundation
import SwiftUI

extension Date {
    
    /// Determines if the current date is midnight.
    ///
    /// - Returns:
    ///   - True if the current date is midnight, false otherwise.
    var isMidnight: Bool {
        let midnight = Calendar.current.startOfDay(for: Date())
        return Calendar.current.isDate(self, equalTo: midnight, toGranularity: .minute)
    }
}

struct Date_IsMidnight_Previews: PreviewProvider {
    static let currentDate: Date = .now
    
    static var previews: some View {
        ZStack {
            Text("Is it midnight: \(currentDate.isMidnight.description)")
        }
    }
}
