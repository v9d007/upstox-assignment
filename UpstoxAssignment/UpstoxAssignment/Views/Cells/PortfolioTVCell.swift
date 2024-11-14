//
//  PortfolioTVCell.swift
//  Upstox-Assignment
//
//  Created by Vinod Kumar Singh on 09/11/24.
//

import UIKit

class PortfolioTVCell: UITableViewCell {

    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var ltpLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var pnlLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populateData(with holding: Holding) {
            symbolLabel.text = "\(holding.symbol)"
            quantityLabel.text = "\(holding.quantity)"
            ltpLabel.text = Utils.formatCurrency(holding.ltp)
            pnlLabel.text = Utils.formatCurrency(holding.close)
            pnlLabel.textColor = holding.close >= 0 ? .systemGreen : .systemRed
        }
    
}
