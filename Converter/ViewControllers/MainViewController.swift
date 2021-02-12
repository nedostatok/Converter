//
//  MainViewController.swift
//  Converter
//
//  Created by User on 25.01.2021.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var toCurrencyLabel: UILabel!
    @IBOutlet weak var resultTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var fromCurrencyLabel: UILabel!
    @IBOutlet weak var fromTableView: UITableView!
    @IBOutlet weak var toTableView: UITableView!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var gradientView: UIView!
    
    var currency = [Currency]() {
        didSet{
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.fromTableView.reloadData()
                self.toTableView.reloadData()
            }
        }
    }
    
    var rate = Double() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                guard let text = self.amountTextField.text, let doubleValue = Double(text) else { return }
                let result = self.rate * doubleValue
                self.resultTextField.text = String(result)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        customizeButton()
        createGradient()
    }
    
    func createGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.purple.cgColor, UIColor.yellow.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = view.bounds
        gradientView.layer.addSublayer(gradientLayer)
    }
    
    func customizeButton() {
        changeButton.layer.cornerRadius = 15
        changeButton.backgroundColor = .cyan
        changeButton.layer.borderWidth = 1
        changeButton.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    func fetchData() {
        NetworkService.shared.loadCurrency { response in
            switch response {
            case let .success(currency):
                self.currency = currency
            case let .failure(error):
                print(error)
            }
        }
    }
    
    @IBAction func changeAction(_ sender: UIButton) {
        guard let fromCurr = fromCurrencyLabel.text, let toCurr = toCurrencyLabel.text else { return }
        getRate(from: fromCurr, to: toCurr)
    }
    
    func getRate(from: String, to: String) {
        
        NetworkService.shared.loadExchangeRate(from: from, to: to) { response in
            switch response {
            case let .success(rate):
                self.rate = rate.result
            case let .failure(error):
                print(error)
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension MainViewController: UITableViewDelegate{}
extension MainViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currency.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var returnedCell = UITableViewCell()
        let currency = self.currency[indexPath.row]
        
        if tableView == fromTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "fromCurrencyCell", for: indexPath) as? CurrencyTableViewCell  else { return UITableViewCell() }
            
            cell.currencyLabel.text = currency.id
            returnedCell = cell
            
        } else if tableView == toTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "toCurrencyCell", for: indexPath) as? CountedTableViewCell  else { return UITableViewCell() }
            
            cell.currencyLabel.text = currency.id
            returnedCell = cell
            
        }
        return returnedCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == fromTableView {
            let selected = currency[indexPath.row]
            fromCurrencyLabel.text = selected.id
        } else if tableView == toTableView {
            let selected = currency[indexPath.row]
            toCurrencyLabel.text = selected.id
        }
    }
}

