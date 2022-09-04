
import Foundation

class HomeScreen {

    enum HomeVC {
        case navigateToHistoryExchangeRateVC
        case navigateToCalculatorVC
        
        func show() {
            switch self {
            case .navigateToHistoryExchangeRateVC:
                AppScreens.shared.navigateToServerListViewController()
            case .navigateToCalculatorVC:
                AppScreens.shared.navigateToCalculatorViewController()
            }
        }
    }
}
