//
//  MainViewController.swift
//

//Table: testResults
//userName+testTime(details), userName, testTime, timeSpent1,timespent2,.....timeSpent19，distanceVary



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
        let details  = Expression<String>("details")
        let userName = Expression<String>("userName")
        let testTime = Expression<String>("testTime")
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
        
        //clean before DB
        //try! db.run(testResults.drop())
        
        
        try! db.run(testResults.create(ifNotExists: true) { t in
            t.column(id,  primaryKey: .autoincrement)
            t.column(details)
            t.column(userName)
            t.column(testTime)
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
            
        })
        
        
//        //testData
//        let insert1 = testResults.insert(
//            details <- "first one  1970",
//            userName <- "first one",
//            testTime <- "1970",
//            timeSpent1 <- 145.234
//            
//        )
//        try! db.run(insert1)
//        
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

