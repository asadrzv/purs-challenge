//
//  DataSourceHomeProtocol.swift
//  PursChallenge
//
//  Created by Asad Rizvi on 1/11/24.
//

import Foundation

protocol DataSourceHomeProtocol {
    
    // MARK: - Methods
    
    /// Fetch the Business details from the static business URL.
    ///
    /// - Returns:
    ///   - The Business details fetched from the URL.
    @MainActor
    func fetchBusinessDetails() async -> Business?
}
