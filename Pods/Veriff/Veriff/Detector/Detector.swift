//
//  Detector.swift
//  Veriff
//
//  Created by Kseniya Zharikova on 27/7/22.
//

import Vision
import UIKit

//public enum ErrorReason: Error {
//    case noFace
//    case moreThanOneFace
//    case noText
//    case internalError
//}

final class Detector {
    
    func detectFace(image: UIImage, _ completion: @escaping (Result<UIImage, Veriff.ErrorReason>) -> Void) {
        let request = VNDetectFaceRectanglesRequest { (request, error) in
            if let _ = error {
                completion(.failure(.internalError))
            }
            
            guard let results = request.results else {
                completion(.failure(.internalError))
                return
            }
            
            if results.count == .zero {
                completion(.failure(.noFace))
            } else if results.count > 1 {
                completion(.failure(.moreThanOneFace))
            } else {
                completion(.success(image))
            }
        }
        
        detect(image: image, reguest: request)
    }
    
    func detectText(image: UIImage, _ completion: @escaping (Result<[String], Veriff.ErrorReason>) -> Void) {
        let request = VNRecognizeTextRequest { (request, error) in
            if let _ = error {
                completion(.failure(.internalError))
            }
            
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                completion(.failure(.internalError))
                return
            }
            
            let recognizedStrings = observations.compactMap { observation in
                return observation.topCandidates(1).first?.string
            }
            
            recognizedStrings.count == .zero ? completion(.failure(.noText)) : completion(.success(recognizedStrings))
        }
        
        detect(image: image, reguest: request)
    }
    
    private  func detect(image: UIImage, reguest: VNImageBasedRequest) {
        guard let cgImage = image.cgImage else { return }
        
        let handler = VNImageRequestHandler(cgImage: cgImage,options: [:])
        do {
            try handler.perform([reguest])
        } catch {
            print("Unable to perform the requests: \(error).")
        }
    }
}
