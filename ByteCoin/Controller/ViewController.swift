//
//  ViewController.swift
//  ByteCoin
//
//  Created by Prince Alvin Yusuf on 22/02/2021.
//  Copyright © 2021 Prince Alvin Yusuf. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        
        coinManager.delegate = self
    }


}

//MARK: - UIPickerDataSource and Delegate

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        coinManager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinManager.currencyArray[row]
        currencyLabel.text = selectedCurrency
        coinManager.getCoinPrice(for: selectedCurrency)
    }
}

//MARK: - CoinManagerDelegate

extension ViewController: CoinManagerDelegate {
    func didUpdateCoin(_ coinManager: CoinManager, coinData: CoinModel) {
        DispatchQueue.main.async {
            self.bitcoinLabel.text = String(format: "%.2f", coinData.rate)
        }
    }
    
    func didFailWithError(_ coinManager: CoinManager, error: Error) {
        print(error.localizedDescription)
    }
    
    
    
}

