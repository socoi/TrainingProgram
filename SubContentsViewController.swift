import UIKit

class SubContentsViewController: UIViewController {
    
    let fullScreenSize = UIScreen.main.bounds.size
    public var yLabel = [Double]()
    public var regressionLabel = [Double]()
    public let userName = String()
    public var distanceVary = Double()
    public var xLabel = [String]()
    public var xValueLabel = [Double]()
    public var xValue = [Double]()
    public var theta = Double()
    public var regressionIndex = [Double]()
    public var midIndex = Int()
    
    
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
        
        
        //before: 0,135,720,500
        let y = fullScreenSize.height
        let x = fullScreenSize.width
        let lineChart = PNLineChart(frame: CGRect(x: 0.0, y: 0, width: x/1.3, height: y/1.3))
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
        lineChart.center = self.view.center
        
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
        self.view.addSubview(lineChart)
        
        
    }
    
}


