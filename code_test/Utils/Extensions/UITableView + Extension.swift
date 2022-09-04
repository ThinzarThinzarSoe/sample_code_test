
import Foundation
import UIKit

extension UITableView {
    
    func registerForCells<T>(cells : T...) {
        cells.forEach { (cell) in
            register(UINib(nibName: String(describing: cell), bundle: nil), forCellReuseIdentifier: String(describing: cell))
        }
    }
    
    func registerForCells<T>(cells : [T]) {
        cells.forEach { (cell) in
            register(UINib(nibName: String(describing: cell), bundle: nil), forCellReuseIdentifier: String(describing: cell))
        }
    }
    
    func dequeReuseCell<T>(type : T.Type, indexPath : IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: String(describing: type), for: indexPath) as! T
    }
    
    func reloadWithAnimation(view: UIView, animations: UIView.AnimationOptions = [], duration: TimeInterval, onComplete: ((Bool)->Void)? = nil) {
        UIView.transition(with: view, duration: duration, options: animations, animations: {[unowned self] in
            reloadData()
        }, completion: onComplete)
    }
    
    func reloadData(completion:@escaping ()->()) {
        UIView.animate(withDuration: 0, animations: { [unowned self] in reloadData() })
            { _ in completion() }
    }
    
    func isLastIndex(indexPath : IndexPath) -> Bool {
        return (self.numberOfRows(inSection: indexPath.section) - 1) == indexPath.row
    }
    
    func isLastSection(indexPath : IndexPath) -> Bool {
        return self.numberOfSections - 1 == indexPath.section
    }
}

