//
//  TestDemo.swift
//  TrainingProgram
//
//  Created by MAC User on 29/3/2018.
//  Copyright © 2018 Zhao Ruohan. All rights reserved.
//  测试的演示模型

import UIKit
import Speech

public class DemoViewController: UIViewController, SFSpeechRecognizerDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    // MARK: Properties
    
    //zh-HK广东话, zh普通话
    private var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "zh-HK"))!
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    
    private var recognitionTask: SFSpeechRecognitionTask?
    
    private let audioEngine = AVAudioEngine()
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var recordButton: UIButton!
    
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
    public let fontSize = [77,62.5,49,38.5,30.5,24,20,16,12,9,8,6.5,5,4,2.5,2,1.5,1.1,0.9]
    
    public let errpickView:UIPickerView = UIPickerView()
    public var errtextField = UITextField()
    public var mnread_num = 2
    public let errcontent = Array(0...12)

    

    
    public var readingChart = ["每個人都主宰著自己的命運","實踐是通往知識的唯一道路 "]
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {return 1}
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == errpickView){
            return errcontent.count
        }
        return(0)
    }
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView == errpickView){
            return String(errcontent[row])
        }
        return("error")
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView == errpickView){
            errtextField.text! =  String(errcontent[row])
        }
    }
    
    public override func viewDidAppear(_ animated: Bool) {
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
    }
    
//    public override func viewWillDisappear(_ animated: Bool) {
//         super.viewWillDisappear(false)
//         self.dismiss(animated: false, completion: nil)
//    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        let optionMenu = UIAlertController(title: "MNRead 示範",message:"", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "開始", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            self.countDownNumber = 4
            self.timeRecord = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.countDown), userInfo: nil, repeats: true)
        })
        optionMenu.addAction(okAction)
        optionMenu.popoverPresentationController?.sourceView = self.textView
        let t1 = self.fullScreenSize.height
        let t2 = self.fullScreenSize.width
        
        optionMenu.popoverPresentationController?.sourceRect = CGRect(x:t1/3,y:t2/2,width:40,height:40)
        optionMenu.popoverPresentationController?.permittedArrowDirections = [.up]
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    
    public func testContent(num : Int) -> String{
        return readingChart[num - 1]
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
        contents(str: testContent(num: times), num : times)}
    
    
    public func stopTest(){
            recordButton.isHidden = true
            let optionMenu = UIAlertController(title: "測試結束", message: inputResults, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "返回", style: .cancel, handler: {
                (alert: UIAlertAction!) -> Void in
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
        self.setNavigationBarItem()
        
        errpickView.delegate = self
        errpickView.dataSource = self
        errpickView.selectRow(0, inComponent:0, animated:true)
        
        // Disable the record buttons until authorization has been granted.
        recordButton.isHidden = true
        
        
        // let textView horizon center
        textView.textAlignment = .center
        
        // text position(150,50,10,10)
        textView.textContainerInset = UIEdgeInsetsMake(50, 10, 150, 10)
        
        textView.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle(rawValue: "新細明體"))
        
        var language : [String:String] = [ "廣東話": "zh-HK", "國語": "zh-TW"]
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: language["國語"]!))!
        
        
    }
    
    
    //detect accuracy, whether continue()
    //any three words match -> pass
    //return number of correct words and its contents
    public func findAccuracy(myNumber : Int) -> (Int,String) {
        //error words
        var filterWords = ""
        testResults = testContent(num: myNumber)
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
            if self.audioEngine.isRunning {
                self.audioEngine.stop()
                self.recognitionRequest?.endAudio()
                self.recordButton.isEnabled = false
                self.recordButton.setTitle("Stopping", for: .disabled)
                
            } else {
                
                //start to record the time
                self.showContents(times: self.testNumbers + 1)
                try! self.startRecording()
                self.recordButton.setTitle("停止錄音", for: [])
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
            self.errtextField.placeholder = "错字数"
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
                self.errorWord[self.testNumbers] = ""  //手动情况不记录测试错字
                self.errorNum[self.testNumbers] = error! //手动计入错字数
                
                
                if(error! < 11){
                    self.timeSpent[self.testNumbers] = log10(Double(12 - error!) / timeSpent * 60)
                    //prepare for the test
                    if(self.testNumbers != 1){
                    self.testNumbers += 1
                    self.countDownNumber = 4
                    self.timeRecord = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.countDown), userInfo: nil, repeats: true)
                    }
                    else{self.stopTest()}
                }
                
                if(error! == 11){
                    self.timeSpent[self.testNumbers] = log10(Double(12 - error!) / timeSpent * 60)
                    self.stopTest()
                }
                
                if(error! == 12){
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
        let (correctWords, filterWords) = findAccuracy(myNumber: testNumbers + 1)
        
        
        //--------------------------------------------------------------record for databse
        
        
        //errorWord
        errorWord.append(filterWords)
        
        //erroNumber
        errorNum.append(12 - correctWords)
        
        //timecost
        costTime.append(timeSpent)
        
        //testContent(random pick)
        //selectedChart.append(testContent(number : testNumbers + 1))
        
        
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
        if(self.testNumbers < 2){
            manualInsert(timeSpent: costTime[self.testNumbers])
        }
    }
}
