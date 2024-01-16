//
//  DataSourceHome.swift
//  PursChallenge
//
//  Created by Asad Rizvi on 1/11/24.
//

import Foundation

final class DataSourceHome: ObservableObject, DataSourceHomeProtocol {
    
    // MARK: - Properties
    
    // MARK: - Initializers
    
    /// Default initializer
    init() {
        
    }
    
    // MARK: - Methods
    
    /// Fetch the Business details from the static business URL.
    ///
    /// - Returns:
    ///   - The Business details fetched from the URL.
    @MainActor
    func fetchBusinessDetails() async -> Business? {
        guard let url = URL(string: ConstantsHome.Strings.BUSINESS_API_URL) else {
            // Failed to get URL
            print("Failed to create business details \(ConstantsHome.Strings.BUSINESS_API_URL)")
            return nil
        }
        
        do {
            // Fetch the JSON data from the URL
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // Decode the JSON data into a Business data model
            let business: Business = try JSONDecoder().decode(Business.self, from: data)
            
            // Successfully loaded business details from API URL
            print("Successfully loaded business details for \(business.name)")
            return business
        } catch {
            // Failed to load business details from API URL
            print("Failed to load business details \(url): \(error)")
            return nil
        }
    }
}
