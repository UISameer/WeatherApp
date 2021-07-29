import Foundation

protocol NetworkManager {
    func request(onSuccess: @escaping (CurrentWeather) -> Void, onError: @escaping (String) -> Void)
}

class NetworkService: NetworkManager {
    
    static let shared = NetworkService()
    
    var URL_LATITUDE = "35"
    var URL_LONGITUDE = "139"
    var URL_GET = ""
    
    let session = URLSession(configuration: .default)
    
    func buildURL() -> String {
        URL_GET = "lat=" + URL_LATITUDE + "&lon=" + URL_LONGITUDE + "&appid=" + Constants.AppKeyAndUrls.appKey.rawValue
        return Constants.AppKeyAndUrls.baseURL.rawValue + URL_GET
    }
    
    func setLatitude(_ latitude: String) {
        URL_LATITUDE = latitude
    }
    
    func setLatitude(_ latitude: Double) {
        setLatitude(String(latitude))
    }
    
    func setLongitude(_ longitude: String) {
        URL_LONGITUDE = longitude
    }
    
    func setLongitude(_ longitude: Double) {
        setLongitude(String(longitude))
    }
    
    public func request(onSuccess: @escaping (CurrentWeather) -> Void, onError: @escaping (String) -> Void)  {
        
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession.init(configuration: configuration)
        let urlRequest = URLRequest.init(url: URL(string: buildURL())!)
        
        session.dataTask(with: urlRequest) { data, response, error in
            
            DispatchQueue.main.async {
                if let error = error {
                    onError(error.localizedDescription)
                    return
                }
                
                guard let data = data, let response = response as? HTTPURLResponse else {
                    onError("Invalid data or response")
                    return
                }
                
                do {
                    if response.statusCode == 200 {
                        let items = try JSONDecoder().decode(CurrentWeather.self, from: data)
                        onSuccess(items)
                    } else {
                        onError("Response wasn't 200. It was: " + "\n\(response.statusCode)")
                    }
                } catch {
                    onError(error.localizedDescription)
                }
            }
        }.resume()
        
        
//        Alamofire.AF.request(router.urlRequest).validate().responseJSON { (response) in
//
//            switch response.result {
//                case .success:
//                    print("Validation Successful")
//
//                    if let value = response.value {
//                        print(value)
//                        completionHandler(value as AnyObject)
//                    }
//
//                case .failure(let error):
//                    print(error)
//                    completionHandler(error as AnyObject)
//            }
//        }
        
    }
}
