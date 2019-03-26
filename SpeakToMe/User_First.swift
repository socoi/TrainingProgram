//
//  User_First.swift
//  TrainingProgram
//
//  Created by MAC User on 24/3/2018.
//  Copyright © 2018 Zhao Ruohan. All rights reserved.
//

import UIKit
import SQLite

class User_First: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    public var mainContens = [String]()
    public var testTime = [String]()
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
        self.tableView.registerCellNib(DataTableViewCell.self)
        
        self.addRightBarButtonWithImage(UIImage(named: "upload")!)
        self.setNavigationBarItem()
        tableView.allowsMultipleSelectionDuringEditing = false
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.setNavigationBarItem()  //不显示删除信息
        
        self.mainContens = []
        self.testTime = []
        
        //list database all rows
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        
        //列出 userid 根目录
        let db = try! Connection("\(path)/db.sqlite3")
        let testResults = Table("testResults")
        let testTime  = Expression<String>("testTime")
        
        for user in try! db.prepare(testResults){
            let t = user[testTime].components(separatedBy: ",") //格式是日期 + 当天时间
            self.mainContens.append(change_Date(date: t[0], change: true))
            self.testTime.append(user[testTime])
        }
        
        self.mainContens = Array(Set(self.mainContens)) //filter重复的
        self.mainContens = self.mainContens.sorted{$0.localizedStandardCompare($1) == .orderedAscending}
        
        self.tableView.reloadData()
        self.tableView.registerCellNib(DataTableViewCell.self)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


extension User_First : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DataTableViewCell.height()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return YES if you want the specified item to be editable.
        return false
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //customize the chart based on indexPath(DB)
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        
        let db = try! Connection("\(path)/db.sqlite3")
        let testResults = Table("testResults")
        let testTime  = Expression<String>("testTime")
        
        
        //choose base on contents(now row)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let user_second = storyboard.instantiateViewController(withIdentifier: "User_Second") as! User_Second
        let currentCell = tableView.cellForRow(at: indexPath)! as! DataTableViewCell
        let currentText = change_Date(date: (currentCell.dataText?.text!)! , change: false )
        
        let t = testResults.filter(testTime.like(currentText + "%")) //like
        for _ in try! db.prepare(t){
            //跳转到相应用户id的子目录
            user_second.testTime = currentText //只有当天日期
        }
        self.navigationController?.pushViewController(user_second, animated: true)
    }
}

extension User_First : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mainContens.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: DataTableViewCell.identifier) as! DataTableViewCell
        let data = DataTableViewCellData(imageUrl: "folder", text: mainContens[indexPath.row])
        cell.setData(data)
        return cell
    }
}

//extension User_First : SlideMenuControllerDelegate {
//
//    func leftWillOpen() {
//        print("SlideMenuControllerDelegate: leftWillOpen")
//    }
//
//    func leftDidOpen() {
//        print("SlideMenuControllerDelegate: leftDidOpen")
//    }
//
//    func leftWillClose() {
//        print("SlideMenuControllerDelegate: leftWillClose")
//    }
//
//    func leftDidClose() {
//        print("SlideMenuControllerDelegate: leftDidClose")
//    }
//
//    func rightWillOpen() {
//        print("SlideMenuControllerDelegate: rightWillOpen")
//    }
//
//    func rightDidOpen() {
//        print("SlideMenuControllerDelegate: rightDidOpen")
//    }
//
//    func rightWillClose() {
//        print("SlideMenuControllerDelegate: rightWillClose")
//    }
//
//    func rightDidClose() {
//        print("SlideMenuControllerDelegate: rightDidClose")
//    }
//}

