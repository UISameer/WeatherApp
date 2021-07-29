import UIKit
import MapKit

class HomeViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tblView: UITableView!
    
    let locationManager = CLLocationManager()
    var arrayCityWeather = [CurrentWeather]()
    let cellIdentifier = "CustomWeatherCellIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide extra rows
        tblView.tableFooterView = UIView()
        
        // Ask for Authorization from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        let gestureRecognizer = UITapGestureRecognizer(
                                      target: self, action:#selector(handleTap))
            gestureRecognizer.delegate = self
            mapView.addGestureRecognizer(gestureRecognizer)
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        NetworkService.shared.request { weather in
            self.arrayCityWeather.append(weather)
            self.reloadData()
            print("Recieved response")
        } onError: { error in
            print("Error in response")
        }
    }
    
    // Reload table view
    func reloadData(){
        DispatchQueue.main.async {
            self.tblView.reloadData()
        }
    }
    
    // Add annotation on tap
    @objc func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        // Add annotation:
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }
}

extension HomeViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        mapView.camera.centerCoordinate = locValue
    }
    
    private func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("error::: \(error)")
        locationManager.stopUpdatingLocation()
        let alert = UIAlertController(title: "Settings", message: "Allow location from settings", preferredStyle: UIAlertController.Style.alert)
        self.present(alert, animated: true, completion: nil)
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { action in
            switch action.style{
            case .default: UIApplication.shared.open(NSURL(string: UIApplication.openSettingsURLString)! as URL)
            case .cancel: print("cancel")
            case .destructive: print("destructive")
            @unknown default: break
            }
        }))
    }
}

extension HomeViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayCityWeather.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? WeatherCustomCell
        
        let weatherInfo = self.arrayCityWeather[indexPath.row]
        cell?.lblCity.text = weatherInfo.name
        cell?.lblCityTemp.text = "\(String(describing: weatherInfo.main?.temp))"
        
        if let url = URL(string: Constants.AppKeyAndUrls.imageUrl.rawValue + (weatherInfo.weather?.first?.icon)! + ".png") {
            cell?.imgViewWeather.load(url: url)
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: Constants.SegueId.DetailVCSegue.rawValue, sender: indexPath.row)
    }
}

class WeatherCustomCell: UITableViewCell {
    @IBOutlet weak var imgViewWeather: UIImageView!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblCityTemp: UILabel!
}

