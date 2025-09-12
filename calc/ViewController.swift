//
//  ViewController.swift
//  calc
//
//  Created by Владислав Близнюк on 19.08.2025.
//

import UIKit

enum CalculatorError: Error {
    case dividedByZero
}

enum Operation: String {
    case add = "+"
    case subtract = "-"
    case multiply = "X"
    case divide = "/"
    
    func calculate(_ a: Double, _ b: Double) throws -> Double {
        switch self {
        case .add:
            return a + b
        case .subtract:
            return a - b
        case .multiply:
            return a * b
        case .divide:
            if b == 0 {
                throw CalculatorError.dividedByZero
            }
            return a / b
        }
    }
}

enum CalculatorHistory {
    case number(Double)
    case operation(Operation)
}

class ViewController: UIViewController {
    
    var calculatorHistory: [CalculatorHistory] = []
    var calculations: [Calculation] = []
    
    let calculationHistoryStorage = CalculationHistoryStorage()
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        guard let buttonText = sender.titleLabel?.text else { return }
        
        if buttonText == "," && label.text?.contains(",") == true {
            return
        }
        
        if label.text == "0" {
            label.text = buttonText
        } else {
            label.text?.append(buttonText)
        }
    }
    
    @IBAction func operationbuttonPressed(_ sender: UIButton) {
        guard
            let buttonText = sender.titleLabel?.text,
            let buttonOperation = Operation(rawValue: buttonText)
        else { return }
        
        guard
            let labelText = label.text,
            let labelNumber = numberFormatter.number(from: labelText)?.doubleValue
        else {return}
        
        calculatorHistory.append(.number(labelNumber))
        calculatorHistory.append(.operation(buttonOperation))
        
        resetTextLabel()
    }
    
    @IBAction func clearbuttonPressed() {
        calculatorHistory.removeAll()
        
        resetTextLabel()
    }
    
    @IBAction func calculatebuttonPressed() {
        guard
            let labelText = label.text,
            let labelNumber = numberFormatter.number(from: labelText)?.doubleValue
        else {return}
        
        calculatorHistory.append(.number(labelNumber))
        do {
            let result = try calculate()
            
            label.text = numberFormatter.string(from: NSNumber(value: result))
            let newCalculation = Calculation(expressions: calculatorHistory, result: result)
            calculations.append(newCalculation)
            calculationHistoryStorage.setHistory(calculation: calculations)
            
        } catch {
            label.text = "Error"
        }
        
        calculatorHistory.removeAll()
    }
    
    //    @IBAction func unwindAction(unwindSegue: UIStoryboardSegue) {
    //    }
    
    @IBAction func storyBtnPressed(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let calculatorListVC = sb.instantiateViewController(withIdentifier: "CalculatorListVC")
        if let vc = calculatorListVC as? CalculationListViewController {
            vc.calculations = calculations
        }
        navigationController?.pushViewController(calculatorListVC, animated: true)
    }
   
    @IBOutlet weak var label: UILabel!
    
    
    
    lazy var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = false
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.numberStyle = .decimal
        
        return formatter
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        resetTextLabel()
        
        calculations = calculationHistoryStorage.loadHistory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func calculate() throws -> Double {
        guard case .number(let firstNumber) = calculatorHistory[0] else { return 0 }
        
        var currentResult = firstNumber
        
        for index in stride(from: 1, to: calculatorHistory.count - 1, by: 2) {
            guard
                case .operation(let operation) = calculatorHistory[index],
                case .number(let number) = calculatorHistory[index + 1]
            else { break }
            
            currentResult = try operation.calculate(currentResult, number)
        }
        
        
        return currentResult
    }
    
    func resetTextLabel() {
        label.text = "0"
    }
    
}
