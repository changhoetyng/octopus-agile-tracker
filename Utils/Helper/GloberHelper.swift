import Foundation

class GloberHelper {
    static let shared = GloberHelper()

    let sharedCalendar: Calendar = {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "Europe/London")!
        return calendar
    }()
}
