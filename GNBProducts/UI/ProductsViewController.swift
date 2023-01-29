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
    
    @IBOutlet weak var lblTotal: UILabel!
    
    private var viewModel = ProductsViewModel()
    private var suscriptor = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        //registrar la celda
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        responseViewModel()
        
        print("Llamando load Transactions")
        viewModel.loadTransactions()
    }
    
    private func responseViewModel() {
        
        viewModel.$products
            .sink { data in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            .store(in: &suscriptor)
    }


}

extension ProductsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.products.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        var content = cell.defaultContentConfiguration()
        let productsArray = Array(self.viewModel.products)
        content.text = productsArray[indexPath.row]
        cell.contentConfiguration = content

        return cell
    }
    
    
    
}
