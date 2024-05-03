//
//  AddSugarView.swift
//  SugarScan
//
//  Created by Nathanael Abel on 29/04/24.
//

import SwiftUI
import Vision
import AVFoundation

class ScanViewModel: ObservableObject {
    @Published var image: Image?
    @Published var uiImage: UIImage?
    @Published var label: String = "Sugar Scan App"
    @Published var productName: String = ""
    @Published var servingsPerPackage: Double?
    @Published var sugarAmount: Double?
    @Published var isDataReady: Bool = false  // Flag to navigate to AddSugarView
    
    func loadImage(_ inputImage: UIImage?) {
        guard let inputImage = inputImage else {
            label = "No image selected."
            return
        }
        print("Loading image...")
        image = Image(uiImage: inputImage)
        uiImage = inputImage
        recognizeText(image: inputImage)
    }
    
    private func recognizeText(image: UIImage) {
        guard let cgImage = image.cgImage else {
            self.label = "Error: Image is not valid."
            return
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { [weak self] request, error in
            guard let self = self else { return }
            if let error = error {
                DispatchQueue.main.async {
                    self.label = "Recognition Error: \(error.localizedDescription)"
                }
                return
            }
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                DispatchQueue.main.async {
                    self.label = "No text found in image."
                }
                return
            }
            let textResults = observations.compactMap({ $0.topCandidates(1).first?.string })
            print("Recognized text results: \(textResults)")  // Debug print statement
            DispatchQueue.main.async {
                self.processNutritionalInfo(textResults: textResults)
                self.isDataReady = true  // Update the flag when data processing is complete
            }
        }
        
        do {
            try handler.perform([request])
        } catch {
            DispatchQueue.main.async {
                self.label = "Failed to perform recognition: \(error.localizedDescription)"
            }
        }
    }
    
    private func processNutritionalInfo(textResults: [String]) {
        var servingsText: String?
        var sugarText: String?
        
        for text in textResults {
            let lowercasedText = text.lowercased()
            if lowercasedText.contains("sajian per kemasan") {
                servingsText = text
            } else if lowercasedText.starts(with: "gula") {
                sugarText = text
            }
        }
        
        if let servingsStr = servingsText, let servings = extractLastNumber(servingsStr) {
            DispatchQueue.main.async {
                self.servingsPerPackage = servings
            }
        }
        
        if let sugarStr = sugarText, let sugar = extractLastNumber(sugarStr) {
            DispatchQueue.main.async {
                self.sugarAmount = sugar
            }
        }
    }
    
    private func extractLastNumber(_ text: String) -> Double? {
        let nsString = text as NSString
        let regex = try! NSRegularExpression(pattern: "\\d+\\.?\\d*", options: [])
        let results = regex.matches(in: text, options: [], range: NSRange(location: 0, length: nsString.length))
        return results.last.flatMap { Double(nsString.substring(with: $0.range)) }
    }
    
    //    static let numberRegex = try! NSRegularExpression(pattern: "([0-9]+\\.?[0-9]*)\\s*(g|mg|ml|l)?", options: [])
    //
    //    private func extractNumberAndUnit(from text: String) -> (number: Double?, unit: String?) {
    //        let nsString = text as NSString
    //        let results = ScanViewModel.numberRegex.matches(in: text, options: [], range: NSRange(location: 0, length: nsString.length))
    //
    //        if let result = results.first, result.numberOfRanges == 3 {
    //            let numberString = nsString.substring(with: result.range(at: 1))
    //            let number = Double(numberString)
    //            var unit: String? = nil
    //            if result.range(at: 2).location != NSNotFound {
    //                unit = nsString.substring(with: result.range(at: 2))
    //            }
    //            return (number, unit)
    //        }
    //        return (nil, nil)
    //    }
    //
    //    private func extractNumber(from text: String) -> Double? {
    //        let nsString = text as NSString
    //        let regex = try! NSRegularExpression(pattern: "\\d+\\.?\\d*", options: [])
    //        let results = regex.matches(in: text, options: [], range: NSRange(location: 0, length: nsString.length))
    //        if let result = results.first {
    //            let numberString = nsString.substring(with: result.range)
    //            return Double(numberString)
    //        }
    //        return nil
    //    }
    
    func confirmData() {
        guard let sugar = sugarAmount, let servings = servingsPerPackage, !productName.isEmpty else {
            label = "Please ensure all fields are complete and valid."
            isDataReady = false
            return
        }
        let totalSugar = sugar * servings
        label = "Total Sugar Intake: \(totalSugar) grams"
        isDataReady = true
        print("Total sugar calculated: \(totalSugar)")
    }
    
}
