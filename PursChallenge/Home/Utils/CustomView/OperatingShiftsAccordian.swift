//
//  OperatingShiftsAccordian.swift
//  PursChallenge
//
//  Created by Asad Rizvi on 1/15/24.
//

import SwiftUI

struct OperatingShiftsAccordian: View {
    
    // MARK: - Properties
    
    /// List of operating shifts to display in the accordian
    let operatingDays: [OperatingDay]
    
    /// The business operation status (open / closed / closing within the hour)
    let operationStatus: OperationStatus
    
    /// The title text for the operating hours accordian indicating when the business
    /// is open until or when it opens again
    let accordianTitleText: String
    
    /// Toggle to expand / collapse the accordian
    @State private var isExpanded: Bool = false
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            accordianLabel
            
            // Expand the accordian to show operating shifts
            if isExpanded {
                accordianExpandedList
            }
        }
        .padding(.horizontal, ConstantsHome.Dimensions.Accordian.Text.HORIZONTAL_PADDING)
        .padding(.vertical, ConstantsHome.Dimensions.Accordian.Text.VERTICAL_PADDING)
        .background(ConstantsHome.Colors.Accordian.BACKGROUND)
        .cornerRadius(ConstantsHome.Dimensions.Accordian.CORNER_RADIUS)
        .shadow(color: ConstantsHome.Colors.Accordian.SHADOW, radius: 5.1, x: 0, y: 4)
    }
    
    // MARK: - Components
    
    /// Expanded accordian list showing all business operating shifts
    private var accordianExpandedList: some View {
        VStack {
            Divider()
                .background(ConstantsHome.Colors.Accordian.DIVIDER)
            
            ForEach(operatingDays, id: \.self) { operatingDay in
                OperatingShiftsAccordianRow(operatingDay: operatingDay)
            }
        }
        // Set accordian to take 0.5 sec to expand/collapse
        .animation(.linear(duration: 0.5))
    }
    
    /// The accordian label indicating the business opening/closing status.
    /// When tapped, the user can view the list of operating shifts
    private var accordianLabel: some View {
        Button {
            withAnimation { self.isExpanded.toggle() }
        } label: {
            HStack {
                VStack(alignment: .leading) {
                    accordianLabelTitle
                    accordianLabelSubtitle
                }
                Spacer()
                accordianLabelArrow
            }
        }
    }
    
    /// Accordian title displays the business opening/closing status
    private var accordianLabelTitle: some View {
        HStack {
            Text(accordianTitleText)
                .font(ConstantsHome.Fonts.Size.Accordian.TITLE)
                .fontWeight(ConstantsHome.Fonts.Weight.Accordian.TITLE)
                .foregroundColor(ConstantsHome.Colors.Accordian.Text.TITLE)
            
            Circle()
                .frame(width: 7, height: 7)
                .foregroundColor(operationStatus.color)
        }
    }
    
    /// Accordian subtitle displays static text telling user to open the accordian to view hours
    private var accordianLabelSubtitle: some View {
        Text(ConstantsHome.Strings.Accordian.SUBTITLE)
            .font(ConstantsHome.Fonts.Size.Accordian.SUBTITLE)
            .fontWeight(ConstantsHome.Fonts.Weight.Accordian.SUBTITLE)
            .foregroundColor(ConstantsHome.Colors.Accordian.Text.SUBTITLE)
    }
    
    /// Arrow that rotates right to up when the accordian is expanded
    private var accordianLabelArrow: some View {
        Image(systemName: ConstantsHome.Images.ARROW_RIGHT)
            .font(ConstantsHome.Fonts.Size.Accordian.TITLE)
            .foregroundColor(ConstantsHome.Colors.Accordian.ARROW)
            .rotationEffect(.degrees(isExpanded ? -90 : 0))
    }
}

struct OperatingShiftsAccordianRow: View {
    
    // MARK: - Properties
    
    /// A single operating day
    let operatingDay: OperatingDay
    
    // MARK: - Body
    
    var body: some View {
        HStack {
            Text(operatingDay.day.description)
                .font(ConstantsHome.Fonts.Size.Accordian.OPERATING_HOURS)
                .fontWeight(operatingDay.isToday ?
                    ConstantsHome.Fonts.Weight.Accordian.OPERATING_HOURS_TODAY :
                        ConstantsHome.Fonts.Weight.Accordian.OPERATING_HOURS_NOT_TODAY
                )
            
            Spacer()
            
            VStack {
                if operatingDay.isClosedAllDay {
                    Text(ConstantsHome.Strings.CLOSED)
                        .font(ConstantsHome.Fonts.Size.Accordian.OPERATING_HOURS)
                        .fontWeight(operatingDay.isToday ?
                            ConstantsHome.Fonts.Weight.Accordian.OPERATING_HOURS_TODAY :
                                ConstantsHome.Fonts.Weight.Accordian.OPERATING_HOURS_NOT_TODAY
                        )
                }
                else {
                    ForEach(operatingDay.operatingShifts, id: \.self) { operatingShift in
                        if operatingDay.isOpenAllDay {
                            Text(ConstantsHome.Strings.OPEN_24HRS)
                                .font(ConstantsHome.Fonts.Size.Accordian.OPERATING_HOURS)
                                .fontWeight(operatingDay.isToday ?
                                    ConstantsHome.Fonts.Weight.Accordian.OPERATING_HOURS_TODAY :
                                        ConstantsHome.Fonts.Weight.Accordian.OPERATING_HOURS_NOT_TODAY
                                )
                        }
                        else {
                            Text("\(operatingShift.startTime.formatted(.dateTime.hour()))-\(operatingShift.endTime.formatted(.dateTime.hour()))")
                                .font(ConstantsHome.Fonts.Size.Accordian.OPERATING_HOURS)
                                .fontWeight(operatingDay.isToday ?
                                    ConstantsHome.Fonts.Weight.Accordian.OPERATING_HOURS_TODAY :
                                        ConstantsHome.Fonts.Weight.Accordian.OPERATING_HOURS_NOT_TODAY
                                )
                        }
                    }
                }
            }
        }
    }
}

struct OperatingShiftsAccordian_Previews: PreviewProvider {
    
    static var previews: some View {
        ZStack {
            Image(ConstantsHome.Images.BACKGROUND)
                .resizable()
                .ignoresSafeArea()
            
            OperatingShiftsAccordian(
                operatingDays: [
                    OperatingDay(day: .monday, operatingShifts: []),
                    OperatingDay(day: .tuesday, operatingShifts: []),
                    OperatingDay(day: .wednesday, operatingShifts: []),
                    OperatingDay(day: .thursday, operatingShifts: []),
                    OperatingDay(day: .friday, operatingShifts: []),
                    OperatingDay(day: .saturday, operatingShifts: []),
                    OperatingDay(day: .sunday, operatingShifts: [])
                ],
                operationStatus: .open,
                accordianTitleText: "Open until 7pm"
            )
        }
    }
}
