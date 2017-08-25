//
//  SubContentsViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 11/8/15.
//  Copyright © 2015 Yuji Hato. All rights reserved.
//

import UIKit

class SubContentsViewController: UIViewController {
    
    let fullScreenSize = UIScreen.main.bounds.size
    public var yLabel = [Double]()
    public var regressionLabel = [Double]()
    public let userName = String()
    public var distanceVary = Double()
    public var xLabel = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //before: 0,135,720,500
        let y = fullScreenSize.height
        let x = fullScreenSize.width
        let lineChart = PNLineChart(frame: CGRect(x: 0.0, y: 0, width: x/1.3, height: y/1.3))
        //let lineChart = PNLineChart(frame: CGRect(x: 0.0, y: 0, width: fullScreenSize.width - 300, height: fullScreenSize.height - 300))
        
        
        for i in 1...15{
            let s = String(format: "%1.2f", Double(i) * 0.1 * distanceVary)
            xLabel.append(s)
        }
    
        lineChart.yLabelFormat = "%1.2f"
        lineChart.showLabel = true
        lineChart.backgroundColor = UIColor.clear
        lineChart.xLabels = ["-0.30" , "-0.20" , "-0.10" , "0" , xLabel[0] , xLabel[1] , xLabel[2] ,xLabel[3] ,xLabel[4] , xLabel[5] , xLabel[6], xLabel[7], xLabel[8], xLabel[9], xLabel[10], xLabel[11],xLabel[12],xLabel[13], xLabel[14]]

        
        lineChart.showCoordinateAxis = true
        lineChart.center = self.view.center
        
        //delete untested pass
        //yLabel = yLabel.filter{ $0 != 0 }
        //var yLabel = [log10(147.0),log10(160.0),log10(159.0),log10(153.0),log10(189.0),log10(128.0),log10(145.0),log10(147.0),log10(156.0),log10(70.0)]
        
        // since x-axis start from -0.3 , need reverse
        yLabel = yLabel.reversed()
        

        
        
        regressionLabel = [1.3 , 2.5 , 4]
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
        
//        let regressionData = PNLineChartData()
//        regressionData.color = PNRed
//        regressionData.itemCount = dataRegression.count
//        regressionData.inflexPointStyle = .Cycle
//        regressionData.getData = ({
//            (index: Int) -> PNLineChartDataItem in
//            let yValue = CGFloat(dataRegression[index])
//            let item = PNLineChartDataItem(y: yValue)
//            return item
//        })
        
        
        
        lineChart.chartData = [data]
        lineChart.strokeChart()
     
        // Change the chart you want to present here
        self.view.addSubview(lineChart)
        
        
    }
    
}


