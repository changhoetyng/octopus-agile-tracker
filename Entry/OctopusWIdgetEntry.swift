//
//  OctopsWIdgetEntry.swift
//  OctopusTracker
//
//  Created by Hoe Tyng Chang on 25/06/2025.
//
import SwiftUI
import WidgetKit

struct OctopusWidgetEntry: TimelineEntry {
    let date: Date
    let fromDate: Date
    let toDate: Date
    let isError: Bool
    let isPostcodeMissing: Bool
    let pricePerKWh: Double
}
