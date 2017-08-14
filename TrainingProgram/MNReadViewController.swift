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
    let fontRow = ["黑色","黃色","紅色","白色"]
    let backRow =  ["白色","藍色","綠色","黑色"]
    let distanceRow = ["40cm", "33cm", "25cm"]
    var selectedFont = "黑色"
    var selectedBack = "白色"
    var selectedDistance = "40cm"

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fontColor.dataSource = self
        self.fontColor.delegate = self
        self.backColor.dataSource = self
        self.backColor.delegate = self
        self.watchDistance.dataSource = self
        self.watchDistance.delegate = self
        

        
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
        else {return 0}
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView == fontColor) {return fontRow[row]}
        if(pickerView == watchDistance) {return distanceRow[row]}
        if(pickerView == backColor) {return backRow[row]}
        else {return "unsuccessful"}
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView == fontColor){
        selectedFont = fontRow[row] as String}
        
        if(pickerView == watchDistance){
        selectedDistance = distanceRow[row] as String}
        
        if(pickerView == backColor){
        selectedBack = backRow[row] as String}
        
    }
    
    }
    
