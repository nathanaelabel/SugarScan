//
//  AddSugarView.swift
//  SugarScan
//
//  Created by Nathanael Abel on 30/04/24.
//

import SwiftUI

struct AddSugarView: View {
    @ObservedObject var viewModel: ScanViewModel
    var updateSugarLimit: (Int) -> Void
    var navigateToMainView: () -> Void
    
    @State private var servingsInput: String = ""
    @State private var sugarInput: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    init(viewModel: ScanViewModel, updateSugarLimit: @escaping (Int) -> Void, navigateToMainView: @escaping () -> Void) {
        self.viewModel = viewModel
        self.updateSugarLimit = updateSugarLimit
        self.navigateToMainView = navigateToMainView
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Product Details")) {
                    VStack(alignment: .leading) {
                        Text("Product Name")
                            .bold()
                        TextField("Enter product name", text: $viewModel.productName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    VStack(alignment: .leading) {
                        Text("Servings per Package")
                            .bold()
                        TextField("Enter servings per package", text: $servingsInput)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    VStack(alignment: .leading) {
                        Text("Sugar Amount (g)")
                            .bold()
                        TextField("Enter sugar amount in grams", text: $sugarInput)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
                
                Button(action: addSugar) {
                    Text("Add Sugar")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Input Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
            .navigationBarTitle("Scan Product", displayMode: .inline)
        }
    }
    
    private func addSugar() {
        print("Attempting to add sugar...")
        guard !viewModel.productName.isEmpty,
              let servings = Double(servingsInput), servings > 0,
              let sugar = Double(sugarInput), sugar > 0 else {
            alertMessage = "Please ensure all fields are complete and valid."
            showingAlert = true
            print("Validation failed.")
            return
        }
        let totalSugar = Int(sugar * servings)
        print("Calculated total sugar: \(totalSugar)")
        updateSugarLimit(totalSugar)
        navigateToMainView()
    }
}

struct AddSugarView_Previews: PreviewProvider {
    static var previews: some View {
        AddSugarView(viewModel: ScanViewModel(), updateSugarLimit: { _ in }, navigateToMainView: { })
    }
}
