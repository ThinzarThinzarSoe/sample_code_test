
import UIKit

@IBDesignable // to show in storyBoard
class RoundedCornerUIButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0
    @IBInspectable var shadowOffsetWidth: Int = 0
    @IBInspectable var shadowOffsetHeight: Int = 0
    @IBInspectable var shadowColor: UIColor? = UIColor.clear
    @IBInspectable var shadowOpacity: Float = 0
    @IBInspectable var borderWidth : CGFloat = 0
    @IBInspectable var borderColor : UIColor = .clear
    @IBInspectable var isCircle : Bool = false
    
    var direction: Direction = .topToBottom
    var gradientBackgroundColors : [UIColor] = []
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        (layer as! CAGradientLayer).colors = gradientBackgroundColors.map{$0.cgColor}
        switch direction {
        case .leftToRight:
            (layer as! CAGradientLayer).startPoint = CGPoint(x: 0.0, y: 0.5)
            (layer as! CAGradientLayer).endPoint = CGPoint(x: 1.0, y: 0.5)
        case .rightToLeft:
            (layer as! CAGradientLayer).startPoint = CGPoint(x: 1.0, y: 0.5)
            (layer as! CAGradientLayer).endPoint = CGPoint(x: 0.0, y: 0.5)
        case .bottomToTop:
            (layer as! CAGradientLayer).startPoint = CGPoint(x: 0.0, y: 1.0)
            (layer as! CAGradientLayer).endPoint = CGPoint(x: 0.0, y: 0.0)
        case .topToBottom:
            (layer as! CAGradientLayer).startPoint = CGPoint(x: 0.0, y: 0.0)
            (layer as! CAGradientLayer).endPoint = CGPoint(x: 0.0, y: 1.0)
        }
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
    
    func setTextImageCenter(image : UIImage , text : String , color : UIColor = .red) {
        
        self.setAttributedTitle(AttributedTextwithImageSuffix(AttributeImage: image, AttributedText: text , color : color), for: .normal)
    }
    
    func AttributedTextwithImageSuffix(AttributeImage : UIImage , AttributedText : String , color : UIColor) -> NSMutableAttributedString
    {
        let attributedString = NSMutableAttributedString(string: AttributedText + " ", attributes: [.underlineStyle: 0, NSAttributedString.Key.foregroundColor : color])
        let image1Attachment = NSTextAttachment()
        image1Attachment.bounds = CGRect(x: 0, y: ((self.titleLabel?.font.capHeight)! - AttributeImage.size.height).rounded() / 2, width: AttributeImage.size.width, height: AttributeImage.size.height)
        image1Attachment.image = AttributeImage
        let image1String = NSAttributedString(attachment: image1Attachment)
        attributedString.append(image1String)
        attributedString.append(NSAttributedString(string: ""))
        return attributedString
    }
}


