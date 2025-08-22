//
//  UIComponents.swift
//  duotime
//
//  Created by Mrinaal Arora on 8/21/25.
//

import SwiftUI
import AppKit

/// rounded panel helper with subtle separator stroke
private struct GroupPanel: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                // keep same fill as window to honor your "no extra color" request
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color(NSColor.controlBackgroundColor))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(Color(nsColor: .separatorColor), lineWidth: 1)
            )
    }
}

extension View {
    func groupPanel() -> some View { self.modifier(GroupPanel()) }
}
