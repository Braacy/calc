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
        } catch {
            label.text = "Error"
        }
        calculatorHistory.removeAll()
    }
    
    @IBAction func unwindAction(unwindSegue: UIStoryboardSegue) {
    }
    
    @IBAction func storyBtnPressed(_ sender: Any) {
         let sb = UIStoryboard(name: "Main", bundle: nil)
        let calculatorListVC = sb.instantiateViewController(withIdentifier: "CalculatorListVC")
        if let vc = calculatorListVC as? CalculationListViewController {
            vc.result = label.text
        }
        
        show(calculatorListVC, sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "CALCULATION_LIST",
        let calculatorListVC = segue.destination as? CalculationListViewController else
        { return }
        calculatorListVC.result = label.text
    }
    
    @IBOutlet weak var label: UILabel!
    
    var calculatorHistory: [CalculatorHistory] = []
    
    lazy var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = false
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.numberStyle = .decimal
        
        return formatter
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
     resetTextLabel()
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

