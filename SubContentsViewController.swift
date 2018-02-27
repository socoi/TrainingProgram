//timeSpent1,timespent2,.....timeSpent19
//readChart1,readChart2......readChart19
//errorWord1,errorWord2........errorWord19
//errorNum1,errNum2.......errorNum19


import UIKit
import SpreadsheetView

class SubContentsViewController: UIViewController , SpreadsheetViewDataSource, SpreadsheetViewDelegate {

    
    let fullScreenSize = UIScreen.main.bounds.size
    
    //read from database
    public var yLabel = [Double]()
    public var distanceVary = Double()
    public var costTime = [Double]()
    public var readChart = [String]()
    public var errorWord = [String]()
    public var errorNum = [Int]()

    public var regressionLabel = [Double]()
    public var xLabel = [String]()
    public var xValueLabel = [Double]()
    public var xValue = [Double]()
    public var theta = Double()
    public var regressionIndex = [Double]()
    public var midIndex = Int()
    @IBOutlet weak var mnreadChart: UIView!
    @IBOutlet weak var spreadsheetView: SpreadsheetView!
    
    
    let rows = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19"]
    let columns = ["完成時間", "正確句子", "測試錯字", "錯字數目"]
    
                     
    let evenRowColor = UIColor(red: 0.914, green: 0.914, blue: 0.906, alpha: 1)
    let oddRowColor: UIColor = .white
    
