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

public class Test1: UIViewController, SFSpeechRecognizerDelegate {
    // MARK: Properties
    
    //zh-HK广东话, zh普通话
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "zh-HK"))!
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    
    private var recognitionTask: SFSpeechRecognitionTask?
    
    private let audioEngine = AVAudioEngine()
    
    @IBOutlet var textView : UITextView!
    
    @IBOutlet var recordButton : UIButton!
    
    let fullScreenSize = UIScreen.main.bounds.size
    
    private var testNumbers  = Int()//test cases number
    private var testResults = String()//test contents
    private var inputResults = String()//speak contents
    public var beforeTime = Date()//starting time
    public var userName = String()
    public var timeRecord = Timer()
    public var countDownNumber = Int()
    public var timeSpent = Array<Double>()//attention! - > (correct number/test time) * 60
    public var myTime = String()
    public var fontColor = String()
    public var backColor = String()
    public var watchDistance = String() //depend watch distance adjust font size
    public var distanceVary = Double() //  pass to resultView controller
    public let fontSize = [77,62.5,49,38.5,30.5,24,20,16,12,9,8,6.5,5,4,2.5,2,1.5,1.1,0.9] //40cm :corresponse distance,77
    
    
    

    
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
    
    
    
    // MARK: UIViewController
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        let optionMenu = UIAlertController(title: "测试", message: "登錄", preferredStyle: .alert)
        
        optionMenu.addTextField {
            (textField: UITextField!) -> Void in
            textField.placeholder = "請輸入用戶名"
            textField.clearButtonMode = .whileEditing

        }
        
        let okAction = UIAlertAction(title: "開始", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            let login = (optionMenu.textFields?.first)! as UITextField
            
            if (login.text != ""){
            self.userName = login.text!
            
            //prepare for the test
            self.countDownNumber = 4
            self.timeRecord = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.countDown), userInfo: nil, repeats: true)
            }

        })
        
        let cancelAction = UIAlertAction(title: "取消", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            //return the main page
            self.performSegue(withIdentifier: "Test1", sender: self)
            
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
    
    public func testContent(number : Int ) -> String{
        switch number{
//        case 1: return "我们年纪很小就举行演奏会"
        case 1: return "我們年紀很小就舉行演奏會"
//        case 2: return "小鸟儿飞到我家屋前的树上"
        case 2: return "小鳥兒飛到我家屋前的樹上"
        case 3: return "昨天大表姐到醫院探望叔叔"
        case 3: return "昨天大表姐到醫院探望叔叔"
        case 4: return "我在摩天輪上看見藍天白雲"
        case 5: return "媽媽每天給大文講一個故事"
        case 6: return "這篇文章描述了新年的景象"
        case 7: return "小妹妹還沒上學便開始認字"
        case 8: return "張小華忘記把課室的門關上"
        case 9: return "大文三歲已經開始創作詩歌"
        case 10: return "花香引來各種各樣的小昆蟲"
        case 11: return "打乒乓球是我愛的課外活動"
        case 12: return "小朋友喜歡坐在旋轉木馬上"
        case 13: return "辛勤工作的人應該受到尊重"
        case 14: return "我學會用重複的句子來作詩"
        case 15: return "大笨象帶着五隻小河馬過河"
        case 16: return "姐姐和妹妹要做漂亮的花兒"
        case 17: return "蜻蜓早就停在荷葉上面休息"
        case 18: return "車站上的乘客焦急地等待着"
        case 19: return "小汽車緩慢地穿過這個山洞"
        default: return "Test Over"
        }
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
    
    public func stopTest(){
        
        //store data
        let stopTime = Date()
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .full
        dateformatter.timeStyle = .short
        let dateString = dateformatter.string(from : stopTime)
        let resultCell = self.userName + "   " + dateString
        
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
                ).first!

            let db = try! Connection("\(path)/db.sqlite3")
            let testResults = Table("testResults")
            let id = Expression<Int>("id")
            let details  = Expression<String>("details")
            let userName = Expression<String>("userName")
            let testTime = Expression<String>("testTime")
            let distanceVary = Expression<Double>("distanceVary")
        
        
        let testPass = self.timeSpent.count
        
        let insert = testResults.insert(
            details <- resultCell,
            userName <- self.userName,
            testTime <- dateString,
            distanceVary <- self.distanceVary
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
            self.myTime = "timeSpent" + "\(number)"
            let pass = Expression<Double>(self.myTime)
            let update = selectedRow.update(
               pass <- self.timeSpent[number - 1]
            )
            try! db.run(update)
            
        }

     
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
    

    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
            1.21, "25cm":1.6]
        
        //color and distance
        textView.textColor = colors[fontColor]
        textView.backgroundColor = colors[backColor]
        distanceVary = distance[watchDistance]!
        
        
    }
    
    
    //detect accuracy, whether continue()
    //any three words exist -> pass
    public func findAccuracy(myNumber : Int) -> Int{
        testResults = testContent(number : myNumber)
        //var correctChar = Int()
        var re1Arr = Array<String>()//input words
        var re2Arr = Array<String>()//test words
        
        //user say nothing -> equal to before
        if(inputResults == ""){
            return 0
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
        return commonWords.count
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
        recognitionRequest.shouldReportPartialResults = true
        
        // A recognition task represents a speech recognition session.
        // We keep a reference to the task so that it can be cancelled.
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
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
            
        }
        
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
            
           
            
            //record the time interval(according to definition)
            let nowTime = Date()
            var timeSpent = nowTime.timeIntervalSince(beforeTime) + 0.18
            let correctWords = Double(findAccuracy(myNumber: testNumbers + 1))
            
            //special case
            if(timeSpent == 0){
                self.timeSpent.append(timeSpent)
            }
            if(correctWords != 0 ){
                timeSpent = log10(correctWords / timeSpent * 60)
            }
            self.timeSpent.append(timeSpent)
            textView.text = ""  
            
            //previous test OK -> next test
            if(self.findAccuracy(myNumber: testNumbers + 1) > 1){
                testNumbers += 1
                recordButton.isHidden = true
                self.countDownNumber = 4
                self.timeRecord = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.countDown), userInfo: nil, repeats: true)

            }
            //or stop the test
            else{
//                testNumbers += 1
//                recordButton.isHidden = true
//                self.countDownNumber = 4
//                self.timeRecord = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.countDown), userInfo: nil, repeats: true)
                stopTest()
            }
            
            
        } else {
            
            //start to record the time
            self.showContents(times: testNumbers + 1)
            try! startRecording()
            recordButton.setTitle("停止錄音", for: [])
            self.beforeTime = Date()

        }
    }
    
    
}

