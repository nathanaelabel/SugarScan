//
//  MainView.swift
//  SugarScan
//
//  Created by Nathanael Abel on 02/05/24.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var viewModel: ScanViewModel
    @State var sugarIntake: Float = 0.0
    @State var sugarLimit: Int
    @State private var showScanView = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Daily Sugar Intake")
                    .font(.title)
                    .bold()
                    .padding()
                CircularProgressBar(progress: sugarIntake, total: Double(sugarLimit))
                    .frame(width: 200, height: 200)
                    .padding()
                
                Button(action: {
                    showScanView = true
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
                NavigationLink(destination: ScanView(updateSugarLimit: { newLimit in
                    sugarLimit = newLimit
                }), isActive: $showScanView) { EmptyView() }
            }
            .padding()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(sugarLimit: 36)
    }
}
