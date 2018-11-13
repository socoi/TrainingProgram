//
//  ViewController.swift
//  TrainingProgram
//
//  Created by socoi on 17/2/8.
//  Copyright © 2017年 Zhao Ruohan. All rights reserved.
//

import Foundation
import UIKit

class MNReadViewController : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var fontColor: UIPickerView!
    @IBOutlet weak var backColor: UIPickerView!
    @IBOutlet weak var watchDistance: UIPickerView!
    @IBOutlet weak var testLanguage: UIPickerView!
    @IBOutlet weak var testMode: UIPickerView!
    @IBOutlet weak var testNumber: UIPickerView!

    
    let fontRow = ["黑色","黃色","紅色","白色"]
    let backRow =  ["白色","藍色","綠色","黑色"]
    let distanceRow = ["40cm", "33cm", "25cm", "20cm", "16cm", "13cm"]
    let languageRow = ["廣東話", "國語"]
    let testRow = ["手動","自動"]
    let testNumRow = ["1"]
    
    var selectedFont = "黑色"
    var selectedBack = "白色"
    var selectedDistance = "40cm"
    var selectedLanguage = "廣東話"
    var selectedTest = "手動"
    var selectedNum = "1"

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fontColor.dataSource = self
        self.fontColor.delegate = self
        self.backColor.dataSource = self
        self.backColor.delegate = self
        self.watchDistance.dataSource = self
        self.watchDistance.delegate = self
        self.testLanguage.dataSource = self
        self.testLanguage.delegate = self
        self.testMode.dataSource = self
        self.testMode.delegate = self
        self.testNumber.delegate = self
        self.testNumber.dataSource = self
        
        //testLanguage.selectRow(0, inComponent: 0, animated: false)
        //testMode.selectRow(0, inComponent: 0, animated: false)

        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(MNReadViewController.imageTapped(gesture:)))
        
        // add it to the image view;
        imageView.addGestureRecognizer(tapGesture)
        // make sure imageView can be interacted with by user
        imageView.isUserInteractionEnabled = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "MNReadTest"{
            let vc = segue.destination as! Test1
            vc.fontColor = self.selectedFont
            vc.backColor = self.selectedBack
            vc.watchDistance = self.selectedDistance
            vc.testLanguage = self.selectedLanguage
            vc.testMode = self.selectedTest
            vc.mnread_num = Int(self.selectedNum)!
        }        }
        
    
    func imageTapped(gesture: UIGestureRecognizer) {
        // if the tapped view is a UIImageView then set it to imageview
        if (gesture.view as? UIImageView) != nil {
            self.performSegue(withIdentifier: "MNReadTest", sender: self)
            
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == fontColor) {return fontRow.count}
        if(pickerView == watchDistance) {return distanceRow.count}
        if(pickerView == backColor) {return backRow.count}
        if(pickerView == testLanguage) {return languageRow.count}
        if(pickerView == testMode){return testRow.count}
        if(pickerView == testNumber){return testNumRow.count}
        else {return 0}
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView == fontColor) {return fontRow[row]}
        if(pickerView == watchDistance) {return distanceRow[row]}
        if(pickerView == backColor) {return backRow[row]}
        if(pickerView == testLanguage) {return languageRow[row]}
        if(pickerView == testMode){return testRow[row]}
        if(pickerView == testNumber){return testNumRow[row]}
        else {return "unsuccessful"}
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView == fontColor){
        selectedFont = fontRow[row] as String}
        
        if(pickerView == watchDistance){
        selectedDistance = distanceRow[row] as String}
        
        if(pickerView == backColor){
        selectedBack = backRow[row] as String}
        
        if(pickerView == testLanguage){
        selectedLanguage = languageRow[row] as String}
        
        if(pickerView == testMode){
        selectedTest = testRow[row] as String
        }
        
        if(pickerView == testNumber){
        selectedNum = testNumRow[row] as String
        }
        
    }
    
    }
    
