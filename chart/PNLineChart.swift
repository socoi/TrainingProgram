//
//  PNLineChart.swift
//  PNChartSwift
//
//  Created by YiChen Zhou on 11/10/16.
//  Copyright © 2016 YiChen Zhou. All rights reserved.
//

import UIKit
import QuartzCore

class PNLineChart: UIView{

    public var xLabels: NSArray = []{
        didSet {
            if showLabel {
                xLabelWidth = chartCavanWidth! / CGFloat(xLabels.count)
                for index in 0..<xLabels.count {
                    let labelText = xLabels[index] as! String
                    let labelX = 2.0 * chartMargin + (CGFloat(index) * xLabelWidth) - (xLabelWidth / 2.0)
                    let label: PNChartLabel = PNChartLabel(frame: CGRect(x: CGFloat(labelX), y: CGFloat(chartMargin + chartCavanHeight!), width: CGFloat(xLabelWidth), height: CGFloat(chartMargin)))
                    label.textAlignment = NSTextAlignment.center
                    label.text = labelText
                    addSubview(label)
                }
            } else {
                xLabelWidth = frame.size.width / CGFloat(xLabels.count)
            }
        }
    }
    
    //Nsarray = []. now fixed
    public var yLabels: NSArray = []{
        didSet {
            yLabelNum = CGFloat(yLabels.count)
            let ySetp: CGFloat = (yValueMax - yValueMin) / CGFloat(yLabelNum)
            let yStepHeight: CGFloat = chartCavanHeight / CGFloat(yLabelNum)
            
            var index: CGFloat = 0.0
            
            for _ in yLabels {
                let labelY = chartCavanHeight - (index * yStepHeight)
                let label: PNChartLabel = PNChartLabel(frame: CGRect(x: CGFloat(0.0), y: labelY, width: chartMargin + 5.0, height: CGFloat(yLabelHeight)))
                label.textAlignment = .right
                label.text = String(format: yLabelFormat, Double(yValueMin + (ySetp * index)))
                index += 1
                addSubview(label)
            }
        }
    }
    
    // Array of LineChartData objects, one for eacg line
    public var chartData: NSArray = []{
        didSet{
            var yLabelsArray: NSMutableArray = NSMutableArray(capacity: chartData.count)
            var yMax: CGFloat = 0.0
            var yMin: CGFloat = CGFloat.infinity
            var yValue: CGFloat!
            
            // remove all shape layers before adding new ones
            for layer in chartLineArray {
                (layer as! CALayer).removeFromSuperlayer()
            }
            
            for layer in chartPointArray {
                (layer as! CALayer).removeFromSuperlayer()
            }
            
            chartLineArray = NSMutableArray(capacity: chartData.count)
            chartPointArray = NSMutableArray(capacity: chartData.count)
            
            // Set for point stroken
            let circleStrokeWidth: CGFloat = 2.0
            let lineWidth: CGFloat = 3.0
            
            for chart in chartData {
                // Create as many chart line layers as number of data
                let chartObj = chart as! PNLineChartData
                let chartLine: CAShapeLayer = CAShapeLayer()
                chartLine.lineCap = kCALineCapButt
                chartLine.lineJoin = kCALineJoinMiter
                chartLine.fillColor = UIColor.white.cgColor
                chartLine.lineWidth = lineWidth
                chartLine.strokeEnd = 0.0
                layer.addSublayer(chartLine)
                chartLineArray.add(chartLine)
                
                // Create as many chart point layers as number of data
                let pointLayer: CAShapeLayer = CAShapeLayer()
                pointLayer.strokeColor = chartObj.color.cgColor
                pointLayer.lineCap = kCALineCapRound
                pointLayer.lineJoin = kCALineJoinBevel
                pointLayer.fillColor = nil
                pointLayer.lineWidth = circleStrokeWidth
                layer.addSublayer(pointLayer)
                chartPointArray.add(pointLayer)
                
                for index in 0..<chartObj.itemCount {
                    yValue = CGFloat(chartObj.getData(index).y)
                    yLabelsArray.add(String(format: "%2f", yValue))
                    yMax = fmax(yMax, yValue)
                    yMin = fmin(yMin, yValue)
                }
            }
            
            // Min value for Y label
            if yMax < 5 {
                yMax = 5.0
            }
            
            if yMin < 0 {
                yMin = 0.0
            }
            
            //yValueMin = yMin
            //yValueMax = yMax
            
            //保证Y轴坐标
            yValueMin = 0
            yValueMax = 4
            
            if showLabel {
                yLabelsArray = [0, 0.5, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5]
                yLabels = yLabelsArray as NSArray
            }
            
            setNeedsDisplay()
        }
    }
    
