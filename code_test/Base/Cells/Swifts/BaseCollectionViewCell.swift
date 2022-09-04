
import UIKit
import Combine

class BaseCollectionViewCell: UICollectionViewCell {

    var bindings = Set<AnyCancellable>()

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setupLanguage()
        setupTest()
        bindData()
    }
    
    @objc func reload(){
        setupLanguage()
    }
    
    func setupUI(){
        
    }
    
    func setupLanguage(){
        
    }
    
    func setupTest(){
        
    }
    
    func bindData(){
        
    }
}


