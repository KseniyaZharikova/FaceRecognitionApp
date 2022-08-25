//
//  PassportPresenterImpl.swift
//  Veriff
//
//  Created by Kseniya Zharikova on 27/7/22.
//

import Foundation
import UIKit

protocol PassportView: AnyObject {}

protocol PassportPresenter: AnyObject {
    init(view: PassportView, detector: Detector, coordinator: Coordinator)
    func takedPhotoAction(image: UIImage?)
}

final class PassportPresenterImpl: PassportPresenter {
    let view: PassportView
    var coordinator: Coordinator?
    let detector: Detector
    
    required init(view: PassportView, detector: Detector, coordinator: Coordinator) {
        self.view = view
        self.coordinator = coordinator
        self.detector = detector
    }
    
    func takedPhotoAction(image: UIImage?) {
        guard let image = image else { return }
        
        detector.detectText(image: image, { [weak self] result in
            guard let self = self else { return }
            self.coordinator?.didFinishDocumentRecognition(result: result)
        })
    }
}
