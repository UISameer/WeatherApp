import Foundation

import Foundation

import UIKit

typealias completionFetchCityWeather =  (_ result: CurrentWeather) -> Void

class WeatherViewModel: NetworkService {

    func getWeatherDataForCity(lat: Double, long: Double, completionHandler: @escaping completionFetchCityWeather) {
      
        self.setLatitude("\(lat)")
        self.setLongitude("\(long)")
        
        self.request { weather in
            completionHandler(weather)
        } onError: { error in
            print(error)
        }
    }
}
