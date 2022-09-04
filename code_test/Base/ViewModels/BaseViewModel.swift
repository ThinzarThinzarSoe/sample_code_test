
import Foundation
import Combine
import RxSwift

class BaseViewModel {
    var bindings = Set<AnyCancellable>()
    var disposableBag = DisposeBag()
    weak var viewController : BaseViewController?
    
    let errorPublishSubject = PassthroughSubject<Error,Never>()
    let showErrorMessagePublishSubject = PassthroughSubject<String,Never>()
    let loadingPublishSubject = PassthroughSubject<Bool,Never>()
    let isNoDataPublishSubject = PassthroughSubject<Bool,Never>()
    let isNoInternetPublishSubject = PassthroughSubject<Bool,Never>()
    let isSeverErrorPublishSubject = PassthroughSubject<Bool,Never>()
    let isNoMoreDataPublishSubject = PassthroughSubject<Bool,Never>()
    var isShowNoDataPageForUnKnownError: Bool = true

    init() {
        
    }
    
    deinit {
        debugPrint("Deinit \(type(of: self))")
    }
    
    func bindViewModel(in viewController: BaseViewController? = nil,
                       isDataShowingPage: Bool = true) {
        self.viewController = viewController
        isShowNoDataPageForUnKnownError = isDataShowingPage
        
        loadingPublishSubject.sink{[unowned self] (result) in
            if result {
                self.viewController?.showLoading()
            } else {
                self.viewController?.hideLoading()
                if let vc = self.viewController as? BaseTableViewController{
                    vc.hidePullToRefreshAnimationViewPublishSubject.send(true)
                    vc.hideFooterLoadingViewPublishSubject.send(true)
                }
            }
        }.store(in: &bindings)
        
        errorPublishSubject.sink{[unowned self] (error) in
            self.viewController?.hideLoading()
            
            if let vc = self.viewController as? BaseTableViewController{
                vc.hidePullToRefreshAnimationViewPublishSubject.send(true)
                vc.hideFooterLoadingViewPublishSubject.send(true)
            }
            
            if let error = error as? ErrorType {
                switch error {
                case .NoInterntError:
                    self.isNoInternetPublishSubject.send(true)
                case .KnownError(let message):
                    self.viewController?.showToast(message: message)
                case .UnKnownError:
                    if self.isShowNoDataPageForUnKnownError {
                        self.isSeverErrorPublishSubject.send(true)
                    }else {
                        self.viewController?.showToast(message: "Something Went Wrong")
                    }
                case .TokenExpireError(let errorCode) :
                    self.isSeverErrorPublishSubject.send(true)
                default:
                    self.isSeverErrorPublishSubject.send(true)
                }
            }
        }.store(in: &bindings)
        
        showErrorMessagePublishSubject.sink { [weak self] (errorMessage) in
            self?.viewController?.showToast(message: errorMessage, isShowing: {
                self?.viewController?.view.isUserInteractionEnabled = false
            }, completion: {
                self?.viewController?.view.isUserInteractionEnabled = true
            })
        }.store(in: &bindings)
    }
}

