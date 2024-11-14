//
//  Utils.swift
//  Upstox-Assignment
//
//  Created by Vinod Kumar Singh on 09/11/24.
//

import Foundation

struct Utils {
    static func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "₹"
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: value)) ?? "₹0.00"
    }
}
