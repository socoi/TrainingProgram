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

public class Test1: UIViewController, SFSpeechRecognizerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, AVAudioRecorderDelegate{
    // MARK: Properties
    
    //zh-HK广东话, zh普通话
    private var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "zh-HK"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()       //识别文本
    private var audioRecorder: AVAudioRecorder!     //录音
    
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
    public var readingChart = Array<String>() //define in Data.swift
    


    public var mnread_num = -1  //total test numbers
    public var mnread_case = 0  //start from test1
    
    public var fontColor = String()
    public var backColor = String()
    public var watchDistance = String() //depend watch distance adjust font size
    public var distanceVary = Double() //  pass to resultView controller
    public var testLanguage = String() //普通话或者粤语
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
   

    public let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    public let semaphore = DispatchSemaphore(value: 2)
    public var isFinal = false



    public func messageBox(titlemessage: String, title: String, navi: Bool){
        let optionMenu = UIAlertController(title: titlemessage,message:"", preferredStyle: .alert)
        let okAction = UIAlertAction(title: title, style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            if(navi == true){
                self.performSegue(withIdentifier: "Test1", sender: self)}
        })
        optionMenu.addAction(okAction)
        optionMenu.popoverPresentationController?.sourceView = self.textView
        let t1 = self.fullScreenSize.height
        let t2 = self.fullScreenSize.width
        
