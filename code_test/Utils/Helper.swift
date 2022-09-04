
import UIKit

enum Direction {
    case leftToRight
    case rightToLeft
    case topToBottom
    case bottomToTop
}

enum iOSDeviceSizes {
    case tabletSize
    case miniSize
    case plusSize
    case maxSize
    
    func getBool() -> Bool {
        switch self {
        case .miniSize:
            return UIDevice.is_iPhoneMiniDevices()
        case .tabletSize:
            return UIDevice.is_iPadDevice()
        case .plusSize:
            return UIDevice.is_iPhonePlusDevices()
        case .maxSize:
            return UIDevice.is_iPhoneMaxDevices()
        }
    }
}

enum DragDirection {
    case Up
    case Down
}

// Error Type
enum ErrorType: Error {
    case NoInterntError
    case NoDataError
    case SeverError
    case KnownError(_ errorMessage: String)
    case UnKnownError
    case TokenExpireError(_ code : Int)
}

public enum NetworkError: Error {
    case badInput
    case noData
    case forbidden
    case notAuthorized
    case severError
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .badInput:
            return NSLocalizedString("Bad input", comment: "")
        case .noData:
            return NSLocalizedString("No data", comment: "")
        case .forbidden:
            return NSLocalizedString("Forbiddden", comment: "")
        case .notAuthorized:
            return NSLocalizedString("Not authorized", comment: "")
        case .severError:
            return NSLocalizedString("Server Error", comment: "")
        }
    }
}

enum ServiceError: Error {
    case url(URLError)
    case urlRequest
    case decode
}

enum DateType: Int {
    case start_date = 0
    case end_date = 1
}

enum TimeType: Int {
    case start_time = 0
    case end_time = 1
}

enum CurrencyType {
    case usd
    case gbp
    case eur
    
    func getID() -> Int {
        switch self {
        case .usd:
            return 1
        case .gbp:
            return 2
        case .eur:
            return 3
        }
    }
    
    func getDescription() -> String {
        switch self {
        case .usd:
            return "United States Dollar"
        case .gbp:
            return "British Pound Sterling"
        case .eur:
            return "Euro"
        }
    }
    
    func getCurrencyName() -> String {
        switch self {
        case .usd:
            return "USD"
        case .gbp:
            return "GBP"
        case .eur:
            return "EUR"
        }
    }
}
