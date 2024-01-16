//
//  MenuView.swift
//  PursChallenge
//
//  Created by Asad Rizvi on 1/11/24.
//

import SwiftUI

// TODO: - Move Menu to separate top-level folder like Home folder

struct MenuView: View {
    
    // MARK: - Properties
    
    
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            backgroundImage
            
            VStack {
                menuTitle
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
    
    // MARK: - Components
    
    /// The menu title displayed
    private var menuTitle: some View {
        Text("Menu Coming Soon...")
            .font(ConstantsHome.Fonts.Size.BUSINESS_TITLE)
            .fontWeight(ConstantsHome.Fonts.Weight.BUSINESS_TITLE)
            .foregroundColor(ConstantsHome.Colors.BUSINESS_TITLE)
            .multilineTextAlignment(.leading)
    }
    
    /// The business image displayed in the background
    private var backgroundImage: some View {
        Image(ConstantsHome.Images.BACKGROUND)
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
            .blur(radius: 10)
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
