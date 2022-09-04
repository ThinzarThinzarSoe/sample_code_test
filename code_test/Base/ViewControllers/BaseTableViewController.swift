
import UIKit
import Combine
import CRRefresh

var topViewInitialHeight : CGFloat = 380
let topViewFinalHeight : CGFloat = 0
let topViewHeightConstraintRange = topViewFinalHeight..<topViewInitialHeight

protocol InnerTableViewScrollDelegate: AnyObject {
    
    var currentHeaderHeight: CGFloat { get }
    func innerTableViewDidScroll(withDistance scrollDistance: CGFloat)
    func innerTableViewScrollEnded(withScrollDirection scrollDirection: DragDirection)
    
}

class BaseTableViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var constraintLeadingTableview: NSLayoutConstraint!
    @IBOutlet weak var constraintTrailingTableView: NSLayoutConstraint!
    
    @IBOutlet weak var                                      footerStickyView: UIView!
    @IBOutlet weak var heightFooterStickyView: NSLayoutConstraint!
    
    @IBOutlet weak var headerStickyView: UIView!
    @IBOutlet weak var heightHeaderStickyView: NSLayoutConstraint!
    
    fileprivate let activityIndicator = UIActivityIndicatorView()
    
    let showPullToRefreshAnimationViewPublishSubject = PassthroughSubject<Bool,Never>()
    let hidePullToRefreshAnimationViewPublishSubject = PassthroughSubject<Bool,Never>()
    let showFooterLoadingViewPublishSubject = PassthroughSubject<Bool,Never>()
    let hideFooterLoadingViewPublishSubject = PassthroughSubject<Bool,Never>()
    let isNoMoreDataPublishSubject = PassthroughSubject<Bool,Never>()
    
    // for segmentControl
    weak var innerTableViewScrollDelegate: InnerTableViewScrollDelegate?
    
    private var dragDirection: DragDirection = .Up
    private var oldContentOffset = CGPoint.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
    }
    
    override func bindData() {
        super.bindData()
        
        showPullToRefreshAnimationViewPublishSubject.sink{[unowned self] in
            if $0 {
                tableView.cr.endHeaderRefresh()
            }
        }.store(in: &bindings)
        
        hideFooterLoadingViewPublishSubject.sink{[unowned self] in
            if $0 {
                tableView.cr.endLoadingMore()
            }
        }.store(in: &bindings)
        
        isNoMoreDataPublishSubject.sink{[unowned self] in
            tableView.cr.footer?.isHidden = $0
        }.store(in: &bindings)
    }
    
    override func setupUI() {
        super.setupUI()
        setupTableView()
    }
    
    
    func setupHeaderFooterLoadingAnimation(){
        setupHeaderLoadingAnimation()
        setupFooterLoadingAnimation()
    }
    
    func setupHeaderLoadingAnimation(){
        tableView.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in
            self?.showPullToRefreshAnimationViewPublishSubject.send(true)
        }
    }
    
    func setupFooterLoadingAnimation(){
        tableView.cr.addFootRefresh(animator: NormalFooterAnimator()) { [weak self] in
            self?.showFooterLoadingViewPublishSubject.send(true)
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get{
            return .portrait
        }
    }
    
    
    //MARK:- ActivityIndicator
    /* for pull to refresh and load more*/
    func showBottomIndicator(){
        activityIndicator.startAnimating()
        activityIndicator.color = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        activityIndicator.frame = CGRect(x: CGFloat(0), y: CGFloat(0)
            , width: tableView.bounds.width, height: CGFloat(44))
        
        tableView.tableFooterView = activityIndicator
    }
    
    func setupConstriantForTabletSize(leading: CGFloat, trailing: CGFloat){
        if iOSDeviceSizes.tabletSize.getBool() {
            constraintLeadingTableview.constant = leading
            constraintTrailingTableView.constant = trailing
        }
    }
    
    func hideBottomIndicator(){
        activityIndicator.stopAnimating()
        tableView.tableFooterView = UIView()
    }
    
    func showTopIndicator(){
        activityIndicator.startAnimating()
        activityIndicator.color = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        activityIndicator.frame = CGRect(x: CGFloat(0), y: CGFloat(0)
            , width: tableView.bounds.width, height: CGFloat(44))
        
        tableView.tableHeaderView = activityIndicator
    }
    
    func hideTopIndicator(){
        activityIndicator.stopAnimating()
        tableView.tableHeaderView = UIView()
    }
    
    func scrollToBottom(topInset: CGFloat = 0, isAlreadyCalled: Bool = false) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {[unowned self] in
            var rect = tableView.bounds
            rect.origin.y = max(tableView.contentSize.height - tableView.bounds.size.height, topInset)
            tableView.scrollRectToVisible(rect, animated: false)
            if !isAlreadyCalled {
                scrollToBottom(topInset: topInset, isAlreadyCalled: true)
            }
        }
    }
}

extension BaseTableViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return BaseTableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let delta = scrollView.contentOffset.y - oldContentOffset.y
        
        let topViewCurrentHeightConst = innerTableViewScrollDelegate?.currentHeaderHeight
        
        if let topViewUnwrappedHeight = topViewCurrentHeightConst {
            
            /**
             *  Re-size (Shrink) the top view only when the conditions meet:-
             *  1. The current offset of the table view should be greater than the previous offset indicating an upward scroll.
             *  2. The top view's height should be within its minimum height.
             *  3. Optional - Collapse the header view only when the table view's edge is below the above view - This case will occur if you are using Step 2 of the next condition and have a refresh control in the table view.
             */
            
            if delta > 0,
                topViewUnwrappedHeight > topViewHeightConstraintRange.lowerBound,
                scrollView.contentOffset.y > 0 {
                
                dragDirection = .Up
                innerTableViewScrollDelegate?.innerTableViewDidScroll(withDistance: delta)
                scrollView.contentOffset.y -= delta
            }
            
            /**
             *  Re-size (Expand) the top view only when the conditions meet:-
             *  1. The current offset of the table view should be lesser than the previous offset indicating an downward scroll.
             *  2. Optional - The top view's height should be within its maximum height. Skipping this step will give a bouncy effect. Note that you need to write extra code in the outer view controller to bring back the view to the maximum possible height.
             *  3. Expand the header view only when the table view's edge is below the header view, else the table view should first scroll till it's offset is 0 and only then the header should expand.
             */
            
            if delta < 0,
                // topViewUnwrappedHeight < topViewHeightConstraintRange.upperBound,
                scrollView.contentOffset.y < 0 {
                
                dragDirection = .Down
                innerTableViewScrollDelegate?.innerTableViewDidScroll(withDistance: delta)
                scrollView.contentOffset.y -= delta
            }
        }
        
        oldContentOffset = scrollView.contentOffset
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        //You should not bring the view down until the table view has scrolled down to it's top most cell.
        
        if scrollView.contentOffset.y <= 0 {
            
            innerTableViewScrollDelegate?.innerTableViewScrollEnded(withScrollDirection: dragDirection)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        //You should not bring the view down until the table view has scrolled down to it's top most cell.
        
        if decelerate == false && scrollView.contentOffset.y <= 0 {
            
            innerTableViewScrollDelegate?.innerTableViewScrollEnded(withScrollDirection: dragDirection)
        }
    }
}

