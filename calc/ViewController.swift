//
//  ViewController.swift
//  calc
//
//  Created by Владислав Близнюк on 19.08.2025.
//

import UIKit

class ViewController: UIViewController {
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        guard let buttonText = sender.titleLabel?.text else { return }
        
        print(buttonText)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("та дам")
    }


}

