//
//  Test1.swift
//  TrainingProgram
//
//  Created by socoi on 17/2/8.
//  Copyright © 2017年 All rights reserved.
//



import UIKit
import Speech
import SQLite

public class Test1: UIViewController, SFSpeechRecognizerDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    // MARK: Properties
    
    //zh-HK广东话, zh普通话
    private var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "zh-HK"))!
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    
    private var recognitionTask: SFSpeechRecognitionTask?
    
    private let audioEngine = AVAudioEngine()
    
    @IBOutlet var textView : UITextView!
    
    @IBOutlet var recordButton : UIButton!
    
    let fullScreenSize = UIScreen.main.bounds.size
    
    private var testNumbers  = Int()//test cases number start from 0
    private var testResults = String()//test contents
    private var inputResults = String()//speak contents
    public var beforeTime = Date()//starting time
    public var timeRecord = Timer()
    public var countDownNumber = Int()
    
    public var userName = String()
    public var userId = String()
    public var userSex = String()
    public var userAge = Int()
    public var userBirth = String()
    


    
    //record that shown in subcontent controller
    public var timeSpent = Array<Double>()//attention! - > (correct number/test time) * 60
    public var costTime = Array<Double>() // test time
    public var errorWord = Array<String>() //error words
    public var errorNum =  Array<Int>() //error number
    public var selectedChart = Array<String>() //random picked chart
    public var testCases = Array<Int>() //随机选取的readingchart的编号
    public var testedCases = Array<Int>() //已测试的redingchart的编号
    


    public var mnread_num = 1  //test1 （19个句子） test2(19个句子) 彼此都不重复
    public var fontColor = String()
    public var backColor = String()
    public var watchDistance = String() //depend watch distance adjust font size
    public var distanceVary = Double() //  pass to resultView controller
    public var testLanguage = String() //普通话或者粤语
    public let fontSize = [77,62.5,49,38.5,30.5,24,20,16,12,9,8,6.5,5,4,2.5,2,1.5,1.1,0.9] //40cm :corresponse distance,77\
    public var testMode = String()  //自动或手动

    
    let startMenu = UIAlertController(title:"" , message: "", preferredStyle: .alert) //初始对话框，需要输入用户信息
    //选择框里的内容设计
    public let agepickView:UIPickerView = UIPickerView()
    public let sexpickView:UIPickerView = UIPickerView()
    public let errpickView:UIPickerView = UIPickerView()
    public var agetextField = UITextField()
    public var sextextField = UITextField()
    public var errtextField = UITextField()
    public let sexcontent = ["","男","女"]
    public let agecontent = Array(5...100)
    public let errcontent = Array(0...12)
   


    
    
    public let readingChart = ["我們年紀很小就舉行演奏會","小鳥兒飛到我家屋前的樹上","昨天大表姐到醫院探望叔叔","我在摩天輪上看見藍天白雲","媽媽每天給大文講一個故事","這篇文章描述了新年的景象","小妹妹還沒上學便開始認字","張小華忘記把課室的門關上","大文三歲已經開始創作詩歌","花香引來各種各樣的小昆蟲","打乒乓球是我愛的課外活動","小朋友喜歡坐在旋轉木馬上", "辛勤工作的人應該受到尊重","我學會用重複的句子來作詩","大笨象帶著五隻小河馬過河","姐姐和妹妹要做漂亮的花兒","蜻蜓早就停在荷葉上面休息","車站上的乘客焦急地等待著","小汽車緩慢地穿過這個山洞",
                               
        "妹妹吃下弟弟幫忙買的餅乾","他在一家電影公司擔任秘書","小貓在畫紙上踩了幾個腳印","木馬是小朋友最喜歡的玩具","沒有人知道這是誰的萬花筒","小明把聽過的故事描述出來","我在動物園裏看到了大笨象","今年我班的足球隊實力很強","他父親叫他寫信給歐陽先生","老鼠冒著生命危險去找食物","他希望在假期裡多參加活動","小朋友最喜歡坐在摩天輪上","他給我們搖來了最平穩的船","一群小螞蟻緩慢地爬上山頂","星期六父親帶弟弟去騎木馬","我在討論中清楚地表達意見","她繼續守護早已長大的孩子","魔術師把大西瓜放在袋子裏","爸爸給我講了這樣一個故事",
        
        
        "哥哥把小狗的腳印變成花朵", "叔叔開車帶我們去郊外遊玩","紫紅色的袋子裏有一張廢紙","小明最喜歡飯後吃一個水果","威風的獵人走到危險的森林","這本書介紹了基本語文知識","猴子在樹上靈活地爬來爬去","小馬帶他走進美麗的大花園","大家輪流介紹自己喜愛的歌","上星期姑姑送給我一盒糖果","李大文可以認識美麗的植物","小美在聽木結他發出的聲音","他獨自守著充滿回憶的房子","小朋友最喜歡上中國武術課","科學家做出一個風車的模型","地上還長著許多紅色的草莓","今年新設計的海報很有創意","故事說出小鳥從小就很勇敢","他們給父母一份特別的驚喜"
    
    ]
    
    
    
    
  
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {return 1}
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == agepickView){
            return agecontent.count
        }
        if(pickerView == sexpickView){
            return sexcontent.count
        }
        if(pickerView == errpickView){
            return errcontent.count
        }
        return(0)
    }
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView == agepickView){
            return String(agecontent[row])
        }
        if(pickerView == sexpickView){
            return sexcontent[row]
        }
        if(pickerView == errpickView){
            return String(errcontent[row])
        }
        return("error")
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView == agepickView){
            agetextField.text! = String(agecontent[row])
        }
        if(pickerView == sexpickView){
            sextextField.text! =  sexcontent[row]
        }
        if(pickerView == errpickView){
            errtextField.text! =  String(errcontent[row])
        }
        
    }
    
    //birth selected
    func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        self.startMenu.textFields?.last?.text = dateFormatter.string(from: sender.date)
    }

    
    // This delegate method is called every time the face recognition has detected something (including change)
    func faceIsTracked(_ faceRect: CGRect, withOffsetWidth offsetWidth: Float, andOffsetHeight offsetHeight: Float, andDistance distance: Float) {
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.1)
        let layer: CALayer? = self.textView.layer
        layer?.masksToBounds = false
        //layer?.shadowOffset = CGSize(width: CGFloat(offsetWidth / 5.0), height: CGFloat(offsetHeight / 10.0))
        layer?.shadowRadius = 0 //5
        layer?.shadowOpacity = 0//0.1
        CATransaction.commit()
    }
    // When the fluidUpdateInterval method is called, then this delegate method will be called on a regular interval
    
    func fluentUpdateDistance(_ distance: Float) {
        
        // Animate to the zoom level.
        let effectiveScale: Float = distance / 60.0     //origin : 60
        CATransaction.begin()
        CATransaction.setAnimationDuration(1.5)//origin: 0.1
        self.textView.layer.setAffineTransform(CGAffineTransform(scaleX: CGFloat(effectiveScale), y: CGFloat(effectiveScale)))
        CATransaction.commit()
    }
    
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let attributedString = NSAttributedString(string: "個人信息", attributes: [
            NSFontAttributeName : UIFont.systemFont(ofSize: 40) //your font here
            ])
        
        let height:NSLayoutConstraint = NSLayoutConstraint(item: startMenu.view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.80)
        startMenu.setValue(attributedString, forKey: "attributedTitle")
        startMenu.view.addConstraint(height)

        
        startMenu.addTextField {
            (textField: UITextField!) -> Void in
            let heightConstraint = NSLayoutConstraint(item: textField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
            textField.addConstraint(heightConstraint)
            textField.placeholder = "輸入id"
            textField.font = UIFont.systemFont(ofSize: 30)
            textField.clearButtonMode = .whileEditing

        }
        
        startMenu.addTextField {
            (textField: UITextField!) -> Void in
            let heightConstraint = NSLayoutConstraint(item: textField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
            textField.addConstraint(heightConstraint)
            textField.placeholder = "輸入姓名"
            textField.font = UIFont.systemFont(ofSize: 30)
            textField.clearButtonMode = .whileEditing
            
        }
        
        startMenu.addTextField {
            (textField: UITextField!) -> Void in
            self.sextextField = textField
            let heightConstraint = NSLayoutConstraint(item: self.sextextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
            self.sextextField.addConstraint(heightConstraint)
            self.sextextField.placeholder = "輸入性別"
            self.sextextField.font = UIFont.systemFont(ofSize: 30)
            self.sextextField.clearButtonMode = .whileEditing
            self.sextextField.inputView = self.sexpickView
            
        }
        
        startMenu.addTextField {
            (textField: UITextField!) -> Void in
            self.agetextField = textField
            let heightConstraint = NSLayoutConstraint(item: self.agetextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
            self.agetextField.addConstraint(heightConstraint)
            self.agetextField.placeholder = "輸入年齡"
            self.agetextField.font = UIFont.systemFont(ofSize: 30)
            self.agetextField.clearButtonMode = .whileEditing
            self.agetextField.inputView = self.agepickView


            
        }
        
        startMenu.addTextField {
            (textField: UITextField!) -> Void in
            let heightConstraint = NSLayoutConstraint(item: textField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
            textField.addConstraint(heightConstraint)
            textField.placeholder = "輸入出生日期"
            textField.font = UIFont.systemFont(ofSize: 30)
            textField.clearButtonMode = .whileEditing
            
            let datePickerView:UIDatePicker = UIDatePicker()
            datePickerView.datePickerMode = UIDatePickerMode.date
            textField.inputView = datePickerView
            datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
            
        }
        
    
        
        let okAction = UIAlertAction(title: "開始測試", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            
            let login  = self.startMenu.textFields
            let userid = login![0] as UITextField
            let username = login![1] as UITextField
            let usersex = login![2] as UITextField
            let userage = login![3] as UITextField
            let userbirth = login![4] as UITextField

            if (userid.text != "") && (usersex.text != "") && (userage.text != "") && (userbirth.text != "") && (username.text != ""){
            self.userName = username.text!
            self.userId = userid.text!
            self.userSex = usersex.text!
            self.userAge = Int(userage.text!)!
            self.userBirth = userbirth.text!
            
            //prepare for the test
            self.countDownNumber = 4
            self.timeRecord = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.countDown), userInfo: nil, repeats: true)
            }

        })
        
        let cancelAction = UIAlertAction(title: "返回", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            //return the main page
            self.performSegue(withIdentifier: "Test1", sender: self)
            
        })
        
   
        
        
        startMenu.popoverPresentationController?.sourceView = textView
        let t1 = fullScreenSize.height
        let t2 = fullScreenSize.width
        
        startMenu.popoverPresentationController?.sourceRect = CGRect(x:t1/3,y:t2/2,width:500,height:500)
        startMenu.popoverPresentationController?.permittedArrowDirections = [.up]
        startMenu.addAction(okAction)
        startMenu.addAction(cancelAction)
        self.present(startMenu, animated: true, completion: nil)
        
        }
    
    
    public func testContent(number : Int ) -> String{
        let numCount = readingChart.count //57 reading cases
        var arrayKey = Int(arc4random_uniform(UInt32(numCount))) //random cases
        for _ in 1...57{
             //存放第一次测试取的编号，保证两次测试没有相同内容
            if(!testCases.contains(arrayKey) && !testedCases.contains(arrayKey)){
                testCases.append(arrayKey)
                testedCases.append(arrayKey)
                break
            }
            else{ arrayKey = Int(arc4random_uniform(UInt32(numCount)))}
        }
        return readingChart[testCases[number - 1]]
    }
    
    //after countdown start test automatically
    public func countDown(){
        self.textView.text = ""
        textView.font = .systemFont(ofSize: 60)
        self.countDownNumber -= 1
        self.textView.text = " 測試[" + "\(self.testNumbers + 1)" + "]將於" + "\(self.countDownNumber) " + "秒後開始"
        if(self.countDownNumber == -1){
            self.timeRecord.invalidate()
            //let faceTracker = EVFaceTracker(delegate : self)
            //faceTracker?.fluidUpdateInterval(0.10, withReactionFactor: 0.3)// 0.05, 0.3
            
            //prepare for test
            recordButton.isHidden = true
            self.textView.text = ""
            
            recordButtonTapped()

        }
    }
    
    //show training contents(start from num1)
    public func contents(str : String, num : Int){
        textView.isHidden = false
        recordButton.isHidden = false
        
        
        //distance didnot affect fontsize
        //textView.font = UIFont.preferredFont(forTextStyle: .headline)
        textView.font = .systemFont(ofSize: CGFloat(fontSize[num - 1] * 1.4))

        
        //fixed 3 lines
        var number = 0
        var fixStr = [Character]()
        for everyChar in str.characters{
            if(number == 4 || number == 8 || number == 12){
                fixStr.append("\n")
                fixStr.append(everyChar)
            }
            else{
                fixStr.append(everyChar)
            }
            number += 1
        }
        let str = String(fixStr)
        textView.textContainer.maximumNumberOfLines = 4
        self.textView.text = str
        
        
        //var _ = Timer.scheduledTimer(timeInterval: 15.0, target: self, selector: #selector(hideContents), userInfo: nil, repeats: false)
        
    }
    
    
    
    public func hideContents(){
        //textView.font = .systemFont(ofSize: 30)
        //textView.text = "(   please repeat the contents......   )"
        textView.isHidden = true
        recordButton.isHidden = false
    }
    
    

    
    public func showContents(times : Int){
        switch times{
        case 1 : contents(str: testContent(number:1), num : 1)
        case 2 : contents(str: testContent(number:2), num : 2)
        case 3 : contents(str: testContent(number:3), num : 3)
        case 4 : contents(str: testContent(number:4), num : 4)
        case 5 : contents(str: testContent(number:5), num : 5)
        case 6 : contents(str: testContent(number:6), num : 6)
        case 7 : contents(str: testContent(number:7), num : 7)
        case 8 : contents(str: testContent(number:8), num : 8)
        case 9 : contents(str: testContent(number:9), num : 9)
        case 10 : contents(str: testContent(number:10), num : 10)
        case 11 : contents(str: testContent(number:11), num : 11)
        case 12 : contents(str: testContent(number:12), num : 12)
        case 13 : contents(str: testContent(number:13), num : 13)
        case 14 : contents(str: testContent(number:14), num : 14)
        case 15 : contents(str: testContent(number:15), num : 15)
        case 16 : contents(str: testContent(number:16), num : 16)
        case 17 : contents(str: testContent(number:17), num : 17)
        case 18 : contents(str: testContent(number:18), num : 18)
        case 19 : contents(str: testContent(number:19), num : 19)
        default : stopTest()
        }
    }
    
    
    
    public func stopTestUpdate(Times:Int){
        
        //第一次还是第二次测试
        self.mnread_num = Times
        
        
        //测试中需要记录的5个数据
        var s1 = String()
        var s2 = String()
        var s3 = String()
        var s4 = String()
        var s5 = String()
        
        
        //store data
        let stopTime = Date()
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .short
        dateformatter.timeStyle = .short
        let dateString = dateformatter.string(from : stopTime)
        //let resultCell = self.userName + "   " + dateString + " (" + self.testMode + ")"
        var resultCell = self.userId + "__" + dateString + "__"
        resultCell = resultCell + "test"  + String(self.mnread_num) + "__" + self.testMode
        
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        
        let db = try! Connection("\(path)/db.sqlite3")
        let testResults = Table("testResults")
        let id = Expression<Int>("id")
        let details  = Expression<String>("details")
        let userName = Expression<String>("userName")
        let testTime = Expression<String>("testTime")
        let userId = Expression<String>("userid")
        let userSex = Expression<String>("sex")
        let userAge = Expression<Int>("age")
        let userBirth = Expression<String>("birth")
        let distanceVary = Expression<Double>("distanceVary")
        let testCase = Expression<Int>("testCase") //第一次测试
        
        // updated information
        
        let testPass = self.timeSpent.count
        
        let insert = testResults.insert(
            details <- resultCell,
            userName <- self.userName,
            userId <- self.userId,
            userSex <- self.userSex,
            userAge <- self.userAge,
            userBirth <- self.userBirth,
            testTime <- dateString,
            distanceVary <- self.distanceVary,
            testCase <- self.mnread_num
        )
        try! db.run(insert)
        
        
        // update timespent
        // always update the newest row(id max)
        
        let max = try! db.scalar(testResults.select(id.max))
        let selectedRow = testResults.filter(id == max!)
        
        //test
        for user in try! db.prepare(selectedRow) {
            print(user[id])
        }
        
        
        //since do not know how many testPass, insert primary, then update timespent
        for number in 1 ... testPass {
            s1 = "timeSpent" + "\(number)"
            s2 = "costTime" + "\(number)"
            s3 = "readChart" + "\(number)"
            s4 = "errorWord" + "\(number)"
            s5 = "errorNum" + "\(number)"
            let s11 = Expression<Double>(s1)
            let s12 = Expression<Double>(s2)
            let s13 = Expression<String>(s3)
            let s14 = Expression<String>(s4)
            let s15 = Expression<Int>(s5)
            
            
            let update1 = selectedRow.update(
                s11 <- self.timeSpent[number - 1]
            )
            try! db.run(update1)
            
            let update2 = selectedRow.update(
                s12 <- self.costTime[number - 1]
            )
            try! db.run(update2)
            
            let update3 = selectedRow.update(
                s13 <- self.selectedChart[number - 1]
            )
            try! db.run(update3)
            
            let update4 = selectedRow.update(
                s14 <- self.errorWord[number - 1]
            )
            try! db.run(update4)
            
            let update5 = selectedRow.update(
                s15 <- self.errorNum[number - 1]
            )
            try! db.run(update5)
            
        }
    }
    
    public func stopTest(){
        
        if(self.mnread_num == 1) //第一次测试结束继续
        {
        stopTestUpdate(Times: 1)
        let optionMenu = UIAlertController(title: "第一次測試結束", message: inputResults, preferredStyle: .alert)
//        let attributedString = NSAttributedString(string: "請輸入錯字數目", attributes: [
//                NSFontAttributeName : UIFont.systemFont(ofSize: 40) //your font here
//                ])
//        optionMenu.setValue(attributedString, forKey: "continue")
        let okAction = UIAlertAction(title: "開始第二次測試", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in

            //清空之前记录
            self.testNumbers = 0
            self.timeSpent.removeAll()
            self.costTime.removeAll()
            self.errorWord.removeAll()
            self.errorNum.removeAll()
            self.selectedChart.removeAll()
            self.testCases.removeAll()
            
            self.recordButton.isHidden = true
            self.countDownNumber = 4
            self.timeRecord = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.countDown), userInfo: nil, repeats: true)
            self.mnread_num += 1
        })
            optionMenu.addAction(okAction)
            optionMenu.popoverPresentationController?.sourceView = textView
            let t1 = fullScreenSize.height
            let t2 = fullScreenSize.width
            
            optionMenu.popoverPresentationController?.sourceRect = CGRect(x:t1/3,y:t2/2,width:40,height:40)
            optionMenu.popoverPresentationController?.permittedArrowDirections = [.up]
            self.present(optionMenu, animated: true, completion: nil)
            
        }
        
        else{ //第二次全部测试结束
            stopTestUpdate(Times: 2)
            let optionMenu = UIAlertController(title: "測試結束", message: inputResults, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "返回", style: .cancel, handler: {
                (alert: UIAlertAction!) -> Void in
                self.performSegue(withIdentifier: "Test1", sender: self)
            })
            
            optionMenu.addAction(okAction)
            optionMenu.popoverPresentationController?.sourceView = textView
            let t1 = fullScreenSize.height
            let t2 = fullScreenSize.width
            
            optionMenu.popoverPresentationController?.sourceRect = CGRect(x:t1/3,y:t2/2,width:40,height:40)
            optionMenu.popoverPresentationController?.permittedArrowDirections = [.up]
            self.present(optionMenu, animated: true, completion: nil)
        }
        
    }
    

    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        //pickview
        agepickView.delegate = self
        sexpickView.delegate = self
        agepickView.dataSource = self
        sexpickView.dataSource = self
        errpickView.delegate = self
        errpickView.dataSource = self
        agepickView.selectRow(45, inComponent:0, animated:true)
        sexpickView.selectRow(0, inComponent:0, animated:true)
        errpickView.selectRow(0, inComponent:0, animated:true)

        
        
        // Disable the record buttons until authorization has been granted.
        recordButton.isHidden = true
        
        
        // let textView horizon center
        textView.textAlignment = .center
        
        // text position(150,50,10,10)
        textView.textContainerInset = UIEdgeInsetsMake(50, 10, 150, 10)
        
        textView.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle(rawValue: "新細明體"))
        
        //get color and distance
        var colors : [String:UIColor] = ["白色": UIColor.white, "黑色":
            UIColor.black, "藍色": UIColor.blue,"黃色":
                UIColor.yellow,"綠色":
                    UIColor.green,"紅色":UIColor.red]
        
        
        let distance : [String:Double] = ["40cm": 1, "33cm":
            1.21, "25cm":1.6 , "20cm":2]
        
        //color and distance
        textView.textColor = colors[fontColor]
        textView.backgroundColor = colors[backColor]
        distanceVary = distance[watchDistance]!
        
        //language set
        var language : [String:String] = [ "廣東話": "zh-HK", "國語": "zh-TW",]
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: language[testLanguage]!))!
        
        
    }
    
    
    //detect accuracy, whether continue()
    //any three words match -> pass
    //return number of correct words and its contents
    public func findAccuracy(myNumber : Int) -> (Int,String) {
        //error words
        var filterWords = ""
        testResults = testContent(number : myNumber)
        //var correctChar = Int()
        var re1Arr = Array<String>()//input words
        var re2Arr = Array<String>()//test words
        
        //user say nothing -> equal to before
        if(inputResults == ""){
            return (0,"")
        }
        
        for i in inputResults.characters{
            re1Arr.append(String(i))
        }
        for i in testResults.characters{
            re2Arr.append(String(i))
        }
        
//        for i in 0...(re1Arr.count - 1){
//            if i > 11{
//                break;
//            }
//            if (re1Arr[i] == re2Arr[i]){
//                correctChar += 1
//            }
//        }
        
        let commonWords = re1Arr.filter(re2Arr.contains)
        for a in re2Arr{
            if(!commonWords.contains(a)){
                filterWords += a
            }
        }
        return (commonWords.count , filterWords)
}
    

    
    
    
    private func startRecording() throws {
        
        self.inputResults = ""

        // Cancel the previous task if it's running.
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSessionCategoryRecord)
        try audioSession.setMode(AVAudioSessionModeMeasurement)
        try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        			
        guard let inputNode = audioEngine.inputNode else { fatalError("Audio engine has no input node") }
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to created a SFSpeechAudioBufferRecognitionRequest object") }
        
        // Configure request so that results are returned before audio recording is finished
        recognitionRequest.shouldReportPartialResults = false  //true
        
        // A recognition task represents a speech recognition session.
        // We keep a reference to the task so that it can be cancelled.
        //recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest, resultHandler:{ (result, error) in
            var isFinal = false
        
            
        //user say nothing
            self.inputResults = ""
            
            if let result = result {
                //here is the result
                self.inputResults = result.bestTranscription.formattedString
                isFinal = result.isFinal

            }

            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)

                self.recognitionRequest = nil
                self.recognitionTask = nil

                self.recordButton.isEnabled = true
                self.recordButton.setTitle("開始錄音", for: [])
            }
            
            self.stopRecord()

        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        try audioEngine.start()
        
        //textView.font = .systemFont(ofSize: 30)
        //textView.text = "(   Recording............   )"
    }

    // MARK: SFSpeechRecognizerDelegate
    
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            recordButton.isEnabled = true
            recordButton.setTitle("開始錄音", for: [])
        } else {
            recordButton.isEnabled = false
            recordButton.setTitle("Recognition not available", for: .disabled)
        }
    }
    
    
    // MARK: Interface Builder actions
    
    @IBAction func recordButtonTapped() {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            recordButton.isEnabled = false
            recordButton.setTitle("Stopping", for: .disabled)
            
        } else {
            
            //start to record the time
            self.showContents(times: testNumbers + 1)
            try! startRecording()
            recordButton.setTitle("停止錄音", for: [])
            self.beforeTime = Date()

        }
    }
    
    func manualInsert(timeSpent : Double){
        let optionMenu = UIAlertController(title: "", message: "", preferredStyle: .alert)

        let attributedString = NSAttributedString(string: "請輸入錯字數目", attributes: [
            NSFontAttributeName : UIFont.systemFont(ofSize: 40) //your font here
            ])
        
        optionMenu.setValue(attributedString, forKey: "attributedTitle")
        
        
        optionMenu.addTextField {
            (textField: UITextField!) -> Void in
            self.errtextField = textField
            let heightConstraint = NSLayoutConstraint(item: self.errtextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
            self.errtextField.addConstraint(heightConstraint)
            self.errtextField.font = UIFont.systemFont(ofSize: 30)
            self.errtextField.placeholder = "請輸入错字数"
            self.errtextField.clearButtonMode = .whileEditing
            self.errtextField.text! = "0"
            self.errtextField.inputView = self.errpickView
            
        }
        
        let okAction = UIAlertAction(title: "確認", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            let login = (optionMenu.textFields?.first)! as UITextField
            
            if (login.text != ""){
                let error = Int(login.text!)
                self.recordButton.isHidden = true
                self.errorNum[self.testNumbers] = error! //手动计入错字数
                self.timeSpent[self.testNumbers] = log10(Double(12 - error!) / timeSpent * 60) //重新计算timeSpent
                //prepare for the test
                self.countDownNumber = 4
                self.timeRecord = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.countDown), userInfo: nil, repeats: true)
                self.testNumbers += 1

            }
            
        })
        
        let cancelAction = UIAlertAction(title: "停止測試", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
    
            let login = (optionMenu.textFields?.first)! as UITextField
            self.recordButton.isHidden = true
            self.errorNum[self.testNumbers] = Int(login.text!)!
            self.stopTest()
        })
        
        optionMenu.popoverPresentationController?.sourceView = textView
        let t1 = fullScreenSize.height
        let t2 = fullScreenSize.width
        
        optionMenu.popoverPresentationController?.sourceRect = CGRect(x:t1/3,y:t2/2,width:20,height:20)
        optionMenu.popoverPresentationController?.permittedArrowDirections = [.up]
        optionMenu.addAction(okAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    //停止后记录数据
    func stopRecord(){
        
        //record the time interval(according to definition)
        let nowTime = Date()
        var timeSpent = nowTime.timeIntervalSince(beforeTime) + 0.18
        let (correctWords, filterWords) = findAccuracy(myNumber: testNumbers + 1)
        
        
        //--------------------------------------------------------------record for databse
        
        
        //errorWord
        errorWord.append(filterWords)
        
        //erroNumber
        errorNum.append(12 - correctWords)
        
        //timecost
        costTime.append(timeSpent)
        
        //testContent(random pick)
        selectedChart.append(testContent(number : testNumbers + 1))
        
        
        //special case
        if(timeSpent == 0){
            self.timeSpent.append(timeSpent)
        }
        if(correctWords != 0 ){
            timeSpent = log10(Double(correctWords) / timeSpent * 60)
        }
        else { timeSpent = 0}
        
        self.timeSpent.append(timeSpent)
        textView.text = ""
        
        // 手动模式下输入错字，重新计算timespent
        if(testMode == "手動"){
            manualInsert(timeSpent: costTime[self.testNumbers])
        }
        
        if(testMode == "自動"){
            if(correctWords > 1){
                testNumbers += 1
                recordButton.isHidden = true
                self.countDownNumber = 4
                self.timeRecord = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.countDown), userInfo: nil, repeats: true)
            }
                
            else{
                stopTest()
            }}
        
    }
}

