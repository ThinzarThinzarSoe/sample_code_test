
import UIKit

@IBDesignable
class RoundedUIImageView: UIImageView {

    @IBInspectable var cornerRadius: CGFloat = 2
    @IBInspectable var borderWidth : CGFloat = 0
    @IBInspectable var borderColor : UIColor = UIColor.clear
    @IBInspectable var isCircle : Bool = false
    @IBInspectable var shadowOffsetWidth: Int = 0
    @IBInspectable var shadowOffsetHeight: Int = 0
    @IBInspectable var shadowColor: UIColor? = UIColor.clear
    @IBInspectable var shadowOpacity: Float = 0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = isCircle ? frame.size.height / 2 : cornerRadius
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
        
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius)
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
        super.layoutSubviews()
    }
    
    @available(iOS 13.0, *)
    func setupBlurEffect (style : UIBlurEffect.Style = .systemThinMaterialDark , alpha : CGFloat = 0.7) {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = alpha
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        addSubview(blurEffectView)
    }
}
