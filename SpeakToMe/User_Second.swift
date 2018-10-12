//
//  UserSubConetntsViewController.swift
//  TrainingProgram
//
//  Created by MAC User on 24/3/2018.
//  Copyright © 2018 Zhao Ruohan. All rights reserved.
//


import UIKit
import SQLite

class User_Second: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    public var mainContens = [String]()
    public var testTime = String()
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
        self.tableView.registerCellNib(DataTableViewCell.self)
        
        //self.addRightBarButtonWithImage(UIImage(named: "ic_notifications_black_24dp")!)
        //self.setNavigationBarItem()
        tableView.allowsMultipleSelectionDuringEditing = false
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.mainContens = []
        
        //list database all rows
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        
        //列出 userid 根目录
        let db = try! Connection("\(path)/db.sqlite3")
        let testResults = Table("testResults")
        let testTime = Expression<String>("testTime")
        let userid = Expression<String>("userid")
        
        //满足当天的用户都列出
        self.testTime = self.testTime + "%"
        let t = testResults.filter(testTime.like(self.testTime))
        
        for user in try! db.prepare(t){
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


extension User_Second : UITableViewDelegate {
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
            var id = String()
            
            
            
            let currentCell = tableView.cellForRow(at: indexPath)! as! DataTableViewCell
            let currentText = currentCell.dataText?.text!
            let t = testResults.filter(userid == currentText!)
            
            for user in try! db.prepare(t) {
                id = user[userid]
            }
            
            try! db.run(t.delete())
            
            //            let sqliteSequence = Table("sqlite_sequence")
            //            try! db.run(sqliteSequence.delete())
            
            //删除录音记录
            let fileMgr = FileManager()
            let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            if let directoryContents = try? fileMgr.contentsOfDirectory(atPath: dirPath)
            {
                for path in directoryContents
                {
                    let fullPath = (dirPath as NSString).appendingPathComponent(path)
                    do
                    {
                        if(path.prefix(id.count) == id){
                            try fileMgr.removeItem(atPath: fullPath)
                            print("Files deleted")}
                    }
                    catch let error as NSError
                    {
                        print("Error deleting: \(error.localizedDescription)")
                    }
                }
            }
            
            //refresh the page
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "User_First") as! User_First
            self.navigationController?.pushViewController(vc, animated: false)
            
            
        }
    }
    
    @objc(tableView:didSelectRowAtIndexPath:) func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //customize the chart based on indexPath(DB)
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        
        let db = try! Connection("\(path)/db.sqlite3")
        let testResults = Table("testResults")
        let userid  = Expression<String>("userid")
        
        
        //choose base on contents(now row)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let user_third = storyboard.instantiateViewController(withIdentifier: "User_Third") as! User_Third
        
        let currentCell = tableView.cellForRow(at: indexPath)! as! DataTableViewCell
        let currentText = currentCell.dataText?.text!
        
        let t = testResults.filter(userid == currentText!)
        for user in try! db.prepare(t){
            //跳转到相应用户id的子目录
            user_third.userID = user[userid]
        }
        self.navigationController?.pushViewController(user_third, animated: true)
    }
}
    

    
    
 

extension User_Second : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mainContens.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: DataTableViewCell.identifier) as! DataTableViewCell
        let data = DataTableViewCellData(imageUrl: "user", text: mainContens[indexPath.row])
        cell.setData(data)
        return cell
    }
}

extension User_Second : SlideMenuControllerDelegate {
    
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




