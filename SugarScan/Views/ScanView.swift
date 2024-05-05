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
    @State private var navigateToEditSugar = false
    var updateSugarLimit: (Int) -> Void
    
    @Environment(\.presentationMode) var presentationMode
    
    init(updateSugarLimit: @escaping (Int) -> Void) {
        self.updateSugarLimit = updateSugarLimit
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if let uiImage = viewModel.uiImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                } else {
                    Image("dummyimage")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .padding()
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(10)
                }
                Text(viewModel.label)
                    .padding()
                Button("Scan Product") {
                    self.showingImagePicker = true
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(10)
            }
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: self.$inputImage, sourceType: .camera)
            }
            .navigationTitle("Scan Product")
            .onChange(of: viewModel.isDataReady) {
                if viewModel.isDataReady {
                    self.navigateToEditSugar = true
                }
            }
            NavigationLink(destination: AddSugarView(viewModel: viewModel, updateSugarLimit: updateSugarLimit, navigateToMainView: {
                presentationMode.wrappedValue.dismiss()
            }), isActive: $navigateToEditSugar) { EmptyView() }
        }
    }
    
    private func loadImage() {
        viewModel.loadImage(inputImage)
    }
}

struct ScanView_Previews: PreviewProvider {
    static var previews: some View {
        ScanView(updateSugarLimit: { _ in })
    }
}

