//
//  MainViewController.swift
//

//Table: testResults
//userName+testTime(details), userName, testTime, timeSpent1,timespent2,.....timeSpent19，distanceVary
//readChart1,readChart2......readChart19
//errorWord1,errorWord2........errorWord19
//errorNum1,errNum2.......errorNum19





import UIKit
import SQLite

class MainViewController: UIViewController {
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        
        let db = try! Connection("\(path)/db.sqlite3")
        let testResults = Table("testResults")
        let id = Expression<Int>("id")
        let userid = Expression<String>("userid")      //给测试人员的独一id
        let sex = Expression<String>("sex")
        let age = Expression<Int>("age")
        let birth = Expression<String>("birth")
        let userName = Expression<String>("userName")  //用户姓名
        let testTime = Expression<String>("testTime")  //测试当时的时间
        let testCase = Expression<Int>("testCase")  //第几段测试(1 or 2)
        let distanceVary = Expression<Double>("distanceVary")
        let details  = Expression<String>("details")   //subcontents 主键 (userid + testtime + testCase)

        
        let timeSpent1 = Expression<Double>("timeSpent1")  //每段话时间（需log公式计算)
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
        let testMode = Expression<String>("testMode")
        
        let logMar1 = Expression<Double>("logMar1")   //LogMar
        let logMar2 = Expression<Double>("logMar2")
        let logMar3 = Expression<Double>("logMar3")
        let logMar4 = Expression<Double>("logMar4")
        let logMar5 = Expression<Double>("logMar5")
        let logMar6 = Expression<Double>("logMar6")
        let logMar7 = Expression<Double>("logMar7")
        let logMar8 = Expression<Double>("logMar8")
        let logMar9 = Expression<Double>("logMar9")
        let logMar10 = Expression<Double>("logMar10")
        let logMar11 = Expression<Double>("logMar11")
        let logMar12 = Expression<Double>("logMar12")
        let logMar13 = Expression<Double>("logMar13")
        let logMar14 = Expression<Double>("logMar14")
        let logMar15 = Expression<Double>("logMar15")
        let logMar16 = Expression<Double>("logMar16")
        let logMar17 = Expression<Double>("logMar17")
        let logMar18 = Expression<Double>("logMar18")
        let logMar19 = Expression<Double>("logMar19")







        
        
