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
    public var userID = String()
    public var mainContens = [String]()
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
        self.tableView.registerCellNib(DataTableViewCell.self)
        tableView.allowsMultipleSelectionDuringEditing = false

    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.mainContens = []
        
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        
        let db = try! Connection("\(path)/db.sqlite3")
        let testResults = Table("testResults")
        let details  = Expression<String>("details")
        let userid = Expression<String>("userid")
        
        //只显示对应用户id的信息
        let t = testResults.filter(userid == self.userID)
        for user in try! db.prepare(t){
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
        
        let costTime1 = Expression<Double>("costTime1")   //每段话读取（准确时间）
        let costTime2 = Expression<Double>("costTime2")
        let costTime3 = Expression<Double>("costTime3")
        let costTime4 = Expression<Double>("costTime4")
        let costTime5 = Expression<Double>("costTime5")
        let costTime6 = Expression<Double>("costTime6")
        let costTime7 = Expression<Double>("costTime7")
        let costTime8 = Expression<Double>("costTime8")
        let costTime9 = Expression<Double>("costTime9")
        let costTime10 = Expression<Double>("costTime10")
        let costTime11 = Expression<Double>("costTime11")
        let costTime12 = Expression<Double>("costTime12")
        let costTime13 = Expression<Double>("costTime13")
        let costTime14 = Expression<Double>("costTime14")
        let costTime15 = Expression<Double>("costTime15")
        let costTime16 = Expression<Double>("costTime16")
        let costTime17 = Expression<Double>("costTime17")
        let costTime18 = Expression<Double>("costTime18")
        let costTime19 = Expression<Double>("costTime19")
        
        let readChart1 = Expression<String>("readChart1")
        let readChart2 = Expression<String>("readChart2")
        let readChart3 = Expression<String>("readChart3")
        let readChart4 = Expression<String>("readChart4")
        let readChart5 = Expression<String>("readChart5")
        let readChart6 = Expression<String>("readChart6")
        let readChart7 = Expression<String>("readChart7")
        let readChart8 = Expression<String>("readChart8")
        let readChart9 = Expression<String>("readChart9")
        let readChart10 = Expression<String>("readChart10")
        let readChart11 = Expression<String>("readChart11")
        let readChart12 = Expression<String>("readChart12")
        let readChart13 = Expression<String>("readChart13")
        let readChart14 = Expression<String>("readChart14")
        let readChart15 = Expression<String>("readChart15")
        let readChart16 = Expression<String>("readChart16")
        let readChart17 = Expression<String>("readChart17")
        let readChart18 = Expression<String>("readChart18")
        let readChart19 = Expression<String>("readChart19")
        
        let errorWord1 = Expression<String>("errorWord1")
        let errorWord2 = Expression<String>("errorWord2")
        let errorWord3 = Expression<String>("errorWord3")
        let errorWord4 = Expression<String>("errorWord4")
        let errorWord5 = Expression<String>("errorWord5")
        let errorWord6 = Expression<String>("errorWord6")
        let errorWord7 = Expression<String>("errorWord7")
        let errorWord8 = Expression<String>("errorWord8")
        let errorWord9 = Expression<String>("errorWord9")
        let errorWord10 = Expression<String>("errorWord10")
        let errorWord11 = Expression<String>("errorWord11")
        let errorWord12 = Expression<String>("errorWord12")
        let errorWord13 = Expression<String>("errorWord13")
        let errorWord14 = Expression<String>("errorWord14")
        let errorWord15 = Expression<String>("errorWord15")
        let errorWord16 = Expression<String>("errorWord16")
        let errorWord17 = Expression<String>("errorWord17")
        let errorWord18 = Expression<String>("errorWord18")
        let errorWord19 = Expression<String>("errorWord19")
        
        let errorNum1 = Expression<Int>("errorNum1")
        let errorNum2 = Expression<Int>("errorNum2")
        let errorNum3 = Expression<Int>("errorNum3")
        let errorNum4 = Expression<Int>("errorNum4")
        let errorNum5 = Expression<Int>("errorNum5")
        let errorNum6 = Expression<Int>("errorNum6")
        let errorNum7 = Expression<Int>("errorNum7")
        let errorNum8 = Expression<Int>("errorNum8")
        let errorNum9 = Expression<Int>("errorNum9")
        let errorNum10 = Expression<Int>("errorNum10")
        let errorNum11 = Expression<Int>("errorNum11")
        let errorNum12 = Expression<Int>("errorNum12")
        let errorNum13 = Expression<Int>("errorNum13")
        let errorNum14 = Expression<Int>("errorNum14")
        let errorNum15 = Expression<Int>("errorNum15")
        let errorNum16 = Expression<Int>("errorNum16")
        let errorNum17 = Expression<Int>("errorNum17")
        let errorNum18 = Expression<Int>("errorNum18")
        let errorNum19 = Expression<Int>("errorNum19")
        
        let userid = Expression<String>("userid")      //给测试人员的独一id
        let sex = Expression<String>("sex")
        let age = Expression<Int>("age")
        let birth = Expression<String>("birth")
        let userName = Expression<String>("userName")  //用户姓名
        let testTime = Expression<String>("testTime")  //测试当时的时间
        let testCase = Expression<Int>("testCase")  //第几段测试
        let language = Expression<String>("language")
        let testMode = Expression<String>("testMode")

        
        
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
        subContentsVC.readChart = []
        subContentsVC.costTime = []
        subContentsVC.errorNum = []
        subContentsVC.errorWord = []
        
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
            
            subContentsVC.costTime.append(user[costTime1])
            subContentsVC.costTime.append(user[costTime2])
            subContentsVC.costTime.append(user[costTime3])
            subContentsVC.costTime.append(user[costTime4])
            subContentsVC.costTime.append(user[costTime5])
            subContentsVC.costTime.append(user[costTime6])
            subContentsVC.costTime.append(user[costTime7])
            subContentsVC.costTime.append(user[costTime8])
            subContentsVC.costTime.append(user[costTime9])
            subContentsVC.costTime.append(user[costTime10])
            subContentsVC.costTime.append(user[costTime11])
            subContentsVC.costTime.append(user[costTime12])
            subContentsVC.costTime.append(user[costTime13])
            subContentsVC.costTime.append(user[costTime14])
            subContentsVC.costTime.append(user[costTime15])
            subContentsVC.costTime.append(user[costTime16])
            subContentsVC.costTime.append(user[costTime17])
            subContentsVC.costTime.append(user[costTime18])
            subContentsVC.costTime.append(user[costTime19])
            
            subContentsVC.readChart.append(user[readChart1])
            subContentsVC.readChart.append(user[readChart2])
            subContentsVC.readChart.append(user[readChart3])
            subContentsVC.readChart.append(user[readChart4])
            subContentsVC.readChart.append(user[readChart5])
            subContentsVC.readChart.append(user[readChart6])
            subContentsVC.readChart.append(user[readChart7])
            subContentsVC.readChart.append(user[readChart8])
            subContentsVC.readChart.append(user[readChart9])
            subContentsVC.readChart.append(user[readChart10])
            subContentsVC.readChart.append(user[readChart11])
            subContentsVC.readChart.append(user[readChart12])
            subContentsVC.readChart.append(user[readChart13])
            subContentsVC.readChart.append(user[readChart14])
            subContentsVC.readChart.append(user[readChart15])
            subContentsVC.readChart.append(user[readChart16])
            subContentsVC.readChart.append(user[readChart17])
            subContentsVC.readChart.append(user[readChart18])
            subContentsVC.readChart.append(user[readChart19])
            
            subContentsVC.errorNum.append(user[errorNum1])
            subContentsVC.errorNum.append(user[errorNum2])
            subContentsVC.errorNum.append(user[errorNum3])
            subContentsVC.errorNum.append(user[errorNum4])
            subContentsVC.errorNum.append(user[errorNum5])
            subContentsVC.errorNum.append(user[errorNum6])
            subContentsVC.errorNum.append(user[errorNum7])
            subContentsVC.errorNum.append(user[errorNum8])
            subContentsVC.errorNum.append(user[errorNum9])
            subContentsVC.errorNum.append(user[errorNum10])
            subContentsVC.errorNum.append(user[errorNum11])
            subContentsVC.errorNum.append(user[errorNum12])
            subContentsVC.errorNum.append(user[errorNum13])
            subContentsVC.errorNum.append(user[errorNum14])
            subContentsVC.errorNum.append(user[errorNum15])
            subContentsVC.errorNum.append(user[errorNum16])
            subContentsVC.errorNum.append(user[errorNum17])
            subContentsVC.errorNum.append(user[errorNum18])
            subContentsVC.errorNum.append(user[errorNum19])
            
            subContentsVC.errorWord.append(user[errorWord1])
            subContentsVC.errorWord.append(user[errorWord2])
            subContentsVC.errorWord.append(user[errorWord3])
            subContentsVC.errorWord.append(user[errorWord4])
            subContentsVC.errorWord.append(user[errorWord5])
            subContentsVC.errorWord.append(user[errorWord6])
            subContentsVC.errorWord.append(user[errorWord7])
            subContentsVC.errorWord.append(user[errorWord8])
            subContentsVC.errorWord.append(user[errorWord9])
            subContentsVC.errorWord.append(user[errorWord10])
            subContentsVC.errorWord.append(user[errorWord11])
            subContentsVC.errorWord.append(user[errorWord12])
            subContentsVC.errorWord.append(user[errorWord13])
            subContentsVC.errorWord.append(user[errorWord14])
            subContentsVC.errorWord.append(user[errorWord15])
            subContentsVC.errorWord.append(user[errorWord16])
            subContentsVC.errorWord.append(user[errorWord17])
            subContentsVC.errorWord.append(user[errorWord18])
            subContentsVC.errorWord.append(user[errorWord19])
            
            subContentsVC.userID = user[userid]
            subContentsVC.userSex = user[sex]
            subContentsVC.userAge = user[age]
            subContentsVC.userBirth = user[birth]
            subContentsVC.userName = user[userName]
            subContentsVC.testTime = user[testTime]
            subContentsVC.testCase = user[testCase]
            subContentsVC.distanceVary = user[distanceVary]
            subContentsVC.language = user[language]
            subContentsVC.testMode = user[testMode]
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
        //self.returnPrevious()
        print("SlideMenuControllerDelegate: leftWillClose")
    }
    
    func leftDidOpen() {
        print("SlideMenuControllerDelegate: leftWillClose")
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



