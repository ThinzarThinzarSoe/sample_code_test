
import Foundation

struct XTDateFormatterStruct {
    
    static var localeIdentifier: String {
            return "en_US"
    }
    
    static var shortDateFormat: String {
            return "dd MMMM yyyy"
        }
    
    static var fullDateTimeFormat: String {
            return "EEE, dd MMM yyyy HH:mm a"
    }
    
    static var shortDateFormatWithTime : String {
        return "dd MMM yyyy h : mm a"
    }
    
    static let formatter: DateFormatter = {
        return getDateFormatter()
    }()
    
    static func getDateFormatter(dateFormat: String? = nil) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale(identifier: localeIdentifier)
        formatter.dateFormat = dateFormat
        return formatter
    }
    
    static func xt_defaultDateFormatter() -> DateFormatter {
        return getDateFormatter(dateFormat: "dd/MM/yyyy") /* 01/01/2020 */
    }
    
    static func xt_defaultDateTimeFormatter() -> DateFormatter {
        return getDateFormatter(dateFormat: "dd-MM-yyyy h:mm a") /* 01-01-2020 4:03 pm */
    }
    
    static func xt_TaskDateFormatter() -> DateFormatter {
        return getDateFormatter(dateFormat: "dd MMM yyyy") /* 01 Dec 2020 */
    }
    
    static func xt_FullMonthNameFormatter() -> DateFormatter {
        return getDateFormatter(dateFormat: "dd MMMM yyyy") /* 01 December 2020 */
    }
    
    static func xt_MonthYearFormatter() -> DateFormatter {
        return getDateFormatter(dateFormat: "MMM yyyy") /* Dec 2020 */
    }
    
    static func xt_MonthDashYearFormatter() -> DateFormatter {
        return getDateFormatter(dateFormat: "yyyy-MM") /* 2020-06 */
    }
    
    static func xt_serverDateFormatter() -> DateFormatter {
        return getDateFormatter(dateFormat: "yyyy-MM-dd") /* 2020-01-01 */
    }
    
    static func xt_serverDateLongFormatter() -> DateFormatter {
        return getDateFormatter(dateFormat: "yyyy-MM-dd HH:mm:ss") /* 2021-09-21 17:16:00 */
    }
    
    static func xt_fullDateFormatter() -> DateFormatter {
        return getDateFormatter(dateFormat: "yyyy-MM-dd'T'HH:mm:ssZZZ")
    }

    static func xt_fullLongDateFormatter() -> DateFormatter {
        return getDateFormatter(dateFormat: "yyyy-MM-dd'T'HH:mm:ssZZZZZ")
    }
    
    static func xt_12HourFormatTimeFormatter() -> DateFormatter {
        return getDateFormatter(dateFormat: "h : mm a")
    }
    
    static func xt_24HourFormatTimeFormatter() -> DateFormatter {
        return getDateFormatter(dateFormat: "hh : mm")
    }
    
    static func xt_24HourFormatSeverTimeFormatter() -> DateFormatter {
        return getDateFormatter(dateFormat: "HH:mm:ss")
    }
    
    static func xt_dateFormatterEnglishOnly(_ format: String!) -> DateFormatter {
        return getDateFormatter(dateFormat: format)
    }
    
    static func xt_shortDateFormatterWithTime() -> DateFormatter {
        return getDateFormatter(dateFormat: "dd-MMM-yyyy h:mm a")
    }
    
    static func xt_dayMonthYearFormatter() -> DateFormatter {
        return getDateFormatter(dateFormat: "dd/MM/yyyy") /* 2020-01-01 */
    }
    
    static func xt_dayUploadFormatter() -> DateFormatter {
        return getDateFormatter(dateFormat: "dd/MM/yyyy h:mm a") /* 2020-01-01 */
    }
    
    static func xt_serverDateShortFormatter() -> DateFormatter {
        return getDateFormatter(dateFormat: "yyyy-MM-dd HH:mm:ss") /* 2021-09-21 17:16:00 */
    }
}

extension DateFormatter {
    func xt_stringFromDate(_ date: Date?) -> String? {
        guard let date = date else {
            return nil
        }
        return string(from: date)
    }
    
    func xt_convertToSGDateTime(_ date: Date?) -> String? {
        guard let date = date else {
            return nil
        }
        let timeZone = TimeZone(abbreviation: "SGT")!
        self.timeZone = timeZone
        return string(from: date)
    }
    
    func xt_convrtToDate(_ dateStr: String) -> Date {
        let dateFormatter = XTDateFormatterStruct.xt_defaultDateTimeFormatter()
        let date = dateFormatter.date(from:dateStr)!
        return date
    }
    
}

extension Date {
    func monthAsString() -> String {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US")
            formatter.setLocalizedDateFormatFromTemplate("MMM")
            return formatter.string(from: self)
    }
    
    func getNextMonth() -> Date? {
        return Calendar.current.date(byAdding: .month, value: 1, to: self)
    }
    
    func getNextMonthName() -> String? {
        let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: self) ?? Date()
        return XTDateFormatterStruct.xt_MonthYearFormatter().string(from: nextMonth)
    }

    func getPreviousMonth() -> Date? {
        return Calendar.current.date(byAdding: .month, value: -1, to: self)
    }
}


