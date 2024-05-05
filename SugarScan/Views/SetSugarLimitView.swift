//
//  SetSugarLimitView.swift
//  SugarScan
//
//  Created by Nathanael Abel on 02/05/24.
//

import SwiftUI

struct SetSugarLimitView: View {
    @Binding var sugarLimit: Int
    @State private var customLimit: String = ""
    @State private var showAlert = false
    var navigateBack: () -> Void
    
    init(sugarLimit: Binding<Int>, navigateBack: @escaping () -> Void) {
        self._sugarLimit = sugarLimit
        self.navigateBack = navigateBack
        self._customLimit = State(initialValue: String(sugarLimit.wrappedValue))
    }
    
    var body: some View {
        VStack {
            Spacer()
            Text("Set Sugar Limit")
                .font(.largeTitle)
                .bold()
                .padding()
            
            TextField("Enter sugar limit (g)", text: $customLimit)
                .keyboardType(.numberPad)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .padding()
            
            Text("It is advised that you seek the advice of a qualified healthcare provider before changing your diet.")
                .padding(.horizontal)
            
            Button(action: {
                if let limit = Int(customLimit), limit > 0 {
                    sugarLimit = limit
                    navigateBack()
                } else {
                    showAlert = true
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
            
            Spacer()
        }
        .background(Color(hex: "F5F5F5"))
    }
}

struct SetSugarLimitView_Previews: PreviewProvider {
    static var previews: some View {
        SetSugarLimitView(sugarLimit: .constant(36), navigateBack: { })
    }
}
