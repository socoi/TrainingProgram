//
//  uploadData.swift
//  TrainingProgram
//
//  Created by MAC User on 2/10/2018.
//  Copyright © 2018 Zhao Ruohan. All rights reserved.
//

import Foundation

func dataUploadRequest(x_value : [Double], y_value : [Double], userName: String, userID : String, completionHandler: @escaping (String) ->())
{
    let semaphore = DispatchSemaphore(value: 0)
    var x = Array<Double>()
    var y = Array<Double>()
    
    // xValue: min -> 1.5 , yVlaue: 0 -> value
    // 需要去除y 中可能有的0(如果19个测试都通过则没有)与相应的x

//    if y_value.contains(0) && y_value.count > 1{
//        x = Array(x_value[1...x_value.count - 1])
//        y = Array(y_value[1...y_value.count - 1])
//    if y.contains(0) || x.count != y.count{
//        print(" error, x_array and y_array have different length")
//        }
//    }
    
    x = Array(x_value)
    y = Array(y_value)
    
    // http request
    
    let url = URL(string: "http://120.31.136.53/curve_fit.php")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    //request.setValue("application/json", forHTTPHeaderField: "Content-type")
    var postString = "userName=\(userName)&userID=\(userID)"
    
    for (index, value) in x.enumerated(){
        postString += "&xValue\(index)=\(value)"
    }
    
    for (index, value) in y.enumerated(){
        postString += "&yValue\(index)=\(value)"
    }
    
    request.httpBody = postString.data(using: .utf8)
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else {
            print("request failed \(error)")
            return
        }
        
        let string = String(data: data, encoding: String.Encoding.utf8)
        print(string) //JSONSerialization
        print("response = \(response)")
        
        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
            print("statusCode should be 200, but is \(httpStatus.statusCode)")
            print("response = \(response)")
        }
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: String], let returnValue = json["curve_data"] {
                print("output = \(returnValue)")
                 //result there
                //three values(delta1,2,3)
                completionHandler(returnValue) //task句柄的返回
            }
            semaphore.signal()
        } catch let parseError {
            print("response: \(response)")
            print("parsing error: \(parseError)")
        }
        
    }
    task.resume()
    _ = semaphore.wait(timeout: DispatchTime.distantFuture)

}

