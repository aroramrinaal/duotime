//
//  TimezoneSelectorView.swift
//  duotime
//
//  Created by Mrinaal Arora on 8/21/25.
//

import SwiftUI

struct TimezoneSelectorView: View {
    @ObservedObject var timeViewModel: TimeViewModel

    private var selectedTimezoneDisplay: String {
        TimezoneFormatter.formatTimezoneDisplay(timeViewModel.currentTimezone, popularTimezones: PopularTimezones.all)
    }

    var body: some View {
        // Time zone selection
        HStack {
            Text("Time zone")
            Spacer()
            Menu {
                ForEach(PopularTimezones.all, id: \.identifier) { timezone in
                    Button {
                        timeViewModel.updateTimezone(timezone.identifier)
                    } label: {
                        let timeZone = TimeZone(identifier: timezone.identifier)!
                        let offset = timeZone.secondsFromGMT() / 3600
                        let offsetString = offset >= 0 ? "+\(offset)" : "\(offset)"
                        Text("\(timezone.cityName) (UTC\(offsetString))")
                    }
                }
            } label: {
                Text(selectedTimezoneDisplay)
                    .frame(maxWidth: 200)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}
