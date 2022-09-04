
import UIKit
import RxSwift
import RxCocoa
import Combine
import SnapKit

class BaseViewController: UIViewController {
    
    var bindings = Set<AnyCancellable>()
    
    var disposableBag = DisposeBag()
    
    var errorHandlerView : ErrorHandlerView?
    var view_model = BaseViewModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLanguage()
        setNavigationColor()
        bindViewModel()
        bindData()
        addTapGestures()
        setupTest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppScreens.shared.currentVC = self
        checkViewControllerAndShowHideTabBar(vc: self)
        checkViewControllerAndAddBackBtn(vc: self)
    }

    @objc func reload(){
        setupLanguage()
        setupUI()
    }
    
    func removeNavigationBorder(){
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func checkViewControllerAndShowHideTabBar(vc : UIViewController) {
        let isTop : Bool = isTopViewController(vc: vc)
        isHiddenTabBar(isHidden: !isTop)
    }
    
    func checkViewControllerAndAddBackBtn(vc : UIViewController) {
        if !isTopViewController(vc: vc){
            addBackButton()
        }
    }
    
    func isTopViewController(vc : UIViewController) -> Bool {
        return navigationController?.children.first == vc
    }
    
    func showNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func hideNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func setupUI(){
        isHiddenTabBar(isHidden: !isTopViewController(vc: self))
    }
    
    func setupLanguage(){
        
    }
    
    func bindViewModel() {

    }
    
    func bindData() {
        
    }
    
    func reloadScreen() {
        setupUI()
        setNavigationColor()
        setupLanguage()
    }
    
    func setupTest(){
        
    }
    
    func setNavigationColor(){
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = .primary_grey
            appearance.titleTextAttributes = [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.white,NSAttributedString.Key.font: UIFont.Roboto.Bold.font(size: 16)]
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        } else {
            if let navigationBar = navigationController?.navigationBar {
                let navigationLayer = CALayer()
                var bounds = navigationBar.bounds
                bounds.size.height += view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
                navigationLayer.frame = bounds
                navigationLayer.backgroundColor = UIColor.white.cgColor
                
                if let image = getImageFrom(layer: navigationLayer) {
                    navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
                }
            }
        }
        
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get{
            return .portrait
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func isHiddenTabBar(isHidden : Bool) {
        tabBarController?.tabBar.isHidden = isHidden
    }
    
    func addTapGestures() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(gestureRecognizer:)))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
    
    func removeAllPerviousControllers(controller: AnyClass) {
        navigationController?.viewControllers.removeAll(where: { (vc) -> Bool in
            return !vc.isKind(of: controller) && !vc.isKind(of: controller)
        })
    }
    
    @objc func handleTap(gestureRecognizer: UIGestureRecognizer) {
        view.endEditing(true)
        willDismissKeyBoard()
    }
    
    func showNoInternetConnectionAlert(){

    }
    
    func willDismissKeyBoard() {
        
    }
    
    func isShowNoDataAndInternet(isShow : Bool , isServerError : Bool = false, errorImage: UIImage? = nil, errorTitle: String? = nil, errorDesc: String? = nil) {
        errorHandlerView?.removeFromSuperview()
        errorHandlerView = ErrorHandlerView(frame: view.frame)
        errorHandlerView?.translatesAutoresizingMaskIntoConstraints = false
        errorHandlerView?.delegate = self
        if isShow {
//            errorHandlerView?.setupView(isShow: isShow, isServerError: isServerError, errorImage: errorImage, errorTitle: errorTitle, errorDesc: errorDesc)
//            view.addSubview(errorHandlerView!)
//            errorHandlerView?.snp.makeConstraints({ (errorView) in
//                errorView.left.equalToSuperview()
//                errorView.right.equalToSuperview()
//                errorView.centerY.equalToSuperview()
//            })
            
        } else {
            errorHandlerView?.removeView()
        }
        
    }
    
    func setupNavigationChatBarButton() {
        
        let menuBtn = UIButton(type: .custom)
        menuBtn.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
        menuBtn.addTarget(self, action: #selector(didTapChat), for: .touchUpInside)
        let menuBarItem = UIBarButtonItem(customView: menuBtn)
        menuBtn.layer.cornerRadius = 17.5
        let currWidth = menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 35)
        currWidth?.isActive = true
        let currHeight = menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 35)
        currHeight?.isActive = true
        let img = UIImage(named: "ic_history")?.imageWithColor(color: .white)
        menuBtn.setImage(img, for: .normal)
        navigationItem.rightBarButtonItem = menuBarItem
        
    }
    
    @objc func didTapChat(){

    }
    
    func setDefaultNavigationColor(){
        if let navigationBar = navigationController?.navigationBar {
            let navigationLayer = CALayer()
            var bounds = navigationBar.bounds
            if #available(iOS 13.0, *) {
                bounds.size.height += view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
            } else {
                bounds.size.height += UIApplication.shared.statusBarFrame.size.height
            }
            navigationLayer.frame = bounds
            navigationLayer.backgroundColor = UIColor.primary_grey.cgColor
            
            if let image = getImageFrom(layer: navigationLayer) {
                navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
            }
        }
    }
    
}

extension BaseViewController : ErrorHandlerDelegate {
    func didTapRetry() {
        
        ApiClient.checkReachable(success: {[unowned self] in
            isShowNoDataAndInternet(isShow: false)
            reloadScreen()
        }) {[unowned self] in
            //not reachable
            showNoInternetConnectionToast()
            isShowNoDataAndInternet(isShow: true)
        }
        
    }
}

extension BaseViewController {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        touch.view == view
    }
}
