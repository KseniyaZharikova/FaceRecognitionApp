//
//  BuilderImpl.swift
//  Veriff
//
//  Created by Kseniya Zharikova on 25/7/22.
//

import Foundation
import UIKit

 protocol Builder {
    func createSelfieModule(coordinator: Coordinator) -> UIViewController
    func createPassportModule(coordinator: Coordinator) -> UIViewController
}

final class BuilderImpl : Builder {
    func createSelfieModule(coordinator: Coordinator) -> UIViewController {
        let view = SelfieViewController()
        let detector = Detector()
        let presenter = SelfiePresenterImpl(view: view, detector: detector, coordinator: coordinator)
        view.presenter = presenter
        return view
    }
    
    func createPassportModule(coordinator: Coordinator) -> UIViewController {
        let view = PassportViewController()
        let detector = Detector()
        let presenter = PassportPresenterImpl(view: view, detector: detector, coordinator: coordinator)
        view.presenter = presenter
        return view
    }
}
