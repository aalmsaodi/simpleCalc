//
//  ViewController.swift
//  calculator
//
//  Created by user on 7/8/16.
//  Copyright © 2016 user. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    enum Operation: String{
        case Divid = "/"
        case Multiply = "*"
        case Subtract = "-"
        case Add = "+"
        case Squar = "^"
        case Empty = "Empty"
    }
    
    @IBOutlet weak var outPutLabel: UILabel!
    
    var btnSound: AVAudioPlayer!
    
    var runningnumber = ""
    var rightStr = ""
    var leftStr = ""
    var currentOperation: Operation = Operation.Empty
    var results = "0.0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = NSBundle.mainBundle().pathForResource("btn", ofType: "wav")
        let soundURL = NSURL(fileURLWithPath: path!)
        
        do{
            try btnSound = AVAudioPlayer(contentsOfURL: soundURL)
            btnSound.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    @IBAction func numPressed(btn: UIButton!){
        playSound()
        
        runningnumber += "\(btn.tag)"
        outPutLabel.text = runningnumber
    }

    @IBAction func onDotPressed(sender: AnyObject) {
        if !runningnumber.containsString(".") {
            runningnumber += "."
            outPutLabel.text = runningnumber
        }
    }

    @IBAction func onPlusPressed(sender: AnyObject) {
        processOperation(Operation.Add)
    }

    
    @IBAction func onMinusPressed(sender: AnyObject) {
        processOperation(Operation.Subtract)
    }
    
    @IBAction func onMultiPressed(sender: AnyObject) {
        processOperation(Operation.Multiply)
    }
    
    @IBAction func onDividPressed(sender: AnyObject) {
        processOperation(Operation.Divid)
    }
    
    @IBAction func onSquarPressed(sender: AnyObject) {
        processOperation(Operation.Squar)
    }
    
    @IBAction func onEqualPressed(sender: AnyObject) {
        processOperation(currentOperation)
    }
    
    @IBAction func onClearPressed(sender: AnyObject) {
        
        runningnumber = ""
        rightStr = ""
        leftStr = ""
        outPutLabel.text = "0.0"
        results = "0.0"
        currentOperation = Operation.Empty
    }
    
    func processOperation(op: Operation){
        playSound()
        
        if currentOperation != Operation.Empty{
            
            // Not doing any oppuration unless there is a right side number entered
            if runningnumber != "" {
                rightStr = runningnumber
                runningnumber = ""
                
                if currentOperation == Operation.Multiply{
                    results = "\(Double(leftStr)! * Double(rightStr)!)"
                } else if currentOperation == Operation.Divid{
                    results = "\(Double(leftStr)! / Double(rightStr)!)"
                } else if currentOperation == Operation.Subtract{
                    results = "\(Double(leftStr)! - Double(rightStr)!)"
                    
                } else if currentOperation == Operation.Add{
                    results = "\(Double(leftStr)! + Double(rightStr)!)"
                    
                }
                
                currentOperation = op
                
            // If no right value entered, update the operation. If the operator pressed is
            // square, then calculate the square
            } else {
                currentOperation = op
                if currentOperation == Operation.Squar && leftStr != "" && Double(leftStr) != 0{
                    results = "\(Double(leftStr)! * Double(leftStr)!)"
                    
                }
            }
            
            leftStr = results
            outPutLabel.text = results
            
        }else {
            leftStr = runningnumber
            runningnumber = ""
            currentOperation = op
            
            if currentOperation == Operation.Squar && leftStr != "" && Double(leftStr) != 0 {
                results = "\(Double(leftStr)! * Double(leftStr)!)"
                leftStr = results
                outPutLabel.text = results
            }
        }
        
    }
    
    func playSound(){
        if btnSound.playing{
            btnSound.stop()
        }
        
        btnSound.play()
    }
}

