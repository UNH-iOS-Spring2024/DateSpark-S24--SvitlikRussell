//
//  SparkGPTController.swift
//  DateSpark
//
//  Created by Sarah Svitlik on 4/5/24.
//

import Foundation
import UIKit
import OpenAIKit
import SwiftUI

class SparkGPTController: UIViewController {
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var loader: UIActivityIndicatorView!
    @IBOutlet private weak var sendBtn: UIButton!
    @IBOutlet private weak var bottomOffset: NSLayoutConstraint!
 
    
    private var observers = [NSObjectProtocol]()
    
    deinit {
        observers.forEach { NotificationCenter.default.removeObserver($0) }
        observers.removeAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureObservers()
        stopLoading()
        
        textField.becomeFirstResponder()
    }
    
    @IBAction private func sendQuestion() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Error: Unable to access AppDelegate")
            return
        }
        
        let openAI = appDelegate.openAI
        
        startLoading()
        textView.text = ""
        
        let prompt = textField.text ?? ""
        let previousMessages: [AIMessage] = []
        
        openAI.sendChatCompletion(newMessage: AIMessage(role: .user, content: prompt), previousMessages: previousMessages, model: .gptV3_5(.gptTurbo), maxTokens: 2048, n: 1) { [weak self] result in
            DispatchQueue.main.async { self?.stopLoading() }
            
            switch result {
            case .success(let aiResult):
                DispatchQueue.main.async { [weak self] in
                    if let text = aiResult.choices.first?.message?.content {
                        self?.textView.text = text
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async { [weak self] in
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default))
                    if let viewController = self {
                        viewController.present(alert, animated: true)
                    } else {
                        print("Error: Unable to present alert. Self is nil.")
                    }
                }
            }
        }
    }

    
    private func configureObservers() {
        observers.append(NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: OperationQueue.main,
            using: { [weak self] notification in
                DispatchQueue.main.async { [weak self] in
                    guard let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else { return }
                    self?.bottomOffset.constant = keyboardHeight + 16
                    self?.sendBtn.isHidden = false
                    self?.view.layoutSubviews()
                }
            }))
        
        observers.append(NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: OperationQueue.main,
            using: { [weak self] _ in
                DispatchQueue.main.async { [weak self] in
                    UIView.animate(withDuration: 0.275) { [weak self] in
                        self?.bottomOffset.constant = 16
                        self?.sendBtn.isHidden = true
                        self?.view.layoutSubviews()
                    }
                }
            }))
    }
    
    private func startLoading() {
        view.isUserInteractionEnabled = false
        loader.startAnimating()
        loader.isHidden = false
    }
    
    private func stopLoading() {
        textField.resignFirstResponder()
        view.isUserInteractionEnabled = true
        loader.stopAnimating()
        loader.isHidden = true
    }
}
 
