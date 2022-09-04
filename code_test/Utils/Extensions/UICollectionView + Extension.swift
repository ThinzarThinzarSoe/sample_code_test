
import UIKit

extension UICollectionView {
   
    func registerForHeader<T>(cells : T...) {
        cells.forEach { (cell) in
            register(UINib(nibName: String(describing: cell), bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: cell))
        }
    }
    
    func registerForCells<T>(cells : T...) {
        cells.forEach { (cell) in
            register(UINib(nibName: String(describing: cell), bundle: nil), forCellWithReuseIdentifier: String(describing: cell))
        }
    }
    
    func registerForCells<T>(cells : [T]) {
        cells.forEach { (cell) in
            register(UINib(nibName: String(describing: cell), bundle: nil), forCellWithReuseIdentifier: String(describing: cell))
        }
    }
    
    func dequeReuseCell<T>(type : T.Type, indexPath : IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: String(describing: type), for: indexPath) as! T
    }
}
