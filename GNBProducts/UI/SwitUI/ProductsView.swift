//
//  ProductsView.swift
//  GNBProducts
//
//  Created by Joaquín Corugedo Rodríguez on 1/2/23.
//

import SwiftUI

struct ProductsView: View {
    
    //    @StateObject var viewModel: ProductsViewModel
    var colors = ["Red", "Green", "Blue", "Tartan"]
    
    let transactions = [
        Transaction(sku: "EUR", amount: 1.056789, currency: "CAD"),
        Transaction(sku: "EUR", amount: 1.06785, currency: "CAD")]
    
    @State var selection = "Select a product"
    
    var body: some View {
        VStack{
            
            Text("GNB Products")
                .padding(.top, 20)
            
            HStack{
                Text("Select a product:")
                
                Picker("Select a product", selection: $selection) {
                    ForEach(colors, id: \.self) {
                        Text($0)
                    }
                }
            }
            
            List{
                HStack{
                    Text("Amount")
                        .font(.headline)
                    Spacer()
                    Text("Currency")
                        .font(.headline)
                }
                
                ForEach(transactions) { transaction in
                    
                    HStack{
                        Text(String(describing: transaction.amount) )
                        Spacer()
                        Text(transaction.sku)
                    }
                    
                }
            }
            
            Spacer()
            
            Text("Total: 0€")
                .padding(.bottom,10)
        }
    }
}

struct ProductsView_Previews: PreviewProvider {
    static var previews: some View {
        ProductsView()
    }
}
