//
//  HomeViewModel.swift
//  PursChallenge
//
//  Created by Asad Rizvi on 1/11/24.
//

import Foundation

/// View states to switch between
enum ViewState {
    case idle
    case loading
}

final class HomeViewModel: ObservableObject, HomeViewModelProtocol {
    
    // MARK: - Properties
    
    // MARK: Network
    
    /// The Firebase network source
    private let homeDataSource: DataSourceHomeProtocol
    
    // MARK: Business Details
    
    /// The business details fetched from the data
    @Published var business: Business? = .none
    
    /// The name of the business
    var businessName: String {
        business?.name ?? "Business"
    }
    
    /// The list of operating days
    var businessOperatingDays: [OperatingDay] {
        getFormattedOperatingDays()
    }
    
    /// The operating status of the business (open / closed / closing within the hour)
    var businessOperatingStatus: OperationStatus {
        business?.operatingStatus ?? .closed
    }
    
    // MARK: - Operating Shifts Accodian
    
    /// The title text displayed on the accodian label indicating when the business is open util or when it opens again
    var accordianTitleText: String {
        getFormattedAccordianTitleText()
    }
    
    // MARK: View Loading State
    
    /// View loading state
    @Published private(set) var viewState: ViewState = .idle
    
    // MARK: - Initializers
    
    init(_ homeDataSource: DataSourceHomeProtocol) {
        self.homeDataSource = homeDataSource
    }
    
    // MARK: - Methods
        
    // MARK: Load View State
    
    /// Loads all data used by the view
    @MainActor
    func load() async {
        self.setViewState(.loading)
        
        // Fetch all business details from the Business API URL
        await self.business = homeDataSource.fetchBusinessDetails()
        
        self.setViewState(.idle)
    }
        
    /// Sets the view state to the specified state
    ///
    /// - Parameters:
    ///   - viewState: The view state to set the view to.
    private func setViewState(_ viewState: ViewState) {
        self.viewState = viewState
    }
    
    // MARK: - Helpers
    
    // MARK: - Format Operating Days
    
    /// Get the business operating days formatted for late-night shifts.
    ///
    /// - Returns:
    ///   - The business operating days with any late-night shifts added.
    private func getFormattedOperatingDays() -> [OperatingDay] {
        guard let operatingDays = business?.operatingDays else { return [] }
        let formattedForLateNights = getOperatingDaysWithLateNightDays(for: operatingDays)
        let removedDuplicates = getOperatingDaysWithoutDuplicates(for: formattedForLateNights)

        return removedDuplicates
    }
    
    /// Iterate over the entire list of operating days and check for any late night shifts.
    /// Combine late night shifts that pass over two days into a single shift to be displayed.
    /// If a late night shift was added, there will be two instances of a day.
    ///  - The first instance of an OperatingDay is the one we need to keep.
    ///  - The second instance needs to be removed (handled in a separate function).
    ///
    /// - Parameters:
    ///   - operatingDays: The original list of operating days taken directly from the Business.
    ///
    /// - Returns:
    ///   - The new list of operating days with an additional day with the correct late-night shift.
    private func getOperatingDaysWithLateNightDays(for operatingDays: [OperatingDay]) -> [OperatingDay] {
        var formattedForLateNights = [OperatingDay]()
        
        // Iterate over all days and process a day's hours that end on the next day
        for currentDay in operatingDays {
            
            // Move to next day if the business is closed this current day
            guard !currentDay.isClosedAllDay else {
                formattedForLateNights.append(currentDay)
                continue
            }
            
            // Get last time periods end time
            guard
                let currentDayFinalShift = currentDay.operatingShifts.last,
                currentDayFinalShift.endTime.isMidnight
            else {
                formattedForLateNights.append(currentDay)
                continue
            }
            
            // Get index for next day in week
            // Wrap back around for transition from Sunday to Monday
            let nextDayIndex = (currentDay.day.order + 1) % 7
            
            let nextDay = operatingDays[nextDayIndex]
            guard
                !nextDay.isClosedAllDay,
                let nextDayOpeningShift = nextDay.operatingShifts.first,
                nextDayOpeningShift.startTime.isMidnight
            else {
                formattedForLateNights.append(currentDay)
                continue
            }
            
            // At this point, both dates are midnight, thus the current day's last shift
            // ends when the next day's first shift ends.
            
            // Create a new late night shift for this to add
            let lateNightShift = OperatingShift(startTime: currentDayFinalShift.startTime, endTime: nextDayOpeningShift.endTime)
            var currentDayShifts = currentDay.operatingShifts
            currentDayShifts.removeLast() // Remove the old last shift
            currentDayShifts.append(lateNightShift) // Add the new late night shift
            
            // Add the new day with the new late night shift
            let lateNightDay = OperatingDay(day: currentDay.day, operatingShifts: currentDayShifts)
            formattedForLateNights.append(lateNightDay)
            
            // Remove the first shift from the next day
            var nextDayShifts = nextDay.operatingShifts
            nextDayShifts.removeFirst() // Remove the old first shift
            
            // Add the next day with the opening shift removed
            let nextDayUpdatedDay = OperatingDay(day: nextDay.day, operatingShifts: nextDayShifts)
            formattedForLateNights.append(nextDayUpdatedDay)
            
            // If this point is reached, the array with the new late night day
            // will contain two instances the late night day (one with the late night shift and one without it).
        }
        
        return formattedForLateNights
    }
    
