
import UIKit

extension Double {
    
    private static var commaFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en")
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""
        formatter.maximumFractionDigits = 0
        formatter.minimumFractionDigits = 0
        return formatter
    }()
    
    internal var commaRepresentation: String {
        return Double.commaFormatter.string(from: NSNumber(value: self)) ?? ""
    }
    
    func commaRepresentation(unit: String) -> String {
        let commaPres = Double.commaFormatter.string(from: NSNumber(value: self)) ?? ""
        return commaPres + " \(unit)"
    }
   
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

