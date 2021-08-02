import Foundation
import UIKit

public struct Constants {
    
    enum AppKeyAndUrls: String {
        case baseURL = "https://api.openweathermap.org/data/2.5/weather?"
        case appKey = "fae7190d7e6433ec3a45285ffcf55c86"
        case imageUrl = "http://openweathermap.org/img/wn/"
        
        case cellIdentifier = "CustomWeatherCellIdentifier"
    }
    
    enum SegueId: String {
        case DetailVCSegue = "DetailVCSegue"
    }
}

// For theme switching
enum AssetsColor : String {
  case title
  case temperature
  case icons
}

extension UIColor {
  static func appColor(_ name: AssetsColor) -> UIColor? {
     return UIColor(named: name.rawValue)
  }
}
