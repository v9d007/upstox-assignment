//
//  ViewController.swift
//  Upstox-Assignment
//
//  Created by Vinod Kumar Singh on 09/11/24.
//

import UIKit

class Portfolio: UIViewController {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var portfolioTableView: UITableView!
    
    @IBOutlet weak var currentValueLabel: UILabel!
    @IBOutlet weak var totalInvestmentLabel: UILabel!
    @IBOutlet weak var todaysPNLLabel: UILabel!
    @IBOutlet weak var totalPNLLabel: UILabel!
    
    @IBOutlet weak var summaryView: UIView!
    @IBOutlet weak var pnlClickableView: UIView!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var summaryViewHeightConstraint: NSLayoutConstraint!
    
    private var holdings: [Holding] = []
    private var isExpanded: Bool = false
    
    private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
        setupActivityIndicator()
        fetchData()
    }
    
    private func initialSetup(){
        summaryView.isHidden = true
        pnlClickableView.isHidden = true
        summaryView.layer.cornerRadius = 12
        summaryView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        // Register the table view cell nib
        let nib = UINib(nibName: "PortfolioTVCell", bundle: nil)
        portfolioTableView.register(nib, forCellReuseIdentifier: "PortfolioTVCell")
        
        // Add tap gesture to pnlClickableView
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSummaryViewToggle))
        pnlClickableView.addGestureRecognizer(tapGesture)
    }
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func handleSummaryViewToggle() {
        isExpanded.toggle()
        UIView.animate(withDuration: 1) { [weak self] in
            guard let self = self else { return }
            if self.isExpanded {
                self.summaryViewHeightConstraint.constant = 151
                self.arrowImageView.transform = CGAffineTransform(rotationAngle: .pi)
            } else {
                self.summaryViewHeightConstraint.constant = 4
                self.arrowImageView.transform = CGAffineTransform.identity
            }
            self.view.layoutIfNeeded()
        }
    }
    
    private func fetchData(){
        activityIndicator.startAnimating()
        NetworkManager.shared.fetchHoldings{ [weak self] result in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                switch result{
                case .success(let data):
                    self?.summaryView.isHidden = false
                    self?.pnlClickableView.isHidden = false
                    self?.holdings = data
                    self?.updatePortfolioSummary()
                    self?.portfolioTableView.reloadData()
                    
                case .failure(let error):
                    print("Failed to fetch data: \(error)")
                }
            }
        }
    }
    
    private func updatePortfolioSummary(){
        let currentValue = holdings.reduce(into: 0.0) { result, holding in
            result += holding.ltp * Double(holding.quantity)
        }
        
        let totalInvestment = holdings.reduce(into: 0.0) { result, holding in
            result += holding.avgPrice * Double(holding.quantity)
        }
         
        let totalPNL = currentValue - totalInvestment
        let percentPNL = String(format: "%.2f", abs((totalPNL / currentValue) * 100))
        
        let todaysPNL = holdings.reduce(into: 0.0) { result, holding in
            result += (holding.close - holding.ltp) * Double(holding.quantity)
        }
        
        currentValueLabel.text = Utils.formatCurrency(currentValue)
        totalInvestmentLabel.text = Utils.formatCurrency(totalInvestment)
        todaysPNLLabel.text = Utils.formatCurrency(todaysPNL)
        totalPNLLabel.text = "\(Utils.formatCurrency(totalPNL)) (\(percentPNL)%)"
        
        todaysPNLLabel.textColor = todaysPNL >= 0 ? .systemGreen : .systemRed
        totalPNLLabel.textColor = totalPNL >= 0 ? .systemGreen : .systemRed
    }
    
    
}

extension Portfolio: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return holdings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PortfolioTVCell", for: indexPath) as? PortfolioTVCell else {
            return UITableViewCell()
        }
        
        cell.populateData(with: holdings[indexPath.row])
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 91
    }
    
    
}