    var pathPoints: NSMutableArray = []
    
    // X-Axis Info
    public var xLabelWidth: CGFloat = 0.0
    
    // Y-Axis Info
    public var yValueMax: CGFloat = 10.0//10
    public var yValueMin: CGFloat = 1.0
    public var yLabelNum: CGFloat = 0.0
    public var yLabelHeight: CGFloat = 12.0
    
    // Chart Info
    public var showLabel: Bool = true
    public var showCoordinateAxis: Bool = true
    public var chartCavanHeight: CGFloat!
    public var chartCavanWidth: CGFloat!
    public var chartMargin: CGFloat = 25.0
    
    // For Axis
    public var axisColor: UIColor = PNGrey
    public var axisWidth: CGFloat = 1.0
    public var xUnit: NSString!
    public var yUnit: NSString!
    
    // String Format for float values in y labels.
    public var yLabelFormat = "%1.1f"
    var chartLineArray: NSMutableArray = []
    var chartPointArray: NSMutableArray = []
    
    var chartPaths: NSMutableArray = []
    var pointPaths: NSMutableArray = []
    
    // Initialize Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setDefaultValues()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Functions
    
    func setDefaultValues() {
        self.backgroundColor = UIColor.white
        self.clipsToBounds = true
        self.chartLineArray = NSMutableArray()
        self.showLabel = false
        self.pathPoints = NSMutableArray()
        self.isUserInteractionEnabled = true
        
        self.chartCavanWidth = self.frame.size.width - (chartMargin * 2.0)
        self.chartCavanHeight = self.frame.size.height - (chartMargin * 2.0)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchPoint(touches: touches as NSSet, withEvent: event!)
        //touchKeyPoint(touches: touches as NSSet, withEvent: event!)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchPoint(touches: touches as NSSet, withEvent: event!)
        //touchKeyPoint(touches: touches as NSSet, withEvent: event!)
    }
    
    func touchPoint(touches: NSSet, withEvent event: UIEvent) {
        let touch: UITouch = touches.anyObject() as! UITouch
        let touchPoint = touch.location(in: self)
        
        for linePoints in pathPoints {
            let linePointsArray = linePoints as! Array<Any>
            
            for index in 0..<(linePointsArray.count - 1) {
                let p1: CGPoint = (linePointsArray[index] as! PNValue).point
                let p2: CGPoint = (linePointsArray[index + 1] as! PNValue).point
                
                // The closest distance from point to value
                var distance: CGFloat = fabs(((p2.x - p1.x) * (touchPoint.y - p1.y)) - ((p1.x - touchPoint.x) * (p1.y - p2.y)))
                distance = distance / hypot(p2.x - p1.x, p1.y - p2.y)
                
                if distance <= 5.0 {
                    for path in chartPaths {
                        if (path as AnyObject).contains(p1) {
                            userClickedOnLinePoint(point: touchPoint, lineIndex: chartPaths.index(of: path))
                        }
                    }
                }
            }
        }
    }
    
