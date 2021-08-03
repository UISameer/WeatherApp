import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var themeSwitcher: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        themeSwitcher.isOn = UIApplication.shared.keyWindow?.overrideUserInterfaceStyle == .dark ? true : false
    }
    
    @IBAction func changeTheme(_ sender: UISwitch) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
           return
        }
        appDelegate.changeTheme(preference: sender.isOn ? "dark" : "light")
    }
}
