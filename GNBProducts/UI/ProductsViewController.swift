//
//  ProductsViewController.swift
//  GNBProducts
//
//  Created by Joaquín Corugedo Rodríguez on 29/1/23.
//

import UIKit
import Combine

class ProductsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var lblTotal: UILabel!
    
    private var viewModel = ProductsViewModel()
    private var suscriptor = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        pickerView.delegate = self
        pickerView.dataSource = self

        //registrar la celda
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        responseViewModel()
        

        viewModel.getRates()
    }
    
    private func responseViewModel() {
        
        viewModel.$allProductsLoaded
            .sink { _ in
                DispatchQueue.main.async {
                    self.pickerView.reloadComponent(0)
                }
            }
            .store(in: &suscriptor)
        
        viewModel.$filteredTransactions
            .sink { _ in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            .store(in: &suscriptor)
        
        viewModel.$totalAmount
            .sink { total in
                self.lblTotal.text = "Total: \(total) €"
            }
            .store(in: &suscriptor)
    }


}

//MARK: - TableView Delegates

extension ProductsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredTransactions.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        var content = cell.defaultContentConfiguration()
        let transaction = viewModel.filteredTransactions[indexPath.row]
        content.text = String(describing: transaction.amount )
        content.secondaryText = transaction.currency
        cell.contentConfiguration = content

        return cell
    }
    
    
}

//MARK: - Picker View Delegates

extension ProductsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        return viewModel.products.count + 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let arrayProducts = Array(viewModel.products)
        
        if row == 0 {
            return "Select product"
        } else {
            return arrayProducts[row - 1]
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            viewModel.filterTransactionsByProduct(product: "")
        } else {
            let selectedProduct = Array(viewModel.products)[row - 1]
            viewModel.filterTransactionsByProduct(product: selectedProduct)
        }

    }
}
