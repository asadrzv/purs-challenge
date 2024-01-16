//
//  ConstantsHome.swift
//  PursChallenge
//
//  Created by Asad Rizvi on 1/11/24.
//

import Foundation
import SwiftUI

enum ConstantsHome {
    
    enum Strings {
        static let BUSINESS_API_URL = "https://purs-demo-bucket-test.s3.us-west-2.amazonaws.com/location.json"
        
        static let OPEN_24HRS = "Open 24hrs"
        static let CLOSED = "Closed"
                
        enum Accordian {
            enum Title {
                static let OPEN_UNTIL = "Open until"
                static let REOPENS_AT = "reopens at"
                static let OPENS_AGAIN_AT = "Opens again at"
                static let OPENS = "Opens"
            }
            
            static let SUBTITLE = "SEE FULL HOURS"
        }
    }
    
    enum Dimensions {
        static let HORIZONTAL_PADDING = 20.0
        static let VERTICAL_PADDING = 30.0
        
        enum Accordian {
            static let CORNER_RADIUS = 8.0
            
            enum Text {
                static let HORIZONTAL_PADDING = 17.0
                static let VERTICAL_PADDING = 15.0
            }
        }
    }
    
    enum Fonts {
        enum Size {
            static let BUSINESS_TITLE = SwiftUI.Font.custom("FiraSans-Black", size: 54, relativeTo: .title)
            
            enum Accordian {
                static let TITLE = SwiftUI.Font.custom("HindSiliguri-Regular", size: 18, relativeTo: .body)
                static let SUBTITLE = SwiftUI.Font.custom("Chivo-Regular", size: 12, relativeTo: .body)
                static let OPERATING_HOURS = SwiftUI.Font.custom("HindSiliguri-Regular", size: 18, relativeTo: .body)
            }
            
            enum ViewMenuButton {
                static let TEXT = SwiftUI.Font.custom("HindSiliguri-Regular", size: 24, relativeTo: .body)
            }
        }
        
        enum Weight {
            static let BUSINESS_TITLE = SwiftUI.Font.Weight.black
            
            enum Accordian {
                static let TITLE = SwiftUI.Font.Weight.regular
                static let SUBTITLE = SwiftUI.Font.Weight.regular
                static let OPERATING_HOURS_TODAY = SwiftUI.Font.Weight.bold
                static let OPERATING_HOURS_NOT_TODAY = SwiftUI.Font.Weight.regular
            }
            
            enum ViewMenuButton {
                static let TEXT = SwiftUI.Font.Weight.regular
            }
        }
    }
    
    enum Colors {
        static let BUSINESS_TITLE = Color.white
        static let OPERATING_HOURS = Color(red: 0.2, green: 0.2, blue: 0.2)
        
        enum OperationStatus {
            static let OPEN = Color.green
            static let CLOSED = Color.red
            static let CLOSING_WITHIN_HOUR = Color.yellow
        }
        
        enum Accordian {
            static let BACKGROUND = Material.ultraThinMaterial
            static let SHADOW = Color.black.opacity(0.25)
            static let DIVIDER = Color.black.opacity(0.25)
            static let ARROW = Color(red: 0.2, green: 0.2, blue: 0.2)
            
            enum Text {
                static let TITLE = Color(red: 0.2, green: 0.2, blue: 0.2)
                static let SUBTITLE = Color(red: 0.2, green: 0.2, blue: 0.2).opacity(0.31)
            }
        }
        
        enum ViewMenuButton {
            static let TEXT = Color.white
            static let ARROW_UP_1 = Color.white
            static let ARROW_UP_2 = Color.white.opacity(0.5)
        }
    }
    
    enum Images {
        static let BACKGROUND = "background"
        
        static let ARROW_RIGHT = "chevron.right"
        static let ARROW_UP = "chevron.up"
    }
    
    enum Buttons {
        static let VIEW_MENU = "View Menu"
    }
}
