
import Foundation
import UIKit

@IBDesignable // to show in storyBoard
class CardView: UIView {
    
    @IBInspectable var shadowCornerRadius : CGFloat = 0
    @IBInspectable var shadowOffsetWidth : Int = 0
    @IBInspectable var shadowOffsetHeight : Int = 0
    @IBInspectable var showColor : UIColor? = UIColor.clear
    @IBInspectable var shadowOpacity : Float = 0
    @IBInspectable var borderWidth :  CGFloat = 0.0
    @IBInspectable var borderColor :  UIColor? = UIColor.clear
    @IBInspectable var cornerRadius: CGFloat = 0
    @IBInspectable var isCircle : Bool = false
    @IBInspectable var isDashBorder : Bool = false
    @IBInspectable var dashBorderFillColor :  UIColor? = UIColor.clear
    @IBInspectable var dashBorderStrokeColor :  UIColor? = UIColor.clear
    @IBInspectable var dashBorderLineWidth :  CGFloat = 0.0
    @IBInspectable var dashBorderLinePattern :  [NSNumber] = []
    
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
            (layer as! CAGradientLayer).startPoint = CGPoint(x: 0.5, y: 1.0)
            (layer as! CAGradientLayer).endPoint = CGPoint(x: 0.5, y: 0.0)
        case .topToBottom:
            (layer as! CAGradientLayer).startPoint = CGPoint(x: 0.0, y: 0.0)
            (layer as! CAGradientLayer).endPoint = CGPoint(x: 0.0, y: 1.0)
        }
        
        layer.cornerRadius = isCircle ? frame.size.height / 2 : cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor?.cgColor
        
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: shadowCornerRadius)
        
        layer.masksToBounds = false
        layer.shadowColor = showColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
        if isDashBorder {
            addDashedBorder()
        }
    }
    
    func addDashedBorder() {
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = dashBorderFillColor?.cgColor
        shapeLayer.strokeColor = dashBorderStrokeColor?.cgColor
        shapeLayer.lineWidth = dashBorderLineWidth
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = dashBorderLinePattern
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: isCircle ? frame.size.height / 2 : cornerRadius).cgPath
        self.layer.addSublayer(shapeLayer)
    }
}
