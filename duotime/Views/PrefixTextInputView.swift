//
//  PrefixTextInputView.swift
//  duotime
//
//  Created by Mrinaal Arora on 8/21/25.
//

import SwiftUI

struct PrefixTextInputView: View {
    @ObservedObject var timeViewModel: TimeViewModel
    @Binding var prefixText: String

    var body: some View {
        // Prefix text, with no blue focus ring
        HStack(alignment: .top) {
            Text("Prefix text")
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                NoFocusRingTextField(placeholder: "(eg: NYC)", text: $prefixText, maxCharacters: 5)
                    .frame(width: 200)
                    .onChange(of: prefixText) { _, newValue in
                        timeViewModel.prefixText = newValue
                    }

                Text("max 5 characters")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}
