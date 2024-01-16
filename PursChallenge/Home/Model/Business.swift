//
//  Business.swift
//  PursChallenge
//
//  Created by Asad Rizvi on 1/11/24.
//

import Foundation

// MARK: - Business

/// A business with a location name and list of operating hours
struct Business: Identifiable, Codable {
    
    // MARK: - Properties
    
    /// The ID associated with the business.
    var id: String = UUID().uuidString
    
    /// The name of the business.
    var name: String
    
    /// The list of day/hours the business operates at.
    /// This list of days is initialized to have days Mon-Sun (in that order) with empty lists for OperatingShifts.
    var operatingDays: [OperatingDay] = [OperatingDay]()
    
    /// The day/hours the business operates at decoded from the JSON data.
    /// This field will be processed and stored into the 'operatingDays' field.
    /// Each duplicate day's hours will be combined into a single day with a list of hours.
    private var operatingDaysToDecode: [OperatingDaysToDecode] = [OperatingDaysToDecode]()
}

extension Business {
    
    // MARK: - Initializer
    
    /// Create a Business with a given name and list of operating days each with a list of shifts.
    ///
    /// - Parameters:
    ///   - name: The name of the business.
    ///   - operatingDays: Each day of the week (Mon-Sun) with a list of shifts the business is open for.
    init(name: String, operatingDays: [OperatingDay]) {
        self.name = name
        self.operatingDays = operatingDays
    }
}

extension Business {
    
    // MARK: - Encoding/Decoding
    
    /// Coding keys to decode JSON key values to stored field names.
    private enum CodingKeys: String, CodingKey {
        case name = "location_name"
        case operatingDaysToDecode = "hours"
    }
        
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode the business name using the coding key
        self.name = try container.decode(String.self, forKey: .name)
        // Decode the business operating hours for all days using the coding key
        self.operatingDaysToDecode = try container.decode([OperatingDaysToDecode].self, forKey: .operatingDaysToDecode)
                
        // Initialize list of operating days each with a list of empty shifts
        self.operatingDays = DayOfWeek.allCases.map {
           OperatingDay(day: $0, operatingShifts: [])
        }
        
        // Process all decoded operating days/hours and create a new list of OperatingDay
        // to combine days with multiple operating times
        self.operatingDaysToDecode.forEach {
            self.addOperatingShift(on: $0.day, from: $0.startTime, to: $0.endTime)
        }
    }
}

extension Business {
    
    /// Creates a new shift on the given day between the given start and end times.
    ///
    /// - Parameters:
    ///   - day: The day of the week to add the shift at.
    ///   - startTime: The time at which the shift starts.
    ///   - endTime: The time at which the shift ends.
    mutating func addOperatingShift(on day: DayOfWeek, from startTime: Date, to endTime: Date) {
        let shift = OperatingShift(startTime: startTime, endTime: endTime)
        self.operatingDays[day.order].operatingShifts.append(shift)
    }
}

extension Business {
    
    /// The operating status (open / closed / closing within the hour) of the business
    var operatingStatus: OperationStatus {
        if isClosed {
            return .closed
        } else if isOpen {
            return .open
        } else if isClosingWithinHour {
            return .closingWithinHour
        } else {
            return .closed
        }
    }
    
    /// Returns true if the business is currently closed
    var isClosed: Bool {
        let currentDate = Date.now
        let operatingDay = operatingDays[Date.now.dayOfWeek.order]
        
        // Exit and return true if closed all day today
        if operatingDay.isClosedAllDay {
            return true
        }
        // Exit and return false if open all day today
        else if operatingDay.isOpenAllDay {
            return false
        }
        // Check if current time falls between a operating shift
        else {
            for operatingShift in operatingDay.operatingShifts {
                if operatingShift.startTime <= currentDate && currentDate < operatingShift.endTime {
                    return false
                }
            }
            return true
        }
    }
    
    /// Returns true if the business is closing within the hour
    var isClosingWithinHour: Bool {
        let currentDate = Date.now
        let operatingDay = operatingDays[currentDate.dayOfWeek.order]
        
        // Exit and return false if closed all day today
        if operatingDay.isClosedAllDay {
            return true
        }
        // Exit and return true if open all day today
        else if operatingDay.isOpenAllDay{
            return false
        }
        else {
            for operatingShift in operatingDay.operatingShifts {
                
                // Find the current operating shift
                if operatingShift.startTime <= currentDate && currentDate < operatingShift.endTime {
                    
                    // Check if the current shift ends within an hour of the current time
                    let timeDifference = abs(currentDate.timeIntervalSince(operatingShift.endTime))
                    if timeDifference <= (60 * 60) {
                        return true
                    }
                }
            }
            return false
        }
    }
    
    /// Returns true if the business is currently open
    var isOpen: Bool {
        let currentDate = Date.now
        let operatingDay = operatingDays[currentDate.dayOfWeek.order]
        
        // Exit and return false if closed all day today
        if operatingDay.isClosedAllDay {
            return false
        }
        // Exit and return true if open all day today
        else if operatingDay.isOpenAllDay{
            return true
        }
        // Check if current time falls between a operating shift
        else {
            for operatingShift in operatingDay.operatingShifts {
                if operatingShift.startTime <= currentDate && currentDate < operatingShift.endTime {
                    return true
                }
            }
            return false
        }
    }
}
