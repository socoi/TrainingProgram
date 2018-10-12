//timeSpent1,timespent2,.....timeSpent19
//readChart1,readChart2......readChart19
//errorWord1,errorWord2........errorWord19
//errorNum1,errNum2.......errorNum19


import UIKit
import SpreadsheetView



class SubContentsViewController: UIViewController , SpreadsheetViewDataSource, SpreadsheetViewDelegate  {
    
    let fullScreenSize = UIScreen.main.bounds.size
    public var songPlayer = AVAudioPlayer()

    
    //read from database
    public var yLabel = [Double]()
    public var distanceVary = Double() //1,2,3,4,5,6分别对应6个
    public var costTime = [Double]()
    public var readChart = [String]()
    public var errorWord = [String]()
    public var errorNum = [Int]()

    public var regressionLabel = [Double]()
    public var xLabel = [String]()
    public var xValueLabel = [Double]() // 处理后的x值(正负方向公式不同)
    public var xValue = [Double]() //从左到右坐标x的值(Double)
    public var theta = Double()
    public var regressionIndex = [Double]()  //[交点x坐标，交点y坐标,logscope, distanceVary]
    public var midIndex = Int()
    @IBOutlet weak var mnreadChart: UIView!
    @IBOutlet weak var spreadsheetView: SpreadsheetView!
    
    public var userName = String()
    public var userID = String()
    public var userAge = Int()
    public var userSex = String()
    public var userBirth = String()
    public var testTime = String()
    public var testCase = Int()
    public var language = String()
    public var testMode = String()
    
    public var path = String()
    public var curve_data = String()
    public let semaphore = DispatchSemaphore(value: 0)
    public let play_sound = DispatchSemaphore(value: 1)
    public var delta1 = Double()
    public var delta2 = Double()
    public var delta3 = Double()




    
    let rows = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19"]
    let columns = ["完成時間", "正確句子", "測試錯字", "錯字數目", "LogMar", "錄音"]
    
                     
    let evenRowColor = UIColor(red: 0.914, green: 0.914, blue: 0.906, alpha: 1)
    let oddRowColor: UIColor = .white
    
    var inputData = [
        ["", "", "", "", "", ""],
        ["", "", "", "", "", ""],
        ["", "", "", "", "", ""],
        ["", "", "", "", "", ""],
        ["", "", "", "", "", ""],
        ["", "", "", "", "", ""],
        ["", "", "", "", "", ""],
        ["", "", "", "", "", ""],
        ["", "", "", "", "", ""],
        ["", "", "", "", "", ""],
        ["", "", "", "", "", ""],
        ["", "", "", "", "", ""],
        ["", "", "", "", "", ""],
        ["", "", "", "", "", ""],
        ["", "", "", "", "", ""],
        ["", "", "", "", "", ""],
        ["", "", "", "", "", ""],
        ["", "", "", "", "", ""],
        ["", "", "", "", "", ""]
    ]
    
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
        if case 0 = row {
            return 80 //120
        } else if case 1 = row {
            return 32
        } else if case 2 = row{
            return 30 // 上下拉伸
        }
        else if case 5 = row {
            return 30
        }
        else if case 6 = row {
            return 30
        }
        else if case 7 = row {
            return 45
        }
        else {
            return 70
        }
    }
    
    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return rows.count + 1
    }
    
    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        return columns.count + 2
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        if case 0 = column {
            return 70
        } else {
            return 60  // 左右拉伸
        }
    }
    
    
    
    func frozenColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return 1
    }
    
    func frozenRows(in spreadsheetView: SpreadsheetView) -> Int {
        return 2
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        if case (1, 0) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: DateCell.self), for: indexPath) as! DateCell
            cell.label.textColor = UIColor.blue
            cell.label.text = "ID: " + userID
            cell.label.font = UIFont(name: "System - System", size: CGFloat(25))
            cell.label.sizeToFit()
            //cell.frame = UIEdgeInsetsInsetRect(cell.frame, UIEdgeInsetsMake(-100, 0, 100, 0))
            
            return cell}
        if case (3, 0) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: DateCell.self), for: indexPath) as! DateCell
            cell.label.textColor = UIColor.blue
            cell.label.text = "姓名: " + userName
            cell.label.font = UIFont(name: "System - System", size: CGFloat(25))
            cell.label.sizeToFit()
            return cell}
        if case (6, 0) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: DateCell.self), for: indexPath) as! DateCell
            cell.label.textColor = UIColor.blue
            cell.label.text = "性別: " + userSex
            cell.label.font = UIFont(name: "System - System", size: CGFloat(25))
            cell.label.sizeToFit()
            return cell}

        if case (8, 0) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: DateCell.self), for: indexPath) as! DateCell
            cell.label.textColor = UIColor.blue
            cell.label.text = "出生日期: " + userBirth
            cell.label.font = UIFont(name: "System - System", size: CGFloat(25))
            cell.label.sizeToFit()
            return cell}
        if case (11, 0) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: DateCell.self), for: indexPath) as! DateCell
            cell.label.textColor = UIColor.blue
            cell.label.text = "測試: " + String(testCase)
            cell.label.font = UIFont(name: "System - System", size: CGFloat(25))
            cell.label.sizeToFit()
            return cell}
        if case (13, 0) = (indexPath.column, indexPath.row) {
            let distance : [Double : String] = [1.0: "40cm", 2.0 :"33cm" , 3.0 : "25cm" , 4.0: "20cm", 5.0: "16cm", 6.0: "13cm"]
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: DateCell.self), for: indexPath) as! DateCell
            cell.label.textColor = UIColor.blue
            cell.label.text = "距離: " + distance[distanceVary]!
            cell.label.font = UIFont(name: "System - System", size: CGFloat(25))
            cell.label.sizeToFit()
            return cell}
            
        if case (15, 0) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: DateCell.self), for: indexPath) as! DateCell
            cell.label.textColor = UIColor.blue
            cell.label.text = "語言: " + language
            cell.label.font = UIFont(name: "System - System", size: CGFloat(25))
            cell.label.sizeToFit()
            return cell}
        if case (17, 0) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: DateCell.self), for: indexPath) as! DateCell
            cell.label.textColor = UIColor.blue
            cell.label.text = "模式: " + testMode
            cell.label.font = UIFont(name: "System - System", size: CGFloat(25))
            cell.label.sizeToFit()

            //cell.label.font = UIFont.systemFontSize(CGFloat: 25)
            return cell}
        
        //"1,2,3,4........19 case"
        // case( 列，行 ) 列从0开始
        if case (1...(rows.count + 1), 1) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: DayTitleCell.self), for: indexPath) as! DayTitleCell
            cell.label.text = rows[indexPath.column - 1]