    var inputData = [
        ["", "", "", ""],
        ["", "", "", ""],
        ["", "", "", ""],
        ["", "", "", ""],
        ["", "", "", ""],
        ["", "", "", ""],
        ["", "", "", ""],
        ["", "", "", ""],
        ["", "", "", ""],
        ["", "", "", ""],
        ["", "", "", ""],
        ["", "", "", ""],
        ["", "", "", ""],
        ["", "", "", ""],
        ["", "", "", ""],
        ["", "", "", ""],
        ["", "", "", ""],
        ["", "", "", ""],
        ["", "", "", ""]
    ]
    
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
        if case 0 = row {
            return 24
        } else if case 1 = row {
            return 32
        } else if case 2 = row{
            return 30 // 上下拉伸
        }
        else if case 5 = row {
            return 30
        }
        else {
            return 100
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
//        if case (1...(dates.count + 1), 0) = (indexPath.column, indexPath.row) {
//            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: DateCell.self), for: indexPath) as! DateCell
//            cell.label.text = dates[indexPath.column - 1]
//            return cell}
        
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
                
                //调整正确句子和测试错字两行
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
    
    

    //------------------------------------------------------------------------------------------------
    
    func average(_ input: [Double]) -> Double {
        return input.reduce(0, +) / Double(input.count)
    }
    
    func multiply(_ a: [Double], _ b: [Double]) -> [Double] {
        return zip(a,b).map(*)
    }
    
    func linearRegression(_ xs: [Double], _ ys: [Double]) -> Double {
        let lsx = Array(xs.prefix(xs.count - midIndex))
        let lsy = Array(ys.prefix(ys.count - midIndex))
        let sum1 = average(multiply(lsx, lsy)) - average(lsx) * average(lsy)
        let sum2 = average(multiply(lsx, lsx)) - pow(average(lsx), 2)
        let slope = sum1 / sum2
        let intercept = average(lsy) - slope * average(lsx)
        let x = (theta - intercept) / slope
        return x
    }
    
    
    //two stright lines intersection, find optimal(theshold 0.4) not reversed yet
    //get thate and optimal index point
    func findTheta(_ xs : [Double]) -> (Double , Int){
        if(xs.count > 2){
        for i in 0...xs.count - 3{
            if(xs[i] - xs[i + 1] > 0.4 && xs[i + 1] > xs[i + 2]){
                let resultArray : [Double] = Array(xs.prefix(i))
                return (average(resultArray) , i)
            }
        }
    }
        return (0.0 , 0)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //update inputdata

        for i in 0...18{
            if(costTime[i] != 0){
                self.inputData[i][0] = String(format: "%1.2f", costTime[i])
            }
        }
        
        for i in 0...18{
            if(readChart[i] != "None"){
            self.inputData[i][1] = readChart[i]
            }
        }
        
        for i in 0...18{
            if(errorWord[i] != "None")
            {
            self.inputData[i][2] = errorWord[i]
            }
        }
        
        for i in 0...18{
            if(errorNum[i] != -99){
            self.inputData[i][3] = String(errorNum[i])
            }
        }
                
        
        
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
        
        
        for i in 1...19{
            if(i < 5){
            let s = String(format: "%1.2f", Double(i) * 0.1 - 0.4 )
            let t = ((Double(i) * 0.1 - 0.4) * 100).rounded() / 100
            xValueLabel.append(t)
            xLabel.append(s)
            }
            else{
            let s = String(format: "%1.2f", Double(i - 4) * 0.1 * distanceVary)
            let t = ((Double(i - 4) * 0.1 * distanceVary) * 100).rounded() / 100
            xValueLabel.append(t)
            xLabel.append(s)
            }
        }
    
        lineChart.yLabelFormat = "%1.2f"
        lineChart.showLabel = true
        lineChart.backgroundColor = UIColor.clear
        lineChart.xLabels = xLabel as NSArray

        
        lineChart.showCoordinateAxis = true
        
        //lineChart.center = self.view.center
        //lineChart.center = mnreadChart.
        
        //delete untested pass
        //yLabel = yLabel.filter{ $0 != 0 }
        // since x-axis start from -0.3 , need reverse
        //yLabel = [log10(136.0),log10(151), log10(150), log10(196), log10(152) , log10(196) ,log10(132) ,log10(199) ,log10(116) ,log10(178) ,log10(163) ,log10(172) ,log10(76) ,log10(17) ,0 , 0 , 0 , 0 , 0]
        
        //yLabel = [1.99,2.0, 2.0, 2.11, 2.07, 2.09 ,2.08 ,1.96 ,1.43 ,1.22,1.54 ,1.17,1.14 ,1.38 ,1 , 0 , 0 , 0 , 0]
        (theta,midIndex) = findTheta(yLabel)
        yLabel = yLabel.reversed()
        

        
        let dataArr = yLabel
        //let dataRegression = regressionLabel
        
        let data = PNLineChartData()
        data.color = PNDeepGreen
        data.itemCount = dataArr.count
        data.inflexPointStyle = .Cycle
        data.getData = ({
            (index: Int) -> PNLineChartDataItem in
            let yValue = CGFloat(dataArr[index])
            let item = PNLineChartDataItem(y: yValue)
            return item
        })
        
        //startIndex, if all test pass start from 0
        var startIndex = yLabel.count - (yLabel.filter{$0 != 0.0}).count - 1
        if(startIndex == -1){ startIndex = 0}
        regressionIndex.append(Double(startIndex))
        
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

        
        //交点x的准确坐标
        let resultX = linearRegression(xValue, yLabel)
        regressionIndex.append(resultX)
        regressionIndex.append(theta)
        regressionIndex.append(distanceVary)
       
        //作图中3个y坐标
        regressionLabel = [yLabel[0] , theta , theta]
        
        
        let regressionData = PNLineChartData()
        regressionData.color = PNRed
        regressionData.itemCount = regressionLabel.count
        regressionData.inflexPointStyle = .Square
        regressionData.getData = ({
            (index: Int) -> PNLineChartDataItem in
            let yValue = CGFloat(self.regressionLabel[index])
            let item = PNLineChartDataItem(y: yValue)
            return item
        })
        
        
        if (theta,midIndex) != (0.0 ,0){
            lineChart.chartData = [data, regressionData]}
        else {
            lineChart.chartData = [data]
        }
        lineChart.strokeChart(regressionIndex)
     
        // Change the chart you want to present here
        //self.view.addSubview(lineChart)
        self.mnreadChart.addSubview(lineChart)
        
        
    }
    
}


