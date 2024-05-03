//
//  ReusableButton.swift
//  SugarScan
//
//  Created by Nathanael Abel on 29/04/24.
//

import SwiftUI

struct ReusableButton: View {
    var title: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(20)
        }
    }
}

struct ReusableButton_Previews: PreviewProvider {
    static var previews: some View {
        ReusableButton(title: "Scan", action: {})
    }
}
