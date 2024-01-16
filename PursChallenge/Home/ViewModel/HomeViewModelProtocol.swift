//
//  HomeViewModelProtocol.swift
//  PursChallenge
//
//  Created by Asad Rizvi on 1/11/24.
//

import Foundation

protocol HomeViewModelProtocol {
    
    // MARK: - Properties
    
    // MARK: Business Details
    
    /// The business details fetched from the data
    var business: Business? { get set }
    
    /// The name of the business
    var businessName: String { get }
    
    /// The list of operating days
    var businessOperatingDays: [OperatingDay] { get }
    
    /// The operating status of the business (open / closed / closing within the hour)
    var businessOperatingStatus: OperationStatus { get }
    
    // MARK: - Operating Shifts Accordian
    
    /// The title text displayed on the accodian label indicating when the business is open util or when it opens again
    var accordianTitleText: String { get }
    
    // MARK: View Loading State

    /// View loading state
    var viewState: ViewState { get }
    
    // MARK: - Methods
    
    // MARK: Load View State
    
    /// Loads all data used by the view
    func load() async
}
