
import UIKit

protocol ErrorHandlerDelegate: AnyObject {
    func didTapRetry()
}

class ErrorHandlerView: BaseView {
    
    @IBOutlet weak var imgError: UIImageView!
    @IBOutlet weak var lblErrorTitle: UILabel!
    @IBOutlet weak var lblErrorDesc: UILabel!
    @IBOutlet weak var btnRetry: RoundedCornerUIButton!
    @IBOutlet weak var widthConstraintForTryAgain: NSLayoutConstraint!
    
    static let shared = ErrorHandlerView()
    
    weak var delegate : ErrorHandlerDelegate?
    
    override func setupUI() {
        super.setupUI()
        lblErrorTitle.font = .Roboto.Bold.font(size: 16)
        lblErrorDesc.font = .Roboto.Regular.font(size: 14)
        lblErrorTitle.textColor = .black
        lblErrorDesc.textColor = .black
        btnRetry.titleLabel?.font = .Roboto.Bold.font(size: 16)
        btnRetry.titleLabel?.textColor = .black
    }

    override func setupLanguage() {
        super.setupLanguage()
        btnRetry.setTitle("Retry", for: .normal)
    }
    
    func setupView(isShow : Bool , errorVo : ErrorVO? , isServerError : Bool = false) {
        widthConstraintForTryAgain.constant = "Retry".size(withAttributes: [.font: UIFont.Roboto.Bold.font(size: 16)]).width + 20

        var error_image : UIImage?
        var error_title : String?
        var error_desc : String?
        var isInternetAvailable = Bool()
        
//        ApiClient.checkReachable(success: {
//            isInternetAvailable = true
//            if let error = errorVo {
//                error_image = UIImage(named: error.image ?? "")
//                error_title = error.title
//                error_desc = error.description
//                self.btnRetry.isHidden = true
//            } else {
//                error_image = #imageLiteral(resourceName: "ic_no_data")
//                error_title = LocalizedKey.ErrorHandlerView.noDataLabelTitle.localized()
//                error_desc = ""
//                self.btnRetry.isHidden = true
//            }
//        }) {
//            isInternetAvailable = false
//            error_image = #imageLiteral(resourceName: "ic_no_internet")
//            error_title = ""
//            error_desc = LocalizedKey.ErrorHandlerView.couldNotConnectLabelTitle.localized()
//            self.btnRetry.isHidden = false
//        }
//
//        if isServerError {
//            error_image = #imageLiteral(resourceName: "ic_no_server")
//            error_title = LocalizedKey.ErrorHandlerView.serverErrorLabelTitle.localized()
//            isInternetAvailable = false
//            error_desc = ""
//            self.btnRetry.isHidden = false
//        }
//        imgError.image = error_image
//        lblErrorTitle.text = error_title
//        lblErrorDesc.text = error_desc
//        btnRetry.isUserInteractionEnabled = true
    }

    func removeView() {
        removeFromSuperview()
    }
    
    override func bindData() {
        super.bindData()
    }
    
    @IBAction func onClickRetry(_ sender: Any) {
//        if ApiClient.checkReachable() {
//            removeView()
//            delegate?.didTapRetry()
//        }
        
    }
}



