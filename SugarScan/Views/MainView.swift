//
//  MainView.swift
//  SugarScan
//
//  Created by Nathanael Abel on 02/05/24.
//

import SwiftUI

struct MainView: View {
    @State var sugarIntake: Float = 0.0
    var sugarLimit: Int
    
    var body: some View {
        VStack {
            Text("Today")
                .font(.largeTitle)
                .padding()
            
            CircularProgressBar(progress: sugarIntake, total: Double(sugarLimit))
                .frame(width: 200, height: 200) // Adjust size as needed
                .padding()
            
            Button(action: {
                sugarIntake += 5.0 // Dummy example, increase by 5g
            }) {
                Text("Add Sugar")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(sugarLimit: 36) // Sample sugar limit for preview
    }
}


