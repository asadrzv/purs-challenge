//
//  OperationStatus.swift
//  PursChallenge
//
//  Created by Asad Rizvi on 1/15/24.
//

import Foundation
import SwiftUI

/// The operation status of the business at this current moment.
/// A business can either be open, closing within the hour, or closed.
enum OperationStatus: String, Codable, CaseIterable, CustomStringConvertible  {
    case open = "Open"
    case closingWithinHour = "Closing within the hour"
    case closed = "Closed"
    
    /// Description for OperationStatus value
    var description: String {
        self.rawValue
    }
    
    /// The color associated with the operation status
    var color: Color {
        switch self {
        case .open:
            return ConstantsHome.Colors.OperationStatus.OPEN
        case .closingWithinHour:
            return ConstantsHome.Colors.OperationStatus.CLOSING_WITHIN_HOUR
        case .closed:
            return ConstantsHome.Colors.OperationStatus.CLOSED
        }
    }
}
