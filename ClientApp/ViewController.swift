//
//  ViewController.swift
//  ClientApp
//
//  Created by Kseniya Zharikova on 11/8/22.
//

import UIKit
import Veriff

class ViewController: UIViewController {
    
    @IBOutlet weak var faceTitleLabel: UILabel!
    @IBOutlet weak var faceStatusLabel: UILabel!
    @IBOutlet weak var faceErrorLabel: UILabel!
    
    @IBOutlet weak var documentTitileLabel: UILabel!
    @IBOutlet weak var documentStatusLabel: UILabel!
    @IBOutlet weak var documentErrorLabel: UILabel!
    
    var results: Veriff.Results?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard results == results else { return }
        
        Veriff.shared.delegate = self
        Veriff.shared.start(from: self)
    }
    
    func setUpUI() {
        view.backgroundColor = .white
    }
    
    func showResults(_ results: Veriff.Results) {
        switch results.faceRecognitionResult {
        case.success:
            faceErrorLabel.isHidden = true
            faceStatusLabel.text = "Success"
            faceStatusLabel.textColor = .green
        case .failure(let error):
            faceErrorLabel.isHidden = false
            faceStatusLabel.text = "Falure"
            faceStatusLabel.textColor = .red
            faceErrorLabel.text = error.errorText
        }
        
        switch results.textRecognitionResult {
        case.success:
            documentErrorLabel.isHidden = true
            documentStatusLabel.text = "Success"
            documentStatusLabel.textColor = .green
        case .failure(let error):
            documentErrorLabel.isHidden = false
            documentStatusLabel.text = "Falure"
            documentStatusLabel.textColor = .red
            documentErrorLabel.text = error.errorText
        }
    }
    
    // MARK: - Actions
    
    @IBAction func tryAgainAction(_ sender: Any) {
        Veriff.shared.start(from: self)
    }
}

extension ViewController: Veriff.Delegate {
    func didFinish(results: Veriff.Results) {
        self.results = results
        showResults(results)
    }
}

extension Veriff.ErrorReason {
    
    var errorText: String {
        switch self {
        case .noFace:
            return "No face found"
        case .moreThanOneFace:
            return "Found more than one face"
        case .noText:
            return "No text found"
        case .internalError:
            return "Internal Error"
        }
    }
}