        //clean before DB
        //try! db.run(testResults.drop())
        
        
        try! db.run(testResults.create(ifNotExists: true) { t in
            t.column(id,  primaryKey: .autoincrement)
            t.column(details)
            t.column(userName)
            t.column(testTime)
            t.column(userid)
            t.column(sex)
            t.column(age)
            t.column(birth)
            t.column(testCase, defaultValue: 0)
            t.column(timeSpent1, defaultValue: 0)
            t.column(timeSpent2, defaultValue: 0)
            t.column(timeSpent3, defaultValue: 0)
            t.column(timeSpent4, defaultValue: 0)
            t.column(timeSpent5, defaultValue: 0)
            t.column(timeSpent6, defaultValue: 0)
            t.column(timeSpent7, defaultValue: 0)
            t.column(timeSpent8, defaultValue: 0)
            t.column(timeSpent9, defaultValue: 0)
            t.column(timeSpent10, defaultValue: 0)
            t.column(timeSpent11, defaultValue: 0)
            t.column(timeSpent12, defaultValue: 0)
            t.column(timeSpent13, defaultValue: 0)
            t.column(timeSpent14, defaultValue: 0)
            t.column(timeSpent15, defaultValue: 0)
            t.column(timeSpent16, defaultValue: 0)
            t.column(timeSpent17, defaultValue: 0)
            t.column(timeSpent18, defaultValue: 0)
            t.column(timeSpent19, defaultValue: 0)
            t.column(distanceVary, defaultValue: 0)
            t.column(readChart1, defaultValue: "None")
            t.column(readChart2, defaultValue: "None")
            t.column(readChart3, defaultValue: "None")
            t.column(readChart4, defaultValue: "None")
            t.column(readChart5, defaultValue: "None")
            t.column(readChart6, defaultValue: "None")
            t.column(readChart7, defaultValue: "None")
            t.column(readChart8, defaultValue: "None")
            t.column(readChart9, defaultValue: "None")
            t.column(readChart10, defaultValue: "None")
            t.column(readChart11, defaultValue: "None")
            t.column(readChart12, defaultValue: "None")
            t.column(readChart13, defaultValue: "None")
            t.column(readChart14, defaultValue: "None")
            t.column(readChart15, defaultValue: "None")
            t.column(readChart16, defaultValue: "None")
            t.column(readChart17, defaultValue: "None")
            t.column(readChart18, defaultValue: "None")
            t.column(readChart19, defaultValue: "None")
            
            
            t.column(costTime1, defaultValue: 0)
            t.column(costTime2, defaultValue: 0)
            t.column(costTime3, defaultValue: 0)
            t.column(costTime4, defaultValue: 0)
            t.column(costTime5, defaultValue: 0)
            t.column(costTime6, defaultValue: 0)
            t.column(costTime7, defaultValue: 0)
            t.column(costTime8, defaultValue: 0)
            t.column(costTime9, defaultValue: 0)
            t.column(costTime10, defaultValue: 0)
            t.column(costTime11, defaultValue: 0)
            t.column(costTime12, defaultValue: 0)
            t.column(costTime13, defaultValue: 0)
            t.column(costTime14, defaultValue: 0)
            t.column(costTime15, defaultValue: 0)
            t.column(costTime16, defaultValue: 0)
            t.column(costTime17, defaultValue: 0)
            t.column(costTime18, defaultValue: 0)
            t.column(costTime19, defaultValue: 0)
            
            t.column(errorWord1, defaultValue: "None")
            t.column(errorWord2, defaultValue: "None")
            t.column(errorWord3, defaultValue: "None")
            t.column(errorWord4, defaultValue: "None")
            t.column(errorWord5, defaultValue: "None")
            t.column(errorWord6, defaultValue: "None")
            t.column(errorWord7, defaultValue: "None")
            t.column(errorWord8, defaultValue: "None")
            t.column(errorWord9, defaultValue: "None")
            t.column(errorWord10, defaultValue: "None")
            t.column(errorWord11, defaultValue: "None")
            t.column(errorWord12, defaultValue: "None")
            t.column(errorWord13, defaultValue: "None")
            t.column(errorWord14, defaultValue: "None")
            t.column(errorWord15, defaultValue: "None")
            t.column(errorWord16, defaultValue: "None")
            t.column(errorWord17, defaultValue: "None")
            t.column(errorWord18, defaultValue: "None")
            t.column(errorWord19, defaultValue: "None")
            
            t.column(errorNum1, defaultValue: -99)
            t.column(errorNum2, defaultValue: -99)
            t.column(errorNum3, defaultValue: -99)
            t.column(errorNum4, defaultValue: -99)
            t.column(errorNum5, defaultValue: -99)
            t.column(errorNum6, defaultValue: -99)
            t.column(errorNum7, defaultValue: -99)
            t.column(errorNum8, defaultValue: -99)
            t.column(errorNum9, defaultValue: -99)
            t.column(errorNum10, defaultValue: -99)
            t.column(errorNum11, defaultValue: -99)
            t.column(errorNum12, defaultValue: -99)
            t.column(errorNum13, defaultValue: -99)
            t.column(errorNum14, defaultValue: -99)
            t.column(errorNum15, defaultValue: -99)
            t.column(errorNum16, defaultValue: -99)
            t.column(errorNum17, defaultValue: -99)
            t.column(errorNum18, defaultValue: -99)
            t.column(errorNum19, defaultValue: -99)
            
            t.column(logMar1, defaultValue: -99)
            t.column(logMar2, defaultValue: -99)
            t.column(logMar3, defaultValue: -99)
            t.column(logMar4, defaultValue: -99)
            t.column(logMar5, defaultValue: -99)
            t.column(logMar6, defaultValue: -99)
            t.column(logMar7, defaultValue: -99)
            t.column(logMar8, defaultValue: -99)
            t.column(logMar9, defaultValue: -99)
            t.column(logMar10, defaultValue: -99)
            t.column(logMar11, defaultValue: -99)
            t.column(logMar12, defaultValue: -99)
            t.column(logMar13, defaultValue: -99)
            t.column(logMar14, defaultValue: -99)
            t.column(logMar15, defaultValue: -99)
            t.column(logMar16, defaultValue: -99)
            t.column(logMar17, defaultValue: -99)
            t.column(logMar18, defaultValue: -99)
            t.column(logMar19, defaultValue: -99)
            t.column(testMode, defaultValue: "None")
         
        })
        
        
////        //testData
//        let insert1 = testResults.insert(
//            details <- "first one  1970",
//            userName <- "first one",
//            testTime <- "1970",
//            timeSpent1 <- 145.234
//
//        )
//        try! db.run(insert1)
////
//        let insert2 = testResults.insert(
//            details <- "second one  1980",
//            userName <- "first one",
//            testTime <- "1980",
//            timeSpent1 <- 5.20000,
//            timeSpent2 <- 1.20000,
//            timeSpent3 <- 3.40000,
//            timeSpent4 <- 5.60000,
//            timeSpent5 <- 3.10000
//        )
//        try! db.run(insert2)
//
//        let insert3 = testResults.insert(
//            details <- "third one  1990",
//            userName <- "third one",
//            testTime <- "1990",
//            timeSpent1 <- 4.00000,
//            timeSpent2 <- 1.00000,
//            timeSpent3 <- 3.20000,
//            timeSpent4 <- 8.00000,
//            timeSpent5 <- 2.50000
//        )
//        try! db.run(insert3)
//
//        
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
    }
    
    
    
    
}

extension MainViewController : SlideMenuControllerDelegate {
    
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

