import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func changeTheme(_ sender: UISwitch) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
           return
        }
        appDelegate.changeTheme(preference: sender.isOn ? "dark" : "light")
    }
}