//            cell.label.textColor = columnsColor[indexPath.column - 1]
            cell.label.textColor = UIColor.black
            return cell
        } else if case (0, 1) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: TimeTitleCell.self), for: indexPath) as! TimeTitleCell
            //cell.label.font = UIFont(name:"Avenir", size:22)
            cell.label.text = "測試結果"
            return cell
        } else if case (0, 2...(columns.count + 2)) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: TimeCell.self), for: indexPath) as! TimeCell
            cell.label.text = columns[indexPath.row - 2]
            cell.backgroundColor = indexPath.row % 2 == 0 ? evenRowColor : oddRowColor
            return cell
        } else if case (1...(rows.count + 1), 2...(columns.count + 2)) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ScheduleCell.self), for: indexPath) as! ScheduleCell
            let text = inputData[indexPath.column - 1][indexPath.row - 2]
            if !text.isEmpty {
                
                //调整正确句子和测试错字
                if(indexPath.row - 2 == 2 || indexPath.row - 2 == 1){
                cell.label.numberOfLines = 3
                cell.label.lineBreakMode = .byWordWrapping
                cell.label.adjustsFontSizeToFitWidth = true
                cell.label.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                //cell.label.font = UIFont(name:"Avenir", size:10)
                cell.label.text = text
                //let color = columnsColor[indexPath.column - 1]
                let color : UIColor = .black
                cell.label.textColor = color
                cell.color = color.withAlphaComponent(0.2)
                cell.borders.top = .solid(width: 2, color: color)
                cell.borders.bottom = .solid(width: 2, color: color)
                }
                //添加按钮
                if(indexPath.row - 2 == 5){
                    cell.label.layoutMargins = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 0)
                    cell.label.font = UIFont(name:"Avenir", size:60)
                    cell.label.text = text
                    //let color = columnsColor[indexPath.column - 1]
                    let color : UIColor = .black
                    cell.label.textColor = color
                    cell.color = color.withAlphaComponent(0.2)
                    
                    let button : UIButton = UIButton(type:UIButtonType.custom) as UIButton
                    button.setImage(UIImage(named: "play.png"), for: .normal)
                    button.frame = CGRect(origin: CGPoint(x: 200,y :60), size: CGSize(width: 40, height: 24))
                    button.tag = indexPath.column
                    let cellHeight: CGFloat = 44.0
                    button.center = CGPoint(x: view.bounds.width / 45, y: cellHeight / 2.0) //调整按钮位置
                    button.setTitleColor(.blue, for: .normal)
                    button.addTarget(self, action: #selector(playMusic), for: UIControlEvents.touchUpInside)
                    button.setTitle("Add", for: UIControlState.normal)
                    
                    cell.addSubview(button)
                }
                else{
                cell.label.text = text
                //let color = columnsColor[indexPath.column - 1]
                let color : UIColor = .black
                cell.label.textColor = color
                cell.color = color.withAlphaComponent(0.2)
                cell.borders.top = .solid(width: 2, color: color)
                cell.borders.bottom = .solid(width: 2, color: color)
                }
            } else {
                cell.label.text = nil
                cell.color = indexPath.row % 2 == 0 ? evenRowColor : oddRowColor
                cell.borders.top = .none
                cell.borders.bottom = .none
            }
            return cell
        }
        return nil
    }
    
    /// Delegate
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, didSelectItemAt indexPath: IndexPath) {
        print("Selected: (row: \(indexPath.row), column: \(indexPath.column))")
    }
    
    func updateViewData(){
        //update inputdata
        
        let endPoint = costTime.filter{$0 != 0}
        
        for i in 0...18{
            if(costTime[i] != 0){
                self.inputData[i][0] = String(format: "%1.2f", costTime[i])}
            if(readChart[i] != "None"){
                self.inputData[i][1] = readChart[i]}
            if(errorWord[i] != "None"){
                self.inputData[i][2] = errorWord[i]}
            if(errorNum[i] != -99){
                self.inputData[i][3] = String(errorNum[i])}
            if(xValueLabel[18 - i] != -99 && i < endPoint.count){
                self.inputData[i][4] = String(xValueLabel[18 - i])
            }
            if(i<endPoint.count){
                self.inputData[i][5] = "_"
            }
        }
    }
    
    //播放音乐
    func playMusic(sender: UIButton!) {
        let row = sender.tag
        let fileName = self.userID + "_" + self.userName + "_test" + String(self.testCase) + "_" + String(row) + ".m4a"
        let audioFileName = path + "/" + fileName
        
        self.play_sound.signal()
        do{
        
        try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: AVAudioSessionCategoryOptions.mixWithOthers)
        songPlayer = try AVAudioPlayer(contentsOf: URL(string: audioFileName)!)
        
        if(songPlayer.isPlaying){
            songPlayer.stop()}
            songPlayer.prepareToPlay()
            songPlayer.play()
            _ = play_sound.wait(timeout: DispatchTime.distantFuture)
        }

        catch{
            print("failture")
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        self.path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // customize sheet
        self.spreadsheetView.dataSource = self
        self.spreadsheetView.delegate = self

        
        spreadsheetView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        spreadsheetView.intercellSpacing = CGSize(width: 4, height: 1)
        spreadsheetView.gridStyle = .none
        
        spreadsheetView.register(DateCell.self, forCellWithReuseIdentifier: String(describing: DateCell.self))
        spreadsheetView.register(TimeTitleCell.self, forCellWithReuseIdentifier: String(describing: TimeTitleCell.self))
        spreadsheetView.register(TimeCell.self, forCellWithReuseIdentifier: String(describing: TimeCell.self))
        spreadsheetView.register(DayTitleCell.self, forCellWithReuseIdentifier: String(describing: DayTitleCell.self))
        spreadsheetView.register(ScheduleCell.self, forCellWithReuseIdentifier: String(describing: ScheduleCell.self))
        
       // ————————————————————————————————————————————————————————————————————————————————————————————
        
        //before: 0,135,720,500
        let y = fullScreenSize.height
        let x = fullScreenSize.width
        let lineChart = PNLineChart(frame: CGRect(x: 150, y: 50, width: x/1.2, height: y/1.8)) // /1.3
        //let lineChart = PNLineChart(frame: CGRect(x: 0.0, y: 0, width: fullScreenSize.width - 300, height: fullScreenSize.height - 300))
        
        
        //logmar计算. 40cm从1.5开始, 13cm从2.0开始. -0.1递减
        for i in 1...19{
            let value = -0.5 + Double((Int(distanceVary) + i)) * 0.1
            let s = String(format: "%1.2f", value)
            let t = (value * 100).rounded() / 100
            xValueLabel.append(t)
            xLabel.append(s)
        }
        
        //chartData(PNLineChart.swift)有改 y轴0-4 margin: 0.5
        lineChart.yLabelFormat = "%1.1f"
        lineChart.showLabel = true
        lineChart.backgroundColor = UIColor.clear
        lineChart.xLabels = xLabel as NSArray
        
        lineChart.showCoordinateAxis = true
        yLabel = yLabel.reversed()
        
        let dataArr = yLabel
        let data = PNLineChartData()
        data.color = PNDeepGreen
        data.itemCount = dataArr.count
        data.inflexPointStyle = .Cycle
        data.getData = ({
            (index: Int) -> PNLineChartDataItem in
            let yValue = CGFloat(dataArr[index])
            return PNLineChartDataItem(y: yValue)
        })
        
        
        yLabel = yLabel.filter{$0 != 0.0}
        xLabel = xLabel.reversed()
        //commom case: not all test pass(need last y=0 for calculation)
        if(yLabel.count != 19){
            yLabel = yLabel.reversed()
            yLabel.append(0.0)
            yLabel = yLabel.reversed()
        }
        for i in 0...(yLabel.count - 1){
            //initial calculatio
            xValue.append(xValueLabel[19 - yLabel.count + i])
        }
        
        // 传到服务器上计算regression
        // 保证数据先传回
        semaphore.signal()
        dataUploadRequest(x_value: xValue, y_value: yLabel, userName: userName, userID: userID, completionHandler: { (data) in
                print(data)
            let delta = data.components(separatedBy: " ")
            do{
            self.delta1 = Double(delta[0])!
            self.delta2 = Double(delta[1])!
            self.delta3 = Double(delta[2].dropLast().dropLast())! //去掉\n
            }
            catch{
                print("did not get number, please return")
            }
            })
 
        //lineChart.center = self.view.center
        //lineChart.center = mnreadChart.
        
        //delete untested pass
        //yLabel = yLabel.filter{ $0 != 0 }
        // since x-axis start from -0.3 , need reverse
        //yLabel = [log10(136.0),log10(151), log10(150), log10(196), log10(152) , log10(196) ,log10(132) ,log10(199) ,log10(116) ,log10(178) ,log10(163) ,log10(172) ,log10(76) ,log10(17) ,0 , 0 , 0 , 0 , 0]
        
        //yLabel = [1.99,2.0, 2.0, 2.11, 2.07, 2.09 ,2.08 ,1.96 ,1.43 ,1.22,1.54 ,1.17,1.14 ,1.38 ,1 , 0 , 0 , 0 , 0]
        
        //yLabel = [2.21, 2.23, 2.37, 2.19, 2.23, 2.34, 2.17, 1.52, 0.66, 1.50,0,0,0,0,0,0,0,0,0]
//            //////////// 原始计算curve_fitting的方法（错误的) //////////////
//            //交点x的准确坐标
//            let resultX = self.self.linearRegression(self.xValue, self.yLabel)
//            self.regressionIndex.append(resultX)
//            self.regressionIndex.append(self.theta)
//            self.regressionIndex.append(self.distanceVary)
        
              //test
//              self.delta1 = 2.2525
//              self.delta2 = 1.1365
//              self.delta3 = 1.2000
//              self.distanceVary = 1
        
              self.regressionIndex.append(delta3)
              self.regressionIndex.append(delta1)
              self.regressionIndex.append(delta2)
              self.regressionIndex.append(distanceVary)
        
        
            _ = semaphore.wait(timeout: DispatchTime.distantFuture) //等任务完成

            //3个交点的y坐标
            //self.regressionLabel = [self.yLabel[0] , self.theta , self.theta]
            self.regressionLabel = [self.yLabel[0] , delta1 , delta1]
            
            
            let regressionData = PNLineChartData()
            regressionData.color = PNRed
            regressionData.itemCount = self.regressionLabel.count
            regressionData.inflexPointStyle = .Square
            regressionData.getData = ({
                (index: Int) -> PNLineChartDataItem in
                let yValue = CGFloat(self.regressionLabel[index])
                return PNLineChartDataItem(y: yValue)
            })
        
            lineChart.chartData = [data, regressionData]
            lineChart.strokeChart(self.regressionIndex)
            
            ////para：1. start from which index 2. scope
            //填充表格信息
            self.updateViewData()
            
            
            
            // Change the chart you want to present here
            //self.view.addSubview(lineChart)
            self.mnreadChart.addSubview(lineChart)
            
    }
    
}
