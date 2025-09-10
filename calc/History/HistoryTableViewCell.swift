//
//  HistoryTableViewCell.swift
//  calc
//
//  Created by Владислав Близнюк on 10.09.2025.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
  @IBOutlet private weak var expressionLabel: UILabel!
  @IBOutlet private weak var resultLabel: UILabel!
    
    func configure(with expression: String, result: String) {
        expressionLabel.text = expression
        resultLabel.text = result
    }
}
