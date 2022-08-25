//
//  Veriff.swift
//  Veriff
//
//  Created by Kseniya Zharikova on 2/8/22.
//

import Foundation
import UIKit

public enum Veriff {
    
    public enum ErrorReason: Error {
        case noFace
        case moreThanOneFace
        case noText
        case internalError
    }

    public typealias SDK = VeriffSDK
    public typealias Delegate = VeriffSDKDelegate
    
    public static var shared: SDK = {
        let builder = BuilderImpl()
        let coordinator = CoordinatorImpl(builder: builder)
        return VeriffSDKImpl(coordinator: coordinator)
    }()
}

public protocol VeriffSDK {
    func start(from viewController: UIViewController)
    var delegate: Veriff.Delegate? { get set }
}

public protocol VeriffSDKDelegate {
    func didFinish(results: Veriff.Results)
}

extension Veriff {
    public struct Results: Equatable {
        public var faceRecognitionResult: Result<UIImage,ErrorReason>
        public var textRecognitionResult: Result<[String],ErrorReason>
    }
}
