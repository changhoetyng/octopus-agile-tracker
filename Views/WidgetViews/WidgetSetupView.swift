//
//  WidgetSetupView.swift
//  OctopusTracker
//
//  Created by Hoe Tyng Chang on 24/06/2025.
//
import SwiftUI
import WidgetKit

struct WidgetSetupView: View {
    var entry: OctopusWidgetEntry

    @Environment(\.widgetFamily) var family

    private var formatter: DateFormatter {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f
    }

    var body: some View {
        if !entry.isPostcodeMissing && !entry.isError {
            switch family {
            case .systemSmall:
                AgileTrackerSmallWidget(entry: entry)
            case .systemMedium:
                Text("Coming soon").foregroundStyle(Color.white)
            default:
                Text("View not supported").foregroundStyle(Color.white)
            }
        } else if entry.isPostcodeMissing {
            NoPostcodeView(entry: entry)
        } else {
            NetworkErrorView(entry: entry)
        }

    }
}
