//
//  LoginUserInfo.swift
//  TrainingProgram
//
//  Created by MAC User on 6/10/2018.
//  Copyright © 2018 Zhao Ruohan. All rights reserved.
//

import Foundation





// This delegate method is called every time the face recognition has detected something (including change)
public func faceIsTracked(_ faceRect: CGRect, withOffsetWidth offsetWidth: Float, andOffsetHeight offsetHeight: Float, andDistance distance: Float, textView: UITextView) {
    CATransaction.begin()
    CATransaction.setAnimationDuration(0.1)
    let layer: CALayer? = textView.layer
    layer?.masksToBounds = false
    //layer?.shadowOffset = CGSize(width: CGFloat(offsetWidth / 5.0), height: CGFloat(offsetHeight / 10.0))
    layer?.shadowRadius = 0 //5
    layer?.shadowOpacity = 0//0.1
    CATransaction.commit()
}
// When the fluidUpdateInterval method is called, then this delegate method will be called on a regular interval

public func fluentUpdateDistance(_ distance: Float, textView: UITextView) {
    
    // Animate to the zoom level.
    let effectiveScale: Float = distance / 60.0     //origin : 60
    CATransaction.begin()
    CATransaction.setAnimationDuration(1.5)//origin: 0.1
    textView.layer.setAffineTransform(CGAffineTransform(scaleX: CGFloat(effectiveScale), y: CGFloat(effectiveScale)))
    CATransaction.commit()
}


//detect accuracy, whether continue()
//any one words match -> pass
//return number of error words and its contents
public func findAccuracy(inputResults : String, testResults : String) -> (Int,String) {
    //error words
    var filterWords = ""
    //testResults = selectedChart[myNumber]
    //var correctChar = Int()
    var re1Arr = Array<String>()//input words
    var re2Arr = Array<String>()//test words
    
    //user say nothing -> equal to before
    if(inputResults == ""){
        return (12,testResults)
    }
    
    for i in inputResults.characters{
        re1Arr.append(String(i))
    }
    for i in testResults.characters{
        re2Arr.append(String(i))
    }
    
    let commonWords = re1Arr.filter(re2Arr.contains)
    for a in re2Arr{
        if(!commonWords.contains(a)){
            filterWords += a
        }
    }
    return (filterWords.count , filterWords)
}



//show training contents(start from num1)
public func contents(str : String, num : Int, textView: UITextView, recordButton : UIButton){
    textView.isHidden = false
    recordButton.isHidden = false
    let fontSize = ModelData.shared.fontSize
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
    textView.text = str
}


public func hideContents(textView : UITextView, recordButton : UIButton){
    textView.isHidden = true
    recordButton.isHidden = false
}



public func showContents(leftContents: [String], times : Int, textView: UITextView, recordButton: UIButton) -> String{
    let numCount = leftContents.count
    let arrayKey = Int(arc4random_uniform(UInt32(numCount))) //random cases
    let chooseContent = leftContents[arrayKey]
    contents(str: chooseContent, num: times, textView: textView, recordButton: recordButton)
    return chooseContent
}

//------------------------------------------------------------------------------------------------least square

func average(_ input: [Double]) -> Double {
    return input.reduce(0, +) / Double(input.count)
}

func multiply(_ a: [Double], _ b: [Double]) -> [Double] {
    return zip(a,b).map(*)
}

func linearRegression(_ xs: [Double], _ ys: [Double], midIndex : Int, theta :Double) -> Double {
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

//------------------------------------------------------------------------------------------------

// d//m/yyyy <-> yyyy/m/d 便于排序
func change_Date(date: String, change: Bool) -> String{
    if change{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d/m/yyyy"// yyyy-MM-dd"
    let new_dateFormatter = DateFormatter()
    new_dateFormatter.dateFormat = "yyyy/m/d"// yyyy-MM-dd"
    let date_1 = dateFormatter.date(from: date)//只需显示日期
    let new_date = new_dateFormatter.string(from: date_1!)
        return new_date}
    else{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/m/d"
        let new_dateFormatter = DateFormatter()
        new_dateFormatter.dateFormat = "d/m/yyyy"
        let date_1 = dateFormatter.date(from: date)
        let new_date = new_dateFormatter.string(from: date_1!)
        return new_date
    }
    
    }