    /// Iterate over all days and remove the old days that had late night shifts.
    /// The first instance of an OperatingDay is the one we need to keep.
    /// The second instance needs to be removed.
    ///
    /// - Parameters:
    ///   - formattedForLateNights: The original list with late night days added.
    ///
    /// - Returns:
    ///   - The final operating list without old days (the second instace is removed).
    private func getOperatingDaysWithoutDuplicates(for formattedForLateNights: [OperatingDay]) -> [OperatingDay] {
        var removedOldDays = formattedForLateNights
        
        for index in 1..<formattedForLateNights.count {
            let previousDayIndex = index - 1
            let currentDay = formattedForLateNights[index]
            let previousDay = formattedForLateNights[previousDayIndex]

            // If the current day is the same as the previous day,
            // Remove the current day (first instance).
            if currentDay.day == previousDay.day {
                removedOldDays.remove(at: index)
            }
        }
        return removedOldDays
    }
    
    /// Gets the formatted text displayed as the operating shifts accordian title.
    /// If the business is open -> Open until {time}
    /// If the business is open, and there is another shift today -> Open until {time}, reopens at {time}
    /// If the business is closed, and the next shift is today -> Opens again at until {time}
    /// If the business is closed, and the next shift is not today -> Opens {day} {time}
    ///
    /// - Returns:
    ///   - The correctly formatted text to display
    private func getFormattedAccordianTitleText() -> String {
        guard let business = business else { return "Closed" }
        
        var result = ""
        
        let currentDate = Date.now
        let currentDay = businessOperatingDays[currentDate.dayOfWeek.order]
        let currentShifts = currentDay.operatingShifts
        
        // Business is open
        if business.isOpen {
            guard let currentShift = currentDay.currentShift else { return "Error, reload!" }
            
            let endTime = currentShift.endTime
            let formattedEndTime = endTime.formatted(.dateTime.hour())
            result = ConstantsHome.Strings.Accordian.Title.OPEN_UNTIL + " " + formattedEndTime
            
            // Business open all day
            // Handle case where start and end time are the same
            if currentDay.isOpenAllDay {
                result = ConstantsHome.Strings.Accordian.Title.OPEN_UNTIL + " " + formattedEndTime
            }
        }
        // Business is closed
        else {
            // Create a new list of shifts that start after the current time
            let nextShifts = currentShifts.filter { currentDate < $0.startTime }
            
            // There are more shifts today
            // get next shift start time
            if !nextShifts.isEmpty {
                // Get the shift that starts the earliest among the list of next shifts
                guard let nextShift = nextShifts.min(by: { $0.startTime < $1.startTime} ) else { return "Error, reload!" }
                let startTime = nextShift.startTime
                let formattedStartTime = startTime.formatted(.dateTime.hour())
                result = ConstantsHome.Strings.Accordian.Title.OPENS_AGAIN_AT + " " + formattedStartTime
            }
            // No more shifts today or closed all day
            // Go to next day and get first shift start time
            else {
                var index = (currentDate.dayOfWeek.order + 1) % 7
                var nextDay = businessOperatingDays[index]
                
                // Loop through all days until the first open business shift is found
                // Handles case when multiple days are closed in a row
                // TODO: Need to handle case where business closed all week
                while nextDay.isClosedAllDay {
                    index = (index + 1) % 7
                    nextDay = businessOperatingDays[index]
                }
                
                let nextOpenShift = nextDay.operatingShifts[0]
                let startTime = nextOpenShift.startTime
                let formattedStartTime = startTime.formatted(.dateTime.hour())
                result = ConstantsHome.Strings.Accordian.Title.OPENS + " " + nextDay.day.description + " " + formattedStartTime
            }
        }
        
        return result
    }
}
