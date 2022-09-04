
import Foundation
import SwiftyJSON

extension NSDictionary {
    var data : Data? {
        guard let jsonString = JSON(self).rawString() else {return nil}
        return Data(jsonString.utf8)
    }
}
