
import UIKit
import NVActivityIndicatorView

extension UIViewController {
    
    var topBarHeight: CGFloat {
        var top = self.navigationController?.navigationBar.frame.height ?? 0.0
        if #available(iOS 13.0, *) {
            top += UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            top += UIApplication.shared.statusBarFrame.height
        }
        return top
    }
    
    func setupNavigationTitle(isContainLargeTitle : Bool = false, title : String , color : UIColor = .clear) {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): color,NSAttributedString.Key.font: UIFont.Roboto.Bold.font(size: 16)]
        navigationController?.navigationBar.prefersLargeTitles = isContainLargeTitle
        if isContainLargeTitle {
            navigationController?.navigationBar.topItem?.title = title
        }else{
            if let vc = navigationController?.viewControllers.first, vc == self {
                navigationItem.title = title
            }else{
                self.title = title
            }
        }
    }
        
    func getImageFrom(layer : CALayer) -> UIImage? {
        var navigateionImage:UIImage?
        UIGraphicsBeginImageContext(layer.frame.size)
        if let context = UIGraphicsGetCurrentContext() {
            layer.render(in: context)
            navigateionImage = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
        }
        UIGraphicsEndImageContext()
        return navigateionImage
    }

    func addBackButton(color : UIColor = UIColor.black , image : UIImage = UIImage(named: "ic_back_arrow") ?? UIImage() , backgroundColor : UIColor = UIColor.clear) {
        let backBtn = RoundedCornerUIButton(type: .custom)
        backBtn.shadowColor = .clear
        backBtn.borderColor = .clear
        backBtn.cornerRadius = 10
        backBtn.contentMode = .left
        backBtn.backgroundColor = backgroundColor
        backBtn.setImage(image, for: .normal)
        if UIDevice.is_iPadDevice() {
            backBtn.frame = CGRect(x: 10, y: 0, width: 40, height: 40)
        }
        else {
            backBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        }
        
        backBtn.addTarget(self, action: #selector(didTapBackBtn), for: .touchUpInside)
        backBtn.tintColor = color
        let backBarBtnItem = UIBarButtonItem(customView: backBtn)
        navigationItem.leftBarButtonItem = backBarBtnItem
    }
    
    @objc func didTapBackBtn() {
        navigationController?.popViewController(animated: true)
    }
    
    func showNoInternetConnectionToast(){
        showToast(message: "No Internet")
    }
    
    func showToast(message : String ,
                   bottomConstraint : CGFloat = 0,
                   isShowing : ( () -> Void)? = nil ,
                   completion : ( () -> Void)? = nil) {
        let toastLabel = UILabel()
        toastLabel.text = message
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.numberOfLines = 0
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        let maximumLabelSize: CGSize = CGSize(width: 280, height: 300)
        let expectedLabelSize: CGSize = toastLabel.sizeThatFits(maximumLabelSize)
        var newFrame: CGRect = toastLabel.frame
        newFrame.size.height = expectedLabelSize.height + 10
        newFrame.size.width = expectedLabelSize.width + 40
        newFrame.origin.y = UIScreen.main.bounds.height - newFrame.size.height - (UIScreen.main.bounds.height / 9) - bottomConstraint
        newFrame.origin.x = UIScreen.main.bounds.width/2 - (newFrame.size.width/2)
        toastLabel.frame = newFrame
        toastLabel.clipsToBounds  =  true
        
        if #available(iOS 13.0, *) {
            let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
            
            keyWindow?.addSubview(toastLabel)
        } else {
            let window = UIApplication.shared.keyWindow
            window?.addSubview(toastLabel)
        }
        
        UIView.animate(withDuration: 3, delay: 0.5, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
            if let showing = isShowing {
                showing()
            }
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
            if let completion = completion {
                completion()
            }
        })
    }
}

// Note: this is for Loading View
extension UIViewController : NVActivityIndicatorViewable, UIGestureRecognizerDelegate {
    func showLoading(message : String = "") {
        startAnimating(CGSize(width: 30, height: 30), message: message, type: .lineSpinFadeLoader)
    }
    
    func hideLoading() {
        stopAnimating()
    }
}

