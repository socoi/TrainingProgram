//
//  ResultViewController.swift
//  TrainingProgram
//
//  Created by MAC User on 14/2/2017.
//  Copyright © 2017 Zhao Ruohan. All rights reserved.
//

import UIKit
import SQLite

class ResultViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    public var newUser = String()
    public var mainContens = [String]()
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addRightBarButtonWithImage(UIImage(named: "ic_notifications_black_24dp")!)
        
        tableView.allowsMultipleSelectionDuringEditing = false

    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
        
        self.mainContens = []
        
        //list database all rows
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        
        let db = try! Connection("\(path)/db.sqlite3")
        let testResults = Table("testResults")
        let details  = Expression<String>("details")
        
        for user in try! db.prepare(testResults){
            self.mainContens.append(user[details])
        }
        self.tableView.reloadData()
        self.tableView.registerCellNib(DataTableViewCell.self)
        
         }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


extension ResultViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DataTableViewCell.height()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return YES if you want the specified item to be editable.
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == UITableViewCellEditingStyle.delete) {
            
            //when you hit delete( base on contents delete)
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true
                ).first!
            let db = try! Connection("\(path)/db.sqlite3")
            let testResults = Table("testResults")
            let details       = Expression<String>("details")
            
            let currentCell = tableView.cellForRow(at: indexPath)! as! DataTableViewCell
            let currentText = currentCell.dataText?.text!
            
            let t = testResults.filter(details == currentText!)

            try! db.run(t.delete())
            
//            let sqliteSequence = Table("sqlite_sequence")
//            try! db.run(sqliteSequence.delete())
            
            //refresh the page
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ResultViewController") as! ResultViewController
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //customize the chart based on indexPath(DB)
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        
        let db = try! Connection("\(path)/db.sqlite3")
        let testResults = Table("testResults")
        let details = Expression<String>("details")
        let timeSpent1 = Expression<Double>("timeSpent1")
        let timeSpent2 = Expression<Double>("timeSpent2")
        let timeSpent3 = Expression<Double>("timeSpent3")
        let timeSpent4 = Expression<Double>("timeSpent4")
        let timeSpent5 = Expression<Double>("timeSpent5")
        let timeSpent6 = Expression<Double>("timeSpent6")
        let timeSpent7 = Expression<Double>("timeSpent7")
        let timeSpent8 = Expression<Double>("timeSpent8")
        let timeSpent9 = Expression<Double>("timeSpent9")
        let timeSpent10 = Expression<Double>("timeSpent10")
        let timeSpent11 = Expression<Double>("timeSpent11")
        let timeSpent12 = Expression<Double>("timeSpent12")
        let timeSpent13 = Expression<Double>("timeSpent13")
        let timeSpent14 = Expression<Double>("timeSpent14")
        let timeSpent15 = Expression<Double>("timeSpent15")
        let timeSpent16 = Expression<Double>("timeSpent16")
        let timeSpent17 = Expression<Double>("timeSpent17")
        let timeSpent18 = Expression<Double>("timeSpent18")
        let timeSpent19 = Expression<Double>("timeSpent19")
        let distanceVary = Expression<Double>("distanceVary")
        
        
//        //test
//        print(self.mainContens)
//        let seq       = Expression<Int>("id")
//        for user in try! db.prepare(testResults){
//            print(user[seq])
//        }
        
        
        //choose base on contents(now row)
        let storyboard = UIStoryboard(name: "SubContentsViewController", bundle: nil)
        let subContentsVC = storyboard.instantiateViewController(withIdentifier: "SubContentsViewController") as! SubContentsViewController
        
        //ableView.registerCellNib(DataTableViewCell.self)
        //tableView.reloadData()
        
        let currentCell = tableView.cellForRow(at: indexPath)! as! DataTableViewCell
        let currentText = currentCell.dataText?.text!
        
        let t = testResults.filter(details == currentText!)
        subContentsVC.yLabel = []
        
        for user in try! db.prepare(t){
            subContentsVC.yLabel.append(user[timeSpent1])
            subContentsVC.yLabel.append(user[timeSpent2])
            subContentsVC.yLabel.append(user[timeSpent3])
            subContentsVC.yLabel.append(user[timeSpent4])
            subContentsVC.yLabel.append(user[timeSpent5])
            subContentsVC.yLabel.append(user[timeSpent6])
            subContentsVC.yLabel.append(user[timeSpent7])
            subContentsVC.yLabel.append(user[timeSpent8])
            subContentsVC.yLabel.append(user[timeSpent9])
            subContentsVC.yLabel.append(user[timeSpent10])
            subContentsVC.yLabel.append(user[timeSpent11])
            subContentsVC.yLabel.append(user[timeSpent12])
            subContentsVC.yLabel.append(user[timeSpent13])
            subContentsVC.yLabel.append(user[timeSpent14])
            subContentsVC.yLabel.append(user[timeSpent15])
            subContentsVC.yLabel.append(user[timeSpent16])
            subContentsVC.yLabel.append(user[timeSpent17])
            subContentsVC.yLabel.append(user[timeSpent18])
            subContentsVC.yLabel.append(user[timeSpent19])
            subContentsVC.distanceVary = user[distanceVary]
        }
        self.navigationController?.pushViewController(subContentsVC, animated: true)
    }
}

extension ResultViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mainContens.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: DataTableViewCell.identifier) as! DataTableViewCell
        let data = DataTableViewCellData(imageUrl: "dummy", text: mainContens[indexPath.row])
        cell.setData(data)
        return cell
    }
}

extension ResultViewController : SlideMenuControllerDelegate {
    
    func leftWillOpen() {
        print("SlideMenuControllerDelegate: leftWillOpen")
    }
    
    func leftDidOpen() {
        print("SlideMenuControllerDelegate: leftDidOpen")
    }
    
    func leftWillClose() {
        print("SlideMenuControllerDelegate: leftWillClose")
    }
    
    func leftDidClose() {
        print("SlideMenuControllerDelegate: leftDidClose")
    }
    
    func rightWillOpen() {
        print("SlideMenuControllerDelegate: rightWillOpen")
    }
    
    func rightDidOpen() {
        print("SlideMenuControllerDelegate: rightDidOpen")
    }
    
    func rightWillClose() {
        print("SlideMenuControllerDelegate: rightWillClose")
    }
    
    func rightDidClose() {
        print("SlideMenuControllerDelegate: rightDidClose")
    }
}



