//
//  CoordinatorImpl.swift
//  Veriff
//
//  Created by Kseniya Zharikova on 25/7/22.
//

import Foundation
import UIKit

protocol Coordinator {
    func start(from viewController: UIViewController, delegate: VeriffCoordinatorDelegate)
    func didFinishFaceRecognition(result: Result<UIImage,Veriff.ErrorReason>)
    func didFinishDocumentRecognition(result: Result<[String],Veriff.ErrorReason>)
}

final class CoordinatorImpl: Coordinator {
    
    private var delegate: VeriffCoordinatorDelegate?
    private var builder: Builder?
    private var faceRecognitionResult: Result<UIImage,Veriff.ErrorReason>?
    private var textRecognitionResult: Result<[String],Veriff.ErrorReason>?
    private var navigationController: UINavigationController?
    
    init(builder: Builder) {
        self.builder = builder
    }
    
    func start(from viewController: UIViewController, delegate: VeriffCoordinatorDelegate) {
        self.delegate = delegate
        
        guard let vc = builder?.createSelfieModule(coordinator: self) else { return }
        let navigationController = UINavigationController()
        navigationController.viewControllers = [vc]
        navigationController.modalPresentationStyle = .overFullScreen
        self.navigationController = navigationController
        viewController.present(navigationController, animated: true)
    }
    
    func didFinishFaceRecognition(result: Result<UIImage,Veriff.ErrorReason>) {
        faceRecognitionResult = result
        openPassportViewController()
    }
    
    func didFinishDocumentRecognition(result: Result<[String],Veriff.ErrorReason>) {
        textRecognitionResult = result
        finish()
    }
    
    private func finish() {
        guard let faceRecognitionResult = faceRecognitionResult , let textRecognitionResult = textRecognitionResult else {
            delegate?.didFinish(results: .init(faceRecognitionResult: .failure(.internalError), textRecognitionResult: .failure(.internalError)))
            return
        }

        delegate?.didFinish(results: .init(faceRecognitionResult: faceRecognitionResult, textRecognitionResult: textRecognitionResult))
        
        navigationController?.dismiss(animated: true)
        
    }
    
  private func openPassportViewController() {
        guard let navigationController = navigationController else { return }
        guard let passportViewController = builder?.createPassportModule(coordinator: self) else { return }
        navigationController.pushViewController(passportViewController, animated: true)
    }
}

protocol VeriffCoordinatorDelegate {
    func didFinish(results: Veriff.Results)
}
