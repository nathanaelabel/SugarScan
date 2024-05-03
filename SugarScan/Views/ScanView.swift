//
//  ContentView.swift
//  SugarScan
//
//  Created by Nathanael Abel on 29/04/24.
//

import SwiftUI

struct ScanView: View {
    @StateObject var viewModel = ScanViewModel()
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var navigateToEditSugar = false  // State to control navigation
    
    var body: some View {
        NavigationView {
            VStack {
                if let uiImage = viewModel.uiImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                }
                Text(viewModel.label)
                    .padding()
                Button("Click Me to Scan") {
                    self.showingImagePicker = true
                }
                NavigationLink(destination: AddSugarView(viewModel: viewModel), isActive: $navigateToEditSugar) {
                    EmptyView()
                }
            }
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: self.$inputImage, sourceType: .camera)
            }
            .navigationTitle("Scan Product")
            .onChange(of: viewModel.isDataReady) { isReady in
                if isReady {
                    self.navigateToEditSugar = true  // Trigger navigation
                }
            }
        }
    }
    
    private func loadImage() {
        viewModel.loadImage(inputImage)
    }
}

struct ScanView_Previews: PreviewProvider {
    static var previews: some View {
        ScanView()
    }
}
