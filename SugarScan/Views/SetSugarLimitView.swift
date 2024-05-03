//
//  SetSugarLimitView.swift
//  SugarScan
//
//  Created by Nathanael Abel on 02/05/24.
//

import SwiftUI

struct SetSugarLimitView: View {
    @Binding var sugarLimit: Int
    @State private var customLimit = ""
    @State private var showAlert = false
    @State private var navigateToMain = false
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text("Set Sugar Limit")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                VStack {
                    TextField("Enter sugar limit (g)", text: $customLimit)
                        .keyboardType(.numberPad)
                        .padding()
                }
                .background(Color.white)
                .cornerRadius(10)
                .padding()
                
                Text("It is advised that you seek the advice of a qualifed healthcare provider before chaging your diet.")
                    .padding(.horizontal)
                
                Button(action: {
                    if let limit = Int(customLimit), limit > 0 {
                        sugarLimit = limit
                        navigateToMain = true  // Trigger navigation when input is valid
                    } else {
                        showAlert = true  // Show alert if the input is invalid
                    }
                }) {
                    Text("Set")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Invalid Input"), message: Text("Please enter a valid sugar limit."), dismissButton: .default(Text("OK")))
                }
                NavigationLink(destination: MainView(sugarLimit: sugarLimit), isActive: $navigateToMain) {
                    EmptyView()
                }
                Spacer()
            }
            .background(Color(hex: "F5F5F5"))
        }
    }
}

struct SetSugarLimitView_Previews: PreviewProvider {
    @State static var sugarLimit = 36
    
    static var previews: some View {
        SetSugarLimitView(sugarLimit: $sugarLimit)
    }
}
