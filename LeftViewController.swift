//
//  LeftViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 12/3/14.
//

import UIKit

enum LeftMenu: Int {
    case main = 0
    case Demo
    case MNRead
    case go
    case ResultView
}

protocol LeftMenuProtocol : class {
    func changeViewController(_ menu: LeftMenu)
}

class LeftViewController : UIViewController, LeftMenuProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    var menus = ["Main", "MNRead Demo", "MNRead", "Spatial Training", "Test Results"]
    var mainViewController: UIViewController!
    var swiftViewController: UIViewController!
    var DemoViewController: UIViewController!
    var goViewController: UIViewController!
    var resultViewController: UIViewController!
    var imageHeaderView: ImageHeaderView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let swiftViewController = storyboard.instantiateViewController(withIdentifier: "MNReadViewController") as! MNReadViewController
        self.swiftViewController = UINavigationController(rootViewController: swiftViewController)
        
        let DemoViewController = storyboard.instantiateViewController(withIdentifier: "DemoViewController") as! DemoViewController
        self.DemoViewController = UINavigationController(rootViewController: DemoViewController)
        
        let goViewController = storyboard.instantiateViewController(withIdentifier: "GoViewController") as! GoViewController
        self.goViewController = UINavigationController(rootViewController: goViewController)
        
        let resultViewController = storyboard.instantiateViewController(withIdentifier: "User_First") as! User_First
        
        //resultViewController.delegate = self
        self.resultViewController = UINavigationController(rootViewController: resultViewController)
        
        self.tableView.registerCellClass(BaseTableViewCell.self)
        
        self.imageHeaderView = ImageHeaderView.loadNib()
        self.view.addSubview(self.imageHeaderView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.imageHeaderView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 160)
        self.view.layoutIfNeeded()
    }
    
    func changeViewController(_ menu: LeftMenu) {
        switch menu {
        case .main:
            self.slideMenuController()?.changeMainViewController(self.mainViewController, close: true)
        case .MNRead:
            self.slideMenuController()?.changeMainViewController(self.swiftViewController, close: true)
        case .Demo:
            //重新初始化，demo跳转立刻开始测试
            let DemoViewController = storyboard?.instantiateViewController(withIdentifier: "DemoViewController") as! DemoViewController
            self.DemoViewController = UINavigationController(rootViewController: DemoViewController)
            //self.dismiss(animated: true, completion: {})
            self.slideMenuController()?.changeMainViewController(self.DemoViewController, close: true)
        case .go:
            self.slideMenuController()?.changeMainViewController(self.goViewController, close: true)
        case .ResultView:
            self.slideMenuController()?.changeMainViewController(self.resultViewController, close: true)
        }
    }
}

extension LeftViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let menu = LeftMenu(rawValue: indexPath.row) {
            switch menu {
            case .main,.Demo,.MNRead,.go, .ResultView:
                return BaseTableViewCell.height()
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let menu = LeftMenu(rawValue: indexPath.row) {
            self.changeViewController(menu)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.tableView == scrollView {
            
        }
    }
}

extension LeftViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let menu = LeftMenu(rawValue: indexPath.row) {
            switch menu {
            case .main, .Demo, .MNRead , .go, .ResultView:
                let cell = BaseTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: BaseTableViewCell.identifier)
                cell.setData(menus[indexPath.row])
                return cell
            }
        }
        return UITableViewCell()
    }
    
    
}