        optionMenu.popoverPresentationController?.sourceRect = CGRect(x:t1/3,y:t2/2,width:40,height:40)
        optionMenu.popoverPresentationController?.permittedArrowDirections = [.up]
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    
    
  
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


    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        SFSpeechRecognizer.requestAuthorization { authStatus in
            /*
             The callback may not be called on the main thread. Add an
             operation to the main queue to update the record button's state.
             */
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.recordButton.isEnabled = true
                    
                case .denied:
                    self.recordButton.isEnabled = false
                    self.recordButton.setTitle("User denied access to speech recognition", for: .disabled)
                    
                case .restricted:
                    self.recordButton.isEnabled = false
                    self.recordButton.setTitle("Speech recognition restricted on this device", for: .disabled)
                    
                case .notDetermined:
                    self.recordButton.isEnabled = false
                    self.recordButton.setTitle("Speech recognition not yet authorized", for: .disabled)
                }
            }
        }
        
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
            let heightConstraint = NSLayoutConstraint(item: textField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
            textField.addConstraint(heightConstraint)
            textField.placeholder = "輸入出生日期"
            textField.font = UIFont.systemFont(ofSize: 30)
            textField.clearButtonMode = .whileEditing
            
            let datePickerView:UIDatePicker = UIDatePicker()
            datePickerView.datePickerMode = UIDatePickerMode.date
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            let someDateTime = formatter.date(from: "01/01/2008")
            datePickerView.setDate(someDateTime!, animated: false)
            
            textField.inputView = datePickerView
            datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
            
        }
        
    
        
        let okAction = UIAlertAction(title: "開始測試", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            
            let login  = self.startMenu.textFields
            let userid = login![0] as UITextField
            let username = login![1] as UITextField
            let usersex = login![2] as UITextField
            //let userage = login![3] as UITextField
            let userbirth = login![3] as UITextField
            
            self.userName = username.text!
            self.userId = userid.text!
            self.userSex = usersex.text!
            //self.userAge = Int(userage.text!)!
            self.userAge = 0 //不需要输入年龄，暂时默认都为0吧
            self.userBirth = userbirth.text!
            
            let path = NSSearchPathForDirectoriesInDomains(
                    .documentDirectory, .userDomainMask, true
                    ).first!
                
            let db = try! Connection("\(path)/db.sqlite3")
            let testResults = Table("testResults")
            let userID = Expression<String>("userid")
            let t = testResults.filter(userID == self.userId)
            let queryNum = try! db.scalar(t.count)
            
            //保证userid不重复
                if(queryNum == 0) && (userid.text != "") && (usersex.text != "") && (userbirth.text != "") && (username.text != ""){
                    //prepare for the test
                    self.countDownNumber = 4
                    self.timeRecord = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.countDown), userInfo: nil, repeats: true)
                }
            
                else{
                    self.messageBox(titlemessage: "用戶信息不完整或用戶已存在", title: "返回", navi: true)
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
    
  
    public func updataDataBase(){
        
        
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
        resultCell = resultCell + "test"  + String(self.mnread_case + 1) + "__" + self.testMode
        
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
        let testCase = Expression<Int>("testCase") //第几次测试
        let language = Expression<String>("language")
        let testMode = Expression<String>("testMode")
        
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
            testCase <- self.mnread_case + 1,
            language <- self.testLanguage,
            testMode <- self.testMode
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
            
            let update1 = selectedRow.update(s11 <- self.timeSpent[number - 1])
            try! db.run(update1)
            let update2 = selectedRow.update(s12 <- self.costTime[number - 1])
            try! db.run(update2)
            let update3 = selectedRow.update(s13 <- self.selectedChart[number - 1])
            try! db.run(update3)
            let update4 = selectedRow.update(s14 <- self.errorWord[number - 1]
            )
            try! db.run(update4)
            let update5 = selectedRow.update(s15 <- self.errorNum[number - 1])
            try! db.run(update5)
        }
    }
    
    public func stopTest(){
      
        updataDataBase()
        
        //全部测试结束
        if(self.mnread_num == 1){self.messageBox(titlemessage: "全部測試結束", title: "返回", navi: true)}
        else//准备另一个测试
        {
            self.mnread_num -= 1
            self.mnread_case += 1
            let s1:String = "第" + String(self.mnread_case) + "次測試結束"
            let s2:String = "開始第" + String(self.mnread_case + 1) + "次測試"
        let optionMenu = UIAlertController(title: s1, message: inputResults, preferredStyle: .alert)
        let okAction = UIAlertAction(title: s2, style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in

            //清空之前记录
            self.testNumbers = 0
            self.timeSpent.removeAll()
            self.costTime.removeAll()
            self.errorWord.removeAll()
            self.errorNum.removeAll()
            self.selectedChart.removeAll()
            //self.testCases.removeAll()
            
            //实际中基本不可能19样例全完成
            if(self.testNumbers<18){
            self.recordButton.isHidden = true
            self.countDownNumber = 4
            self.timeRecord = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.countDown), userInfo: nil, repeats: true)
            }
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
        
        agepickView.delegate = self
        sexpickView.delegate = self
        agepickView.dataSource = self
        sexpickView.dataSource = self
        errpickView.delegate = self
        errpickView.dataSource = self
        agepickView.selectRow(45, inComponent:0, animated:true)
        sexpickView.selectRow(0, inComponent:0, animated:true)
        errpickView.selectRow(0, inComponent:0, animated:true)
        speechRecognizer.delegate = self
        
        // Initial readingChart
        readingChart = ModelData.shared.readingChart
        
        // Disable the record buttons until authorization has been granted.
        recordButton.isHidden = true
        
        // let textView horizon center
        textView.textAlignment = .center
        
        // text position(150,50,10,10)
        textView.textContainerInset = UIEdgeInsetsMake(50, 10, 150, 10)
        
        textView.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle(rawValue: "新細明體"))
        
        //get color and distance
        let fontblue:UIColor = UIColor(displayP3Red: CGFloat(65.0/255.0), green: CGFloat(105.0/255.0), blue: CGFloat(225.0/255.0), alpha: 1)
        let fontgreen = UIColor(displayP3Red: CGFloat(144.0/255.0), green: CGFloat(238.0/255.0), blue:CGFloat(144.0/255.0), alpha: 1)
        var colors : [String:UIColor] = ["白色": UIColor.white,
                "黑色":UIColor.black,
                "藍色":fontblue,
                "黃色":UIColor.yellow,
                "綠色":fontgreen,
                "紅色":UIColor.red]
        
        
        let distance : [String:Double] = ["40cm": 1.0, "33cm":
            2.0, "25cm":3.0 , "20cm":4.0, "16cm":5.0, "13cm":6.0]
        
        //color and distance
        textView.textColor = colors[fontColor]
        textView.backgroundColor = colors[backColor]
        distanceVary = distance[watchDistance]!
        
        //蓝底时button颜色为白
        if(colors[backColor] == fontblue){
            recordButton.setTitleColor(UIColor.white, for: .normal)}
        
        //language set
        var language : [String:String] = [ "廣東話": "zh-HK", "國語": "zh-TW",]
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: language[testLanguage]!))!
        
        
    }
    
    
    private func startRecording() throws {
        
        //----------------------------------------------------录音准备 /////////////
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSessionCategoryRecord)
        try audioSession.setMode(AVAudioSessionModeMeasurement)
        try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        
        
        let fileName = self.userId + "_" + self.userName + "_test" + String(self.mnread_case + 1) + "_" + String(testNumbers + 1) + ".m4a"
        let audioFilename = paths.appendingPathComponent(fileName)
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
        audioRecorder.delegate = self
        audioRecorder.record()
        
        //-------------------------------------------------------------------------
        
        if(testMode == "自動")  {
        
        // Cancel the previous task if it's running.
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
            
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        			
        guard let inputNode = audioEngine.inputNode else { fatalError("Audio engine has no input node") }
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to created a SFSpeechAudioBufferRecognitionRequest object") }
        
        // Configure request so that results are returned before audio recording is finished
        recognitionRequest.shouldReportPartialResults = true  //true
        
        // A recognition task represents a speech recognition session.
        // We keep a reference to the task so that it can be cancelled.
        //recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest, resultHandler:{ (result, error) in
        self.isFinal = false
            
        //user say nothing
            self.inputResults = ""
            
            if let result = result{
                //here is the result
                self.inputResults = result.bestTranscription.formattedString
            }
            
//            if error != nil || self.isFinal {
//                self.audioEngine.stop()
//                inputNode.removeTap(onBus: 0)
//
//                self.recognitionRequest = nil
//                self.recognitionTask = nil
//
//                self.recordButton.isEnabled = true
//                self.recordButton.setTitle("開始錄音", for: [])
//            }
//            if(self.isFinal){self.stopRecord()}
        })
        
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        _ = self.semaphore.wait(timeout: DispatchTime.distantFuture)
        
        }
     //-----------------------------------------------------------
     // 手动模式
        else{
            self.recordButton.isEnabled = true
            self.recordButton.setTitle("停止錄音", for: [])}
        
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
    
    
    @IBAction func recordButtonTapped() {
            if (self.audioEngine.isRunning && self.testMode == "自動") {
                
                guard let inputNode = audioEngine.inputNode else { fatalError("Audio engine has no input node") }
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
                self.recordButton.isEnabled = false
                self.recordButton.setTitle("正在識別中.......", for: .disabled)
               
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // change 1 to desired number of seconds
                    self.semaphore.signal()  //保证录音单线程
                    self.audioRecorder.stop()
                    self.audioEngine.stop()
                    self.recognitionRequest = nil
                    self.recognitionTask = nil
                    self.recognitionRequest?.endAudio()
                    self.stopRecord()
                    return
                }
            }
            if(!self.audioEngine.isRunning && self.testMode == "自動"){
                self.recordButton.isEnabled = true
                self.recordButton.setTitle("開始錄音", for: .disabled)
                //start to record the time, filter tested case
                self.testResults = showContents(leftContents: self.readingChart, times: self.testNumbers + 1, textView: self.textView, recordButton: self.recordButton)
                self.readingChart = self.readingChart.filter(){$0 != self.testResults}
                try! self.startRecording()
                self.recordButton.setTitle("停止錄音", for: [])
                self.beforeTime = Date()
            }
            
            if(self.recordButton.currentTitle! == "開始錄音" && self.testMode == "手動"){
                self.testResults = showContents(leftContents: self.readingChart, times: self.testNumbers + 1, textView: self.textView, recordButton: self.recordButton)
                self.readingChart = self.readingChart.filter(){$0 != self.testResults}
                try! self.startRecording()
                self.beforeTime = Date()
                return
            }
            
            if(self.recordButton.currentTitle! == "停止錄音" && self.testMode == "手動"){
                self.audioRecorder.stop()
                self.stopRecord()
                self.recordButton.setTitle("開始錄音", for: [])
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
            self.errtextField.placeholder = "错字数"
            self.errtextField.clearButtonMode = .whileEditing
            self.errtextField.text! = "0"
            self.errtextField.inputView = self.errpickView
            
        }
        
        let okAction = UIAlertAction(title: "確認", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            let login = (optionMenu.textFields?.first)! as UITextField
            if (login.text != ""){
                let error = Int(login.text!)!
                self.recordButton.isHidden = true
                self.errorWord[self.testNumbers] = ""  //手动情况不记录测试错字
                self.errorNum[self.testNumbers] = error //手动计入错字数

                
                if(error < 11){
                self.timeSpent[self.testNumbers] = log10(Double(12 - error) / timeSpent * 60)
                //总共19个测试
                if(self.testNumbers != 18){
                self.testNumbers += 1
                self.countDownNumber = 4
                self.timeRecord = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.countDown), userInfo: nil, repeats: true)}
                    else{self.stopTest()}
                }
                
                if(error == 11){
                    self.timeSpent[self.testNumbers] = log10(Double(12 - error) / timeSpent * 60)
                    self.stopTest()
                }
                
                if(error == 12){
                    self.timeSpent[self.testNumbers] = 0
                    self.stopTest()
                }
            
            }})
        
        optionMenu.popoverPresentationController?.sourceView = textView
        let t1 = fullScreenSize.height
        let t2 = fullScreenSize.width
        
        optionMenu.popoverPresentationController?.sourceRect = CGRect(x:t1/3,y:t2/2,width:20,height:20)
        optionMenu.popoverPresentationController?.permittedArrowDirections = [.up]
        optionMenu.addAction(okAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    //停止后记录数据
    func stopRecord(){
        
        //record the time interval(according to definition)
        let nowTime = Date()
        var timeSpent = nowTime.timeIntervalSince(beforeTime) + 0.18
        if(testMode == "自動"){ timeSpent -= 1}//1s延迟
        let (errorWordsNum, filterWords) = findAccuracy(inputResults: inputResults, testResults: testResults)
        //--------------------------------------------------------------record for databse
        errorWord.append(filterWords)
        errorNum.append(errorWordsNum)
        costTime.append(timeSpent)
        selectedChart.append(testResults)
        
        //if(timeSpent == 0){self.timeSpent.append(timeSpent)}
        
        if(errorWordsNum != 12 ){
            timeSpent = log10(Double(12 - errorWordsNum) / timeSpent * 60)
        }
        else { //防止出现-INF
            timeSpent = 0}
        
        self.timeSpent.append(timeSpent)
        textView.text = ""
        
        
        // 手动模式下输入错字，重新计算timespent
        if(testMode == "手動"){manualInsert(timeSpent: costTime[self.testNumbers])}
        if(testMode == "自動"){
            if(errorWordsNum < 11){
                if(testNumbers != 18){ //19个测试
                testNumbers += 1
                recordButton.isHidden = true
                self.countDownNumber = 4
                self.timeRecord = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.countDown), userInfo: nil, repeats: true)
                }
            else{stopTest()}
            }
            else{
                stopTest()
            }
        }
    
    }
}

