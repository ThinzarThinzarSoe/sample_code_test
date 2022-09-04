
import UIKit

class AppScreens {
    static var shared = AppScreens()
    var currentVC : UIViewController?
    var previousVC : UIViewController?
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
}

extension AppScreens {
    func navigateToServerListViewController() {
        let vc = ExchangeRateHistoryViewController()
        currentVC?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToCalculatorViewController() {
        let vc = CalculatorViewController.init(nibName: String(describing: BaseTableViewController.self), bundle: nil)
        currentVC?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goBackToHomeVC() {
        if let destinationViewController = currentVC?.navigationController?.viewControllers.filter(
            {$0 is HomeViewController}).first as? HomeViewController {
            destinationViewController.isBack = true
            currentVC?.navigationController?.popToViewController(destinationViewController, animated: true)
        }
    }
}
