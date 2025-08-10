//
//  SkeletonLoadingView.swift
//  OctopusTracker
//
//  Created by Hoe Tyng Chang on 10/08/2025.
//

import SwiftUI

struct SkeletonLoadingView: ViewModifier {
    var isLoading: Bool
    
    @State private var blinking: Bool = false

    func body(content: Content) -> some View {
        if isLoading {
            content
                .foregroundStyle(Color.gray)
                .opacity(blinking ? 0.1 : 1)
                .animation(
                    .easeInOut(duration: 0.6).repeatForever(),
                    value: blinking,
                )
                .onAppear {
                    blinking.toggle()
                }
                .redacted(reason: .placeholder)
        } else {
            content
        }
    }
}

extension View {
    func skeletonLoadingView(isLoading: Bool) -> some View {
        modifier(SkeletonLoadingView(isLoading: isLoading))
    }
}
