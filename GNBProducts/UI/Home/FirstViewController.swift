//
//  FirstViewController.swift
//  GNBProducts
//
//  Created by Joaquín Corugedo Rodríguez on 1/2/23.
//

import UIKit
import SwiftUI

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func goUiKit(_ sender: Any) {
        let vc = ProductsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func goSwiftUI(_ sender: Any) {
        let switUIVC = UIHostingController(rootView: ProductsView())
        self.navigationController?.pushViewController(switUIVC, animated: true)
    }
}
