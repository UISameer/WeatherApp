import UIKit

class DetailViewController: UIViewController {

    var detailItem: Temperature?
    
    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var lblHumidity: UILabel!
    @IBOutlet weak var lblCloud: UILabel!
    @IBOutlet weak var lblWind: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblTemp.text = "\(detailItem!.temperature)"
        lblHumidity.text = "\(detailItem!.humidity)"
        lblCloud.text = detailItem!.clouds
        lblWind.text = "\(detailItem!.windSpeed)"

    }
}
