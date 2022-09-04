
import UIKit

extension UIFont {
    public enum Roboto: String {
       case Regular = "-Regular"
       case Italic = "-Italic"
       case Hairline = "-Hairline"
       case HairlineItalic = "-HairlineItalic"
       case Light = "-Light"
       case LightItalic = "-LightItalic"
       case Bold = "-Bold"
       case BoldItalic = "-BoldItalic"
       case Black = "-Black"
       case BlackItalic = "-BlackItalic"
       case Medium = "-Medium"
        
        public func font( size: CGFloat, autoAjust: Bool = true) -> UIFont {
            return UIFont.screenAdjustedAppFont(name: "Roboto\(self.rawValue)", size: size, autoAjust: autoAjust)
        }
    }
    
    class func screenAdjustedAppFont(name: String, size: CGFloat, autoAjust : Bool) -> UIFont {
        if !autoAjust { return UIFont(name: name, size: size)! }
        /* 1.4 ratio font for tablet ipad sizes**/
        if iOSDeviceSizes.tabletSize.getBool() {
            return UIFont(name: name, size: size * 1.4)!
        }else if iOSDeviceSizes.plusSize.getBool() {
            return UIFont(name: name, size: size * 1.2)!
        }else if iOSDeviceSizes.miniSize.getBool() {
            /* 0.9 ratio font for iphone SE and mini sizes**/
            return UIFont(name: name, size: size * 0.9)!
        } else {
            return UIFont(name: name, size: size)!
        }
    }
}

