
import UIKit
import Combine
import CRRefresh

typealias TableViewDelegateAndDataSource = UITableViewDelegate & UITableViewDataSource
typealias CollectionViewDelegateAndDataSource = UICollectionViewDelegate & UICollectionViewDataSource

class BaseCollectionViewController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let refreshControl = UIRefreshControl()
    let showPulltoRefreshPublishSubject = PassthroughSubject<Bool,Never>()
    let hidePulltoRefreshPublishSubject = PassthroughSubject<Bool,Never>()
    let showBottomPublishSubject = PassthroughSubject<Bool,Never>()
    let hideBottomPublishSubject = PassthroughSubject<Bool,Never>()
    let hideFooterLoadingViewPublishSubject = PassthroughSubject<Bool,Never>()
    let showPullToRefreshAnimationViewPublishSubject = PassthroughSubject<Bool,Never>()
    let isNoMoreDataPublishSubject = PassthroughSubject<Bool,Never>()
    let showFooterLoadingViewPublishSubject = PassthroughSubject<Bool,Never>()
    let hidePullToRefreshAnimationViewPublishSubject = PassthroughSubject<Bool,Never>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
    }
    
    override func setupUI() {
        super.setupUI()
        setupCollectionView()
    }
    
    func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func bindData() {
        super.bindData()
        
        hidePulltoRefreshPublishSubject.sink{[unowned self] in
            if $0 {
                collectionView.cr.endHeaderRefresh()
            }
        }.store(in: &bindings)
        
        hideFooterLoadingViewPublishSubject.sink{[unowned self] in
            if $0 {
                collectionView.cr.endLoadingMore()
            }
        }.store(in: &bindings)
        
        isNoMoreDataPublishSubject.sink{[unowned self] in
            collectionView.cr.footer?.isHidden = $0
        }.store(in: &bindings)
    }
    
    func setupHeaderFooterLoadingAnimation(){
        setupHeaderLoadingAnimation()
        setupFooterLoadingAnimation()
    }
    
    func setupHeaderLoadingAnimation(){
        collectionView.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in
            self?.showPullToRefreshAnimationViewPublishSubject.send(true)
        }
    }
    
    func setupFooterLoadingAnimation(){
        collectionView.cr.addFootRefresh(animator: NormalFooterAnimator()) { [weak self] in
            self?.showFooterLoadingViewPublishSubject.send(true)
        }
    }

    @objc func pullToRefresh() {
        print("Pull to refresh")
    }
}

//MARK:- delegate and datasource
extension BaseCollectionViewController : CollectionViewDelegateAndDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}



