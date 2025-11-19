//
//  ViewController.swift
//  Calc
//
//  Created by user277759 on 11/6/25.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var CalculatorWorkings: UILabel!
    @IBOutlet weak var CalculatorResults: UILabel!
    
    var workings: String = ""
    var prevNumber: Double = 0.0
    var currNumber: Double = 0.0
    var oper: String = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        clearall()
        
    }
    
    func clearall(){
        workings = ""
        prevNumber = 0.0
        currNumber = 0.0
        oper = ""
        CalculatorWorkings.text = ""
        CalculatorResults.text = ""
    }
    
    func formatNumber(_ number: Double) -> String {
        if number.truncatingRemainder(dividingBy: 1) == 0 {
            return String(Int(number))
        } else {
            return String(number)
        }
    }

    
    func operPerform(){
        switch oper {
        case "/":
            if currNumber != 0{
                prevNumber /= currNumber
            }
            else
            {
                clearall()
                CalculatorResults.text = "Err"
                return
            }
        case "*":
            prevNumber *= currNumber
        case "-":
            prevNumber -= currNumber
        case "+":
            prevNumber += currNumber
        default:
            break
        }
        
        currNumber = prevNumber
        
        CalculatorResults.text = formatNumber(currNumber)
        
    }
    
    func OperHandler(newOper: String){
        
        if !workings.isEmpty{
            currNumber = Double(workings) ?? 0.0
            workings = ""
        }
        
        if oper.isEmpty{
            prevNumber = currNumber
        }
        else
        {
            operPerform()
        }
        
        oper = newOper
    }

    @IBAction func AllClearTap(_ sender: Any) {
        clearall()
    }
    

    
    @IBAction func signChangeTap(_ sender: Any) {
        if (!workings.isEmpty){
            var number = Double(workings) ?? 0.0
            number *= -1
            workings = formatNumber(number)
            CalculatorResults.text = workings
        }
        else{
            currNumber *= -1
            CalculatorResults.text = formatNumber(currNumber)
        }
    }
    
    
    @IBAction func LogTap(_ sender: Any) {
        if(!workings.isEmpty){
            currNumber = Double(workings) ?? 0.0
            workings = ""
        }
        
        if currNumber != 0.0{
            currNumber = log10(currNumber)
            CalculatorResults.text = formatNumber(currNumber)
        }
    }
    
    @IBAction func SquareTap(_ sender: Any) {
        if(!workings.isEmpty){
            currNumber = Double(workings) ?? 0.0
            workings = ""
        }
        
        if currNumber != 0.0 {
            currNumber = pow(currNumber,2)
            CalculatorResults.text = formatNumber(currNumber)
        }
    }
    
    
    @IBAction func PercentTap(_ sender: Any) {
        if (!workings.isEmpty)
        {
            currNumber = Double(workings) ?? 0.0
            currNumber *= 0.01
            workings = ""
            CalculatorResults.text = String(currNumber)
        }
        else if(currNumber != 0.0){
            currNumber *= 0.01
            CalculatorResults.text = String(currNumber)
        }
    }
    
    @IBAction func DivideTap(_ sender: Any) {
        OperHandler(newOper: "/")
    }
    
    @IBAction func SevenTap(_ sender: Any) {
        if workings == "0" {
            workings = "7"
        } else {
            workings += "7"
        }
        CalculatorResults.text = workings
    }
    
    
    @IBAction func EightTap(_ sender: Any) {
        if workings == "0" {
            workings = "8"
        } else {
            workings += "8"
        }
        CalculatorResults.text = workings
    }
    
    
    @IBAction func NineTap(_ sender: Any) {
        if workings == "0" {
            workings = "9"
        } else {
            workings += "9"
        }
        CalculatorResults.text = workings
    }
    
    
    @IBAction func MultiplyTap(_ sender: Any) {
        OperHandler(newOper: "*")
    }
    
    
    @IBAction func FourTap(_ sender: Any) {
        if workings == "0" {
            workings = "4"
        } else {
            workings += "4"
        }
        CalculatorResults.text = workings
    }
    
    
    @IBAction func FiveTap(_ sender: Any) {
        if workings == "0" {
            workings = "5"
        } else {
            workings += "5"
        }
        CalculatorResults.text = workings
    }
    
    
    @IBAction func SixTap(_ sender: Any) {
        if workings == "0" {
            workings = "6"
        } else {
            workings += "6"
        }
        CalculatorResults.text = workings
    }
    
    
    @IBAction func MinusTap(_ sender: Any) {
        OperHandler(newOper: "-")
    }
    
    
    @IBAction func OneTap(_ sender: Any) {
        if workings == "0" {
            workings = "1"
        } else {
            workings += "1"
        }
        CalculatorResults.text = workings
    }
    
    
    @IBAction func TwoTAp(_ sender: Any) {
        if workings == "0" {
            workings = "2"
        } else {
            workings += "2"
        }
        CalculatorResults.text = workings
    }
    
    
    @IBAction func ThreeTap(_ sender: Any) {
        if workings == "0" {
            workings = "3"
        } else {
            workings += "3"
        }
        CalculatorResults.text = workings
    }
    
    
    @IBAction func PlusTap(_ sender: Any) {
        OperHandler(newOper: "+")
    }
    
    
    @IBAction func DotTap(_ sender: Any) {
        if (!workings.contains(".")){
            workings += "."
            CalculatorResults.text = workings
        }
    }
    
    
    @IBAction func ZeroTap(_ sender: Any) {
        if workings == "0" {
            workings = "0"
        } else {
            workings += "0"
        }
        CalculatorResults.text = workings

    }
    
    @IBAction func EqualsTap(_ sender: Any) {
        if (!workings.isEmpty){
            currNumber = Double(workings) ?? 0.0
            workings = ""
        }
        
        if oper.isEmpty{
            CalculatorResults.text = formatNumber(currNumber)
        }
        else
        {
            operPerform()
            oper = ""
            CalculatorResults.text = formatNumber(currNumber)
        }

    }
    
    
}

