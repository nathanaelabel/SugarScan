//
//  ViewController.swift
//  SugarScan
//
//  Created by Nathanael Abel on 30/04/24.
//

import UIKit
import Vision
import AVFoundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.text = "Sugar Intake"
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let cameraButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Scan Product", for: .normal)
        button.addTarget(self, action: #selector(didTapTakePhoto), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(label)
        view.addSubview(imageView)
        view.addSubview(cameraButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = CGRect(x: 20,
                                 y: view.safeAreaInsets.top,
                                 width: view.frame.size.width-40,
                                 height: view.frame.size.width-40)
        label.frame = CGRect(x: 20,
                             y: imageView.frame.maxY + 20,
                             width: view.frame.size.width-40,
                             height: 100)
        cameraButton.frame = CGRect(x: 20,
                                    y: label.frame.maxY + 20,
                                    width: view.frame.size.width-40,
                                    height: 50)
    }
    
    @objc func didTapTakePhoto() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized: // The user has previously granted access to the camera.
            self.presentCamera()
            
        case .notDetermined: // The user has not yet been asked for camera access.
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        self.presentCamera()
                    }
                }
            }
            
        case .denied: // The user has previously denied access.
            return // Consider alerting the user.
            
        case .restricted: // The user can't grant access due to restrictions.
            return // Consider alerting the user.
            
        @unknown default:
            break
        }
    }
    
    func presentCamera() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else { return }
        imageView.image = image
        recognizeText(image: image)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func recognizeText(image: UIImage?) {
        guard let cgImage = image?.cgImage else {
            label.text = "Error: Image is not valid."
            return
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { [weak self] request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation], error == nil else {
                DispatchQueue.main.async {
                    self?.label.text = "Error: \(error?.localizedDescription ?? "Unknown error")"
                }
                return
            }
            
            let textResults = observations.compactMap({ $0.topCandidates(1).first?.string })
            self?.processNutritionalInfo(textResults: textResults)
        }
        
        do {
            try handler.perform([request])
        } catch {
            DispatchQueue.main.async {
                self.label.text = "Failed to perform recognition: \(error.localizedDescription)"
            }
        }
    }
    
    func processNutritionalInfo(textResults: [String]) {
        var servingsPerPackage: Int?
        var totalSugar: Double?
        
        // Extract specific nutritional information from recognized text
        for text in textResults {
            let lowercasedText = text.lowercased()
            if lowercasedText.contains("takaran saji") {
                servingsPerPackage = extractNumber(from: text)
            } else if lowercasedText.contains("gula") {
                let extracted = extractNumberAndUnit(from: text)
                if let sugarPerServing = extracted.number, let servings = servingsPerPackage {
                    totalSugar = sugarPerServing * Double(servings)
                }
            }
        }
        
        // Update the UI
        if let sugar = totalSugar {
            DispatchQueue.main.async {
                self.label.text = "Total Sugar Intake: \(sugar) g"
            }
        }
    }
    
    func extractNumberAndUnit(from text: String) -> (number: Double?, unit: String?) {
        let pattern = "([0-9]+\\.?[0-9]*)\\s*(g|mg|ml|l)?"
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let nsString = text as NSString
        let results = regex?.matches(in: text, options: [], range: NSRange(location: 0, length: nsString.length))
        
        if let result = results?.first, result.numberOfRanges == 3 {
            let numberString = nsString.substring(with: result.range(at: 1))
            let number = Double(numberString)
            var unit: String? = nil
            if result.range(at: 2).location != NSNotFound {
                unit = nsString.substring(with: result.range(at: 2))
            }
            return (number, unit)
        }
        return (nil, nil)
    }
    
    func extractNumber(from text: String) -> Int? {
        let numbers = text.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        return Int(numbers)
    }
}


#Preview {
    ViewController()
}
