import Foundation
import UIKit

public struct Constants {
    
    enum AppKeyAndUrls: String {
        case baseURL = "https://api.openweathermap.org/data/2.5/weather?"
        case appKey = "fae7190d7e6433ec3a45285ffcf55c86"
    }
    
    enum SegueId: String {
        case DetailVCSegue = "DetailVCSegue"
    }
}
