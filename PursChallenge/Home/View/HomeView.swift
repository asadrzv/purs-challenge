//
//  HomeView.swift
//  PursChallenge
//
//  Created by Asad Rizvi on 1/11/24.
//

import SwiftUI

struct HomeView: View {
    
    // MARK: - Properties
    
    /// Home view model to handle view changes
    @StateObject var homeViewModel = HomeViewModel(DataSourceHome())
    
    /// Toggle to show business menu
    @State private var isMenuShown = false
    
    // MARK: - Initializers
    
    /// Default initializer
    init() {
        // Add any future setup here...
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            switch homeViewModel.viewState {
                
            // View when done loading
            case .idle:
                loadedView
                
            // View when loading
            case .loading:
                ProgressView()
            }
        }
        .task {
            // Load all data when view appears
            await homeViewModel.load()
        }
        .refreshable {
            // Load all data when view is pulled down to refresh
            await homeViewModel.load()
        }
    }
    
    /// The view when it has loaded
    private var loadedView: some View {
        ZStack {
            backgroundImage
            
            VStack(spacing: 20) {
                businessTitle
                operatingShiftsAccordian
                
                viewMenuButton
                    .frame(maxHeight: .infinity, alignment: .bottom)
            }
            .padding(.horizontal, ConstantsHome.Dimensions.HORIZONTAL_PADDING)
            .padding(.vertical, ConstantsHome.Dimensions.VERTICAL_PADDING)
        }
    }
    
    // MARK: - Components
    
    /// The business title displayed at the top of the screen
    private var businessTitle: some View {
        HStack {
            Text(homeViewModel.businessName)
                .font(ConstantsHome.Fonts.Size.BUSINESS_TITLE)
                .fontWeight(ConstantsHome.Fonts.Weight.BUSINESS_TITLE)
                .foregroundColor(ConstantsHome.Colors.BUSINESS_TITLE)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
        }
    }
    
    /// The business operating shifts accordian (drop down) list
    private var operatingShiftsAccordian: some View {
        OperatingShiftsAccordian(
            operatingDays: homeViewModel.businessOperatingDays,
            operationStatus: homeViewModel.businessOperatingStatus,
            accordianTitleText: homeViewModel.accordianTitleText
        )
    }
    
    /// View menu button shows business menu when tapped
    private var viewMenuButton: some View {
        VStack(spacing: 5) {
            Image(systemName: ConstantsHome.Images.ARROW_UP)
                .font(ConstantsHome.Fonts.Size.Accordian.TITLE)
                .foregroundColor(ConstantsHome.Colors.ViewMenuButton.ARROW_UP_2)
            
            Image(systemName: ConstantsHome.Images.ARROW_UP)
                .font(ConstantsHome.Fonts.Size.Accordian.TITLE)
                .foregroundColor(ConstantsHome.Colors.ViewMenuButton.ARROW_UP_1)
            
            Text(ConstantsHome.Buttons.VIEW_MENU)
                .font(ConstantsHome.Fonts.Size.ViewMenuButton.TEXT)
                .fontWeight(ConstantsHome.Fonts.Weight.ViewMenuButton.TEXT)
                .foregroundColor(ConstantsHome.Colors.ViewMenuButton.TEXT)
            
                // Swip-up on text to open business menu
                .gesture(DragGesture().onEnded { gesture in
                    isMenuShown = true
                })
                .sheet(isPresented: $isMenuShown) {
                    MenuView()
                }
        }
    }
    
    /// The business image displayed in the background
    private var backgroundImage: some View {
        Image(ConstantsHome.Images.BACKGROUND)
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
