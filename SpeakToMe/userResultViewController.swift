//
//  UserSubConetntsViewController.swift
//  TrainingProgram
//
//  Created by MAC User on 24/3/2018.
//  Copyright © 2018 Zhao Ruohan. All rights reserved.
//


import UIKit
import SQLite

class userResultViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    public var newUser = String()
    public var mainContens = [String]()
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
        self.tableView.registerCellNib(DataTableViewCell.self)
        
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
        
        //列出 userid 根目录
        let db = try! Connection("\(path)/db.sqlite3")
        let testResults = Table("testResults")
        let userid  = Expression<String>("userid")

        for user in try! db.prepare(testResults){
            self.mainContens.append(user[userid])
        }
        self.mainContens = Array(Set(self.mainContens)) //filter重复的
        self.tableView.reloadData()
        self.tableView.registerCellNib(DataTableViewCell.self)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


extension userResultViewController : UITableViewDelegate {
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
            let userid  = Expression<String>("userid")


            
            let currentCell = tableView.cellForRow(at: indexPath)! as! DataTableViewCell
            let currentText = currentCell.dataText?.text!
            let t = testResults.filter(userid == currentText!)
            
            try! db.run(t.delete())
            
            //            let sqliteSequence = Table("sqlite_sequence")
            //            try! db.run(sqliteSequence.delete())
            
            //refresh the page
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "userResultViewController") as! userResultViewController
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
        let userid  = Expression<String>("userid")

        
        //        //test
        //        print(self.mainContens)
        //        let seq       = Expression<Int>("id")
        //        for user in try! db.prepare(testResults){
        //            print(user[seq])
        //        }
        
        
        //choose base on contents(now row)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let subContentsVC = storyboard.instantiateViewController(withIdentifier: "ResultViewController") as! ResultViewController
        
        //ableView.registerCellNib(DataTableViewCell.self)
        //tableView.reloadData()
        
        let currentCell = tableView.cellForRow(at: indexPath)! as! DataTableViewCell
        let currentText = currentCell.dataText?.text!
        
        let t = testResults.filter(userid == currentText!)
        for user in try! db.prepare(t){
        //跳转到相应用户id的子目录
        subContentsVC.userID = user[userid]
        }
        self.navigationController?.pushViewController(subContentsVC, animated: true)
    }
}

extension userResultViewController : UITableViewDataSource {
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

extension userResultViewController : SlideMenuControllerDelegate {
    
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




