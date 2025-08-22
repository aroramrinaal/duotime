//
//  TimeFormatSelectorView.swift
//  duotime
//
//  Created by Mrinaal Arora on 8/21/25.
//

import SwiftUI

struct TimeFormatSelectorView: View {
    @ObservedObject var timeViewModel: TimeViewModel
    @Binding var use24HourTime: Bool

    var body: some View {
        // 24-hour time
        HStack {
            Text("24-hour time")
            Spacer()
            Toggle("", isOn: $use24HourTime)
                .onChange(of: use24HourTime) { _, newValue in
                    timeViewModel.use24HourTime = newValue
                }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}
