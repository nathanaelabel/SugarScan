//
//  AddSugarView.swift
//  SugarScan
//
//  Created by Nathanael Abel on 30/04/24.
//

import SwiftUI

struct AddSugarView: View {
    @ObservedObject var viewModel: ScanViewModel
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Product Name", text: $viewModel.productName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                TextField("Servings per package", value: $viewModel.servingsPerPackage, formatter: NumberFormatter())
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .addDoneButton(onDone: {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    })
                
                TextField("Sugar amount (g)", value: $viewModel.sugarAmount, formatter: NumberFormatter())
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .addDoneButton(onDone: {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    })
                
                Button(action: addSugar) {
                    Text("Add")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Input Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                .padding()
            }
            .navigationBarTitle("Add Sugar", displayMode: .inline)
        }
    }
    
    func addSugar() {
        guard let servings = viewModel.servingsPerPackage, let sugar = viewModel.sugarAmount, !viewModel.productName.isEmpty else {
            alertMessage = "Please ensure all fields are complete and valid."
            showingAlert = true
            return
        }
        viewModel.confirmData()
        if viewModel.isDataReady {
            // Later in here will be a handle navigation or close this view as needed.
        }
    }
}

extension View {
    func addDoneButton(onDone: @escaping () -> Void) -> some View {
        self.toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done", action: onDone)
            }
        }
    }
}

struct AddSugarView_Previews: PreviewProvider {
    static var previews: some View {
        AddSugarView(viewModel: ScanViewModel())
    }
}
