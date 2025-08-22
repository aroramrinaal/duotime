//
//  TimeDisplaySectionView.swift
//  duotime
//
//  Created by Mrinaal Arora on 8/21/25.
//

import SwiftUI

struct TimeDisplaySectionView: View {
    @ObservedObject var timeViewModel: TimeViewModel
    @Binding var use24HourTime: Bool
    @Binding var prefixText: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Time Display")
                    .font(.headline)
                Spacer()
            }

            VStack(spacing: 0) {
                // 24-hour time
                TimeFormatSelectorView(timeViewModel: timeViewModel, use24HourTime: $use24HourTime)

                Divider()
                    .padding(.horizontal, 16)

                // Time zone selection
                TimezoneSelectorView(timeViewModel: timeViewModel)

                Divider()
                    .padding(.horizontal, 16)

                // Prefix text
                PrefixTextInputView(timeViewModel: timeViewModel, prefixText: $prefixText)
            }
            .groupPanel() // rounded border
        }
    }
}
