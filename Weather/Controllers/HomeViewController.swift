import UIKit
import MapKit
import CoreData

class HomeViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var btnHelp: UIBarButtonItem!
    @IBOutlet weak var btnSettings: UIBarButtonItem!
    
    let locationManager = CLLocationManager()
    let cellIdentifier = Constants.AppKeyAndUrls.cellIdentifier
    var fetchedResultsController: NSFetchedResultsController<Temperature>!
    var container: NSPersistentContainer!
    let viewModel = WeatherViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnHelp.tintColor = UIColor.appColor(.icons)
        btnSettings.tintColor = UIColor.appColor(.icons)

        // Load Container
        container = NSPersistentContainer(name: "Weather")
        container.loadPersistentStores { storeDescription, error in
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            if let error = error {
                print("Unresolved error \(error)")
            }
        }
        
        // Load data
        loadSavedData()
        
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
    }
    
    // Load saved data from Core Data
    func loadSavedData() {
        if fetchedResultsController == nil {
            let request = Temperature.createFetchRequest()
            let sort = NSSortDescriptor(key: "city", ascending: true)
            request.sortDescriptors = [sort]
            request.fetchBatchSize = 20
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: container.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultsController.delegate = self
        }
        
        do {
            try fetchedResultsController.performFetch()
            showAnnotations()
            tblView.reloadData()
        } catch {
            print("Fetch failed")
        }
    }
    
    // Save Context
    func saveContext() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
    }
    
    // Add annotation on tap
    @objc func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        let point = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
        // Add annotation:
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        
        viewModel.getWeatherDataForCity(lat: coordinate.latitude, long: coordinate.longitude) { weather in
            // Get city name from Reverese Geo coding
            let geoCoder = CLGeocoder()
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            
            geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                
                // Place details
                var placeMark: CLPlacemark!
                placeMark = placemarks?[0]
                
                // City
                if let city = placeMark.subAdministrativeArea as String? {
                    print(city)
                    annotation.title = city
                    
                    let temperature = Temperature(context: self.container.viewContext)
                    temperature.city = "\(city)"
                    temperature.lat = coordinate.latitude
                    temperature.long = coordinate.longitude
                    temperature.temperature = weather.main!.temp!
                    temperature.icon = weather.weather?.first?.icon!
                    
                    self.saveContext()
                    self.loadSavedData()
                }
            })
            print("Recieved response")
        }
    }
    
    // Show all annotations
    func showAnnotations() {
        if let weatherInfoObjects = fetchedResultsController.fetchedObjects {
            
            for weatherInfo in weatherInfoObjects {

                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: weatherInfo.lat, longitude: weatherInfo.long)
                mapView.addAnnotation(annotation)
            }
        }
    }
}

extension HomeViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        //        mapView.camera.centerCoordinate = locValue
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
        return 70
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier.rawValue) as? WeatherCustomCell
        
        let weatherInfo = fetchedResultsController.object(at: indexPath)
        cell?.lblCity.textColor = UIColor.appColor(.title)
        cell?.lblCityTemp.textColor = UIColor.appColor(.temperature)
        cell?.lblCity.text = weatherInfo.city
        cell?.lblCityTemp.text = "\(weatherInfo.temperature)"
        
        if let url = URL(string: Constants.AppKeyAndUrls.imageUrl.rawValue + weatherInfo.icon! + "@2x.png") {
            cell?.imgViewWeather.load(url: url)
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: Constants.SegueId.DetailVCSegue.rawValue, sender: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let temperature = fetchedResultsController.object(at: indexPath)
            container.viewContext.delete(temperature)
            saveContext()
        }
    }
}

extension HomeViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            tblView.deleteRows(at: [indexPath!], with: .automatic)
            
        default:
            break
        }
    }
}

class WeatherCustomCell: UITableViewCell {
    @IBOutlet weak var imgViewWeather: UIImageView!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblCityTemp: UILabel!
}

