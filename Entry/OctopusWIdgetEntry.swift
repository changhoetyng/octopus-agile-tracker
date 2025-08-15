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
    let isPostcodeWrong: Bool
    let pricePerKWh: Double
    let averagePrice: Double
    let unitRates: [UnitRates]

    init(
        date: Date,
        fromDate: Date,
        toDate: Date,
        isError: Bool = false,
        isPostcodeMissing: Bool = false,
        isPostcodeWrong: Bool = false,
        pricePerKWh: Double,
        averagePrice: Double,
        unitRates: [UnitRates],
    ) {
        self.date = date
        self.fromDate = fromDate
        self.toDate = toDate
        self.isError = isError
        self.isPostcodeMissing = isPostcodeMissing
        self.isPostcodeWrong = isPostcodeWrong
        self.pricePerKWh = pricePerKWh
        self.averagePrice = averagePrice
        self.unitRates = unitRates
    }
}

typealias OctopusWidgetData = OctopusWidgetEntry