    func touchKeyPoint(touches: NSSet, withEvent event: UIEvent) {
        let touch: UITouch = touches.anyObject() as! UITouch
        let touchPoint = touch.location(in: self)
        
        for linePoints in pathPoints {
            let linePointsArray = pathPoints as NSArray
            
            for index in 0..<(linePointsArray.count - 1) {
                let p1: CGPoint = (linePointsArray[index] as! PNValue).point
                let p2: CGPoint = (linePointsArray[index + 1] as! PNValue).point
                
                let distanceToP1: CGFloat = fabs(CGFloat(hypot(touchPoint.x - p1.x , touchPoint.y - p1.y )))
                let distanceToP2: CGFloat = hypot( touchPoint.x - p2.x, touchPoint.y - p2.y)
                
                let distance: CGFloat = fmin(distanceToP1, distanceToP2)
                if distance <= 10.0 {
                    userClickedOnLineKeyPoint(point: touchPoint, lineIndex: pathPoints.index(of: linePoints), keyPointIndex: (distance == distanceToP2 ? index + 1 : index))
                }
            }
        }
    }
    
    //para：1. start from which index 2. scope
    func strokeChart(_ controlIndex : [Double]) {
        let chartPaths = NSMutableArray()
        let pointPaths = NSMutableArray()
        var startIndex = Int()
        
        var text : [String] = ["","","","","","","","","","","","","","","","","","",""]
        var textPoint : [String] = ["" , ""]
        
        
        // 0 for testCase, 1 for regression case
        for lineIndex in 0..<chartData.count {
            let chartData: PNLineChartData = self.chartData[lineIndex] as! PNLineChartData
            let chartLine = chartLineArray[lineIndex] as! CAShapeLayer
            let pointLayer = chartPointArray[lineIndex] as! CAShapeLayer
            
            var yValue: CGFloat!
            var innerGrade: CGFloat!
            
            UIGraphicsBeginImageContext(self.frame.size)
            
            let progressLine = UIBezierPath()
            progressLine.lineWidth = chartData.lineWidth
            progressLine.lineCapStyle = .round
            progressLine.lineJoinStyle = .round
            
            let pointPath = UIBezierPath()
            pointPath.lineWidth = chartData.lineWidth
            
            chartPaths.add(progressLine)
            pointPaths.add(pointPath)
            
            if !showLabel {
                chartCavanHeight = self.frame.size.height - 2.0 * yLabelHeight
                chartCavanWidth = self.frame.size.width
                chartMargin = 0.0
                xLabelWidth = (chartCavanWidth / CGFloat(xLabels.count - 1))
            }
            
            let linePointsArray = NSMutableArray()
            
            var lastX: CGFloat = 0.0
            var lastY: CGFloat = 0.0
            let inflexionWidth = chartData.inflexionPointWidth
            
            // 从不为0点的开始draw
            for index in 0..<chartData.itemCount - 1{
            if(CGFloat(chartData.getData(index).y) != 0 &&
                CGFloat(chartData.getData(index+1).y) != 0 ){
                    startIndex = index
                    break
                }
                else{
                    //全部测试通过
                    startIndex = 0
                }
            }
            
            //case1 : test cases total 19
            if(lineIndex == 0){
            for index in 0..<chartData.itemCount {
                yValue = CGFloat(chartData.getData(index).y)
                
                if(index < startIndex){
                    continue
                }
                
                if(yValueMax - yValueMin == 0){
                    innerGrade = (yValue - yValueMin) / (yValueMax - yValueMin + 1)}
                else{
                    innerGrade = (yValue - yValueMin) / (yValueMax - yValueMin)
                }
                
                let x: CGFloat = chartMargin * 2.0 + (CGFloat(index) * xLabelWidth)
                let y: CGFloat = chartCavanHeight - (innerGrade * chartCavanHeight!) + 5   //对齐
                
                switch chartData.inflexPointStyle {
                // Cycle Style Point
                case .Cycle:
                    let circleRect = CGRect(x: x - inflexionWidth/2.0, y: y - inflexionWidth/2.0, width: inflexionWidth, height: inflexionWidth)
                    let circleCenter = CGPoint(x: circleRect.origin.x + circleRect.size.width / 2.0, y: circleRect.origin.y + circleRect.size.height / 2.0)
                    pointPath.move(to: CGPoint(x: circleCenter.x + inflexionWidth / 2.0, y: circleCenter.y))
                    pointPath.addArc(withCenter: circleCenter, radius: CGFloat(inflexionWidth/2.0), startAngle: 0.0, endAngle: CGFloat(M_PI*2.0), clockwise: true)
                    
                    let textLabel = UITextField(frame : CGRect(x: x - inflexionWidth/2.0, y: y - inflexionWidth/2.0 + 7, width: 60, height: 20))
                    
                    //精度,0不显示
                    if yValue != 0{
                    text[index] = String(format: "%.3f",Double(yValue))}
                    textLabel.text = text[index]
                    self.addSubview(textLabel)
                    
                    
                    if index != startIndex {
                        // Calculate the point for line
                        
                        let distance = CGFloat(sqrt(pow(Double(x - lastX), 2.0) + pow(Double(y - lastY), 2.0)))
                        let lastX1 = lastX + (inflexionWidth/2.0) / distance * (x - lastX)
                        let lastY1 = lastY + (inflexionWidth/2.0) / distance * (y - lastY)
                        let x1 = x - (inflexionWidth/2.0) / distance * (x - lastX)
                        let y1 = y - (inflexionWidth/2.0) / distance * (y - lastY)
                        progressLine.move(to: CGPoint(x: lastX1, y: lastY1))
                        progressLine.addLine(to: CGPoint(x: x1, y: y1))
                    }
                    
                    lastX = x
                    lastY = y
                    
                default:
                    if index != startIndex {
                        progressLine.addLine(to: CGPoint(x: x, y: y))
                    }
                    
                    progressLine.move(to: CGPoint(x: x, y: y))
                }
                linePointsArray.add(PNValue(point: CGPoint(x: x, y: y)))
            }
            }
            
            //case2 : two stright lines 
            if(lineIndex == 1){
            for index in 0..<chartData.itemCount {
                yValue = CGFloat(chartData.getData(index).y)
                
                if(yValueMax - yValueMin == 0){
                    innerGrade = (yValue - yValueMin) / (yValueMax - yValueMin + 1)}
                else{
                    innerGrade = (yValue - yValueMin) / (yValueMax - yValueMin)
                }
                
                //calculate intersect position
                //
                
                //第一个index坐标根据不同的distance不同(eg: 1(40cm)-> -0.3) 3(25cm)->-0.1
                let first_index = 0.1 * controlIndex[3] - 0.4
                let xIntersect = (controlIndex[0] - first_index)/0.1
                let scope = pow(M_E, controlIndex[2]) //e^delta[2]
                var x_axis = (controlIndex[0] - controlIndex[1] / scope - first_index) / 0.1  //与x轴交点
                var x: CGFloat = 0
                
                if(x_axis < first_index){ x_axis = first_index} //与x轴交点不要越过y轴
                //if(index == 0){x = chartMargin * 2.0 + CGFloat(controlIndex[0]) * xLabelWidth}
                if(index == 0){x = chartMargin * 2.0 + CGFloat(x_axis) * xLabelWidth}
                if(index == 1){x = chartMargin * 2.0 + CGFloat(xIntersect) * xLabelWidth}
                if(index == 2){x = chartMargin * 2.0 + CGFloat(18) * xLabelWidth}
                
                let y: CGFloat = chartCavanHeight - (innerGrade * chartCavanHeight!)
                
                switch chartData.inflexPointStyle {
                // Square Style Point
                case .Square:
                    let squareRect = CGRect(x: x - inflexionWidth/2.0, y: y - inflexionWidth/2.0, width: inflexionWidth, height: inflexionWidth)
                    let squareCenter = CGPoint(x: squareRect.origin.x + (squareRect.size.width / 2.0), y: squareRect.origin.y  + (squareRect.size.height / 2.0))
                    pointPath.move(to: CGPoint(x: squareCenter.x - (inflexionWidth/2.0), y: squareCenter.y - (inflexionWidth/2.0)))
                    pointPath.addLine(to: CGPoint(x: squareCenter.x + (inflexionWidth/2.0), y: squareCenter.y - (inflexionWidth/2.0)))
                    pointPath.addLine(to: CGPoint(x: squareCenter.x + (inflexionWidth/2.0), y: squareCenter.y + (inflexionWidth/2.0)))
                    pointPath.addLine(to: CGPoint(x: squareCenter.x - (inflexionWidth/2.0), y: squareCenter.y + (inflexionWidth/2.0)))
                    pointPath.close()
                    
                    if(index == 1){
                    let textLabel = UITextView(frame : CGRect(x: x - inflexionWidth/2.0 - 40, y: y - inflexionWidth/2.0 - 85, width: 90, height: 40))
                        
                    textPoint[0] = String(format: "%.3f",Double(controlIndex[0]))
                    textPoint[1] = String(format: "%.3f",Double(pow(10, controlIndex[1])))
                        textLabel.text = "CPS: " + textPoint[0] + "\n" + "MRS: " + textPoint[1] + "\n"
                        self.addSubview(textLabel)}
                    
                    if index != 0 {
                        // Calculate the point for line
                        let distance = CGFloat(sqrt(pow(x - lastX, 2.0) + pow(y - lastY, 2.0)))
                        let lastX1 = lastX + (inflexionWidth / 2.0)
                        let lastY1 = lastY + (inflexionWidth / 2.0) / distance * (y - lastY)
                        let x1 = x - (inflexionWidth / 2.0)
                        let y1 = y - (inflexionWidth / 2.0) / distance * (y - lastY)
                        
                        if(index == 1){
                           // progressLine.move(to: CGPoint(x: chartMargin * 2.0 + (CGFloat(index) * xLabelWidth), y: chartCavanHeight - (innerGrade * chartCavanHeight!)))
                           // progressLine.addLine(to: CGPoint(x: x1, y: chartCavanHeight - (innerGrade * chartCavanHeight!)))
                        }
                        
                        progressLine.move(to: CGPoint(x: lastX1, y: lastY1))
                        progressLine.addLine(to: CGPoint(x: x1, y: y1))
                    }
                    
                    
                    //initialize starIndex
                    lastX = x
                    lastY = y
                
                default:
                    if index != 0 {
                        progressLine.addLine(to: CGPoint(x: x, y: y))
                    }
                    
                    progressLine.move(to: CGPoint(x: x, y: y))
                }
                linePointsArray.add(PNValue(point: CGPoint(x: x, y: y)))
            }
            }
            
            pathPoints.add(linePointsArray)
            
            // Setup color for chart line
            if chartData.color != UIColor.black {
                chartLine.strokeColor = chartData.color.cgColor
                pointLayer.strokeColor = chartData.color.cgColor
            } else {
                chartLine.strokeColor = PNGreen.cgColor
                chartLine.strokeColor = PNGreen.cgColor
            }
            
            progressLine.stroke()
            
            chartLine.path = progressLine.cgPath
            pointLayer.path = pointPath.cgPath
            
            CATransaction.begin()
            let path = CABasicAnimation(keyPath: "strokeEnd")
            path.duration = 1.0
            path.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            path.fromValue = 0.0
            path.toValue = 1.0
            
            chartLine.add(path, forKey: "strokeEndAnimation")
            chartLine.strokeEnd = 1.0
            
            if chartData.inflexPointStyle != .None {
                pointLayer.add(path, forKey: "strokeEndAnimation")
            }
            
            CATransaction.commit()
            
            UIGraphicsEndImageContext()
        }
    }
    
