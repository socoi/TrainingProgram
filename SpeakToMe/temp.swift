//
//  SlideMenuControllerSwift
//


import UIKit

class temp: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.performSegue(withIdentifier: "MNReadDemo", sender: self)
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
    }
}
