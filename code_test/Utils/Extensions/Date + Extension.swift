
import Foundation

extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
    
    static func getSeconds(recent: Date, previous: Date) -> Int? {
        return Calendar.current.dateComponents([.second], from: previous, to: recent).second
    }
    
    static func calculateTimer(recent: Date, next: Date) -> Int? {
       return Calendar.current.dateComponents([.second], from: recent, to: next).second
    }
}

extension Date {
    func timeAgoSocailMedia() -> String{
        let calendar = NSCalendar.current
        let now = Date()
        let components = calendar.dateComponents([Calendar.Component.minute , Calendar.Component.hour , Calendar.Component.day , Calendar.Component.weekOfYear , Calendar.Component.month , Calendar.Component.year , Calendar.Component.second], from: self, to: now)
        
        if (components.day ?? 0 >= 1 || components.weekOfYear ?? 0 >= 1 || components.month ?? 0 >= 1 || components.year ?? 0 >= 1) {
            
            return XTDateFormatterStruct.xt_TaskDateFormatter().string(from: self)

        }else if (components.hour ?? 0 >= 2) {
            return "\(components.hour!) h ago"
        } else if (components.hour ?? 0 >= 1){
            return "1 h ago"
            
        } else if (components.minute ?? 0 >= 2) {
            return "\(components.minute!) m ago"
        } else if (components.minute ?? 0 >= 1){
            return "1 m ago"
        } else {
            return "Just now"
        }
    }
    
    func timeAgoSinceDate(numericDates:Bool , isForBirthday : Bool = false) -> String {
        let calendar = NSCalendar.current
        let now = Date()
        let components = calendar.dateComponents([Calendar.Component.minute , Calendar.Component.hour , Calendar.Component.day , Calendar.Component.weekOfYear , Calendar.Component.month , Calendar.Component.year , Calendar.Component.second], from: self, to: now)
        if (components.year ?? 0 >= 2) {
            if isForBirthday {
                return "\(components.year!) Years ago"
            }
            else {
                return "\(components.year!) years ago"
            }
            
        } else if (components.year ?? 0 >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month ?? 0 >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month ?? 0 >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear ?? 0 >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear ?? 0 >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day ?? 0 >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day ?? 0 >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour ?? 0 >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour ?? 0 >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute ?? 0 >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute ?? 0 >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second ?? 0 >= 3) {
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }
    }
    
    func convertDateString(dateString: String, format: String){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale.init(identifier: "en_US")
    }
    
    func convertToString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale.init(identifier: "en_US")
        var result = ""
        let dateObj = self
        //convert string to date object
        formatter.dateFormat = format
        result = formatter.string(from: dateObj )
        
        return result
    }
    
    func getFormattedDateString(formatString : String) -> String {
        let df = DateFormatter()
        let locale = Locale.init(identifier: "en_US")
        df.locale = locale
        df.dateFormat = formatString
        return df.string(from: self)
    }
    
    func isDateInWeekend() -> Bool {
        return Calendar.current.isDateInWeekend(self)
    }
    
    func getYear() -> Int {
        return Calendar.current.component(Calendar.Component.year, from: self)
    }
    
    func getMoth() -> Int {
        return Calendar.current.component(Calendar.Component.month, from: self)
    }
    
    func getMonthName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        dateFormatter.locale = Locale(identifier: XTDateFormatterStruct.localeIdentifier)
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: self)
    }
    
    func getDay() -> Int {
        return Calendar.current.component(Calendar.Component.day, from: self)
    }
    
    // get TimeStamp
    func getCurrentTimeStamp() -> Int64 {
        let timestamp = timeIntervalSince1970
        return Int64(timestamp)
    }
    

    func convertDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US")
        let dateString = formatter.string(from: self)
        return dateString
    }
    
    func createImageIDWithDate() -> Int64 {
        let nowDoublevaluseis = NSDate().timeIntervalSince1970
        return Int64(nowDoublevaluseis*1000)
    }
    
    func startOfMonth() -> Date?{
        let calendar = Calendar.current
        let currentDateComponents = calendar.dateComponents([.year, .month], from: self)
        let startOfMonth = calendar.date(from: currentDateComponents)

        return startOfMonth
    }
    
    func dateByAddingMonths(_ monthsToAdd: Int) -> Date? {
        let calendar = Calendar.current
        var months = DateComponents()
        months.month = monthsToAdd

        return calendar.date(byAdding: months, to: self)
    }
    
    func endOfMonth() -> Date?{
        guard let plusOneMonthDate = dateByAddingMonths(1) else { return nil }

        let calendar = Calendar.current
        let plusOneMonthDateComponents = calendar.dateComponents([.year, .month], from: plusOneMonthDate)
        let endOfMonth = calendar.date(from: plusOneMonthDateComponents)?.addingTimeInterval(-1)

        return endOfMonth
    }
}


extension Date {
    public var removeTimeStamp : Date? {
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self)) else {
         return nil
        }
        return date
    }
}

extension Calendar {
    func getDates(_ startDate: Date, _ endDate: Date) -> [Date]  {
        // make sure parameters are valid
        guard startDate < endDate else { print("invalid parameters"); return [] }
        // how many days between dates?
        let dayDiff = Int(self.dateComponents([.day], from: startDate, to: endDate).day ?? 0)
        let rangeOfDaysFromStart: Range<Int> = 0..<dayDiff + 1
        let dates = rangeOfDaysFromStart.compactMap{ self.date(byAdding: .day, value: $0, to: startDate) }
        return dates
    }
}

class Dates {
    static func printDatesBetweenInterval(_ startDate: Date, _ endDate: Date)-> [Date]  {
        var dates : [Date] = []
        
        var startDate = startDate
        let calendar = Calendar.current

        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"

        while startDate <= endDate {
            dates.append(startDate)
            startDate = calendar.date(byAdding: .minute, value: 20, to: startDate)!
        }
        return dates
    }

    static func dateFromString(_ dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"

        return dateFormatter.date(from: dateString)!
    }
}