    override func draw(_ rect: CGRect) {
        if showCoordinateAxis {
            let yAxisOffset: CGFloat = 10.0
            let ctx = UIGraphicsGetCurrentContext()
            UIGraphicsPushContext(ctx!)
            ctx?.setLineWidth(axisWidth)
            ctx?.setStrokeColor(axisColor.cgColor)
            
            let xAxisWidth: CGFloat = rect.width - chartMargin / 2.0
            let yAxisHeight: CGFloat = chartMargin + chartCavanHeight
            
            // Draw coordinate axis
            ctx?.move(to: CGPoint(x: chartMargin + yAxisOffset, y: 0.0))
            ctx?.addLine(to: CGPoint(x: chartMargin + yAxisOffset, y: yAxisHeight))
            ctx?.addLine(to: CGPoint(x: xAxisWidth, y: yAxisHeight))
            ctx?.strokePath()
            
            // Draw y axis arrow
            ctx?.move(to: CGPoint(x: chartMargin + yAxisOffset - 3.0, y: 6.0))
            ctx?.addLine(to: CGPoint(x: chartMargin + yAxisOffset, y: 0.0))
            ctx?.addLine(to: CGPoint(x: chartMargin + yAxisOffset + 3.0, y: 6.0))
            ctx?.strokePath()
            
            // Draw x axis arrow
            ctx?.move(to: CGPoint(x: xAxisWidth - 6.0, y: yAxisHeight - 3.0))
            ctx?.addLine(to: CGPoint(x: xAxisWidth, y: yAxisHeight))
            ctx?.addLine(to: CGPoint(x: xAxisWidth - 6.0, y: yAxisHeight + 3.0))
            ctx?.strokePath()
            
            if showLabel {
                // Draw x axis separator
                var point: CGPoint!
                for index in 0..<xLabels.count {
                    point = CGPoint(x: 2.0 * chartMargin + CGFloat(index) * xLabelWidth, y: chartMargin + chartCavanHeight!)
                    ctx?.move(to: CGPoint(x: point.x, y: point.y - 2.0))
                    ctx?.addLine(to: CGPoint(x: point.x, y: point.y))
                    ctx?.strokePath()
                }
                
                // Draw y axis separator
                let yStepHeight = chartCavanHeight / yLabelNum
                for index in 0..<xLabels.count {
                    point = CGPoint(x: chartMargin + yAxisOffset, y: (chartCavanHeight - CGFloat(index) * yStepHeight + yLabelHeight / 2.0))
                    ctx?.move(to: CGPoint(x: point.x, y: point.y))
                    ctx?.addLine(to: CGPoint(x: point.x + 2.0, y: point.y))
                    ctx?.strokePath()
                }
            }
            
            let font = UIFont(name: "Avenir-Medium", size: 11.0)
            
            // Draw y unit
            if yUnit != nil {
                let height = heightOfString(text: yUnit, width: 30.0, font: font!)
                let drawRect = CGRect(x: chartMargin + 15.0, y: 0.0, width: 30.0, height: height)
                drawTextInContext(ctx: ctx!, text: yUnit, rect: drawRect, font: font!)
            }
            
            if xUnit != nil {
                let height = heightOfString(text: xUnit, width: 30.0, font: font!)
                let drawRect = CGRect(x: rect.width - chartMargin + 5.0, y: chartMargin + chartCavanHeight - height / 2.0, width: 25.0, height: height)
                drawTextInContext(ctx: ctx!, text: xUnit, rect: drawRect, font: font!)
            }
        }
        super.draw(rect)
    }
}

extension PNLineChart {
    func heightOfString(text: NSString, width: CGFloat, font: UIFont) -> CGFloat {
        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let rect = text.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return rect.size.height
    }
    
    func drawTextInContext(ctx: CGContext, text: NSString, rect: CGRect, font: UIFont) {
        let priceParagraphStyle: NSMutableParagraphStyle = NSParagraphStyle.default as! NSMutableParagraphStyle
        priceParagraphStyle.lineBreakMode = .byTruncatingTail
        priceParagraphStyle.alignment = .left
        text.draw(in: rect, withAttributes: [NSParagraphStyleAttributeName: priceParagraphStyle])
    }
    
    func userClickedOnLineKeyPoint(point: CGPoint, lineIndex: Int, keyPointIndex: Int) {
        print("Click Key on line \(point.x), \(point.y) line index is \(lineIndex) and point index is \(keyPointIndex)")
    }
    
    func userClickedOnLinePoint(point: CGPoint, lineIndex: Int) {
        print("Click Key on line \(point.x), \(point.y) line index is \(lineIndex)")
    }
}
