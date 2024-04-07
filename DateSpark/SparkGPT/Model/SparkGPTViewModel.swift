//
//  SparkGPTViewModel.swift
//  DateSpark
//
//  Created by Sarah Svitlik on 4/7/24.
//

import Combine
import OpenAIKit
import Foundation
import SwiftUI

class SparkGPTViewModel: ObservableObject {
    @Published var text: String = ""
    @Published var response: String = ""
    @Published var isLoading: Bool = false
    
    private let openAI: OpenAIKit
    private var previousMessages: [AIMessage] = []
    
    init(openAI: OpenAIKit) {
        self.openAI = openAI
    }
    func sendQuestion() {
            isLoading = true
            response = ""

            let prompt = text
            // Assuming openAI is an instance of a class that handles the API call
            openAI.sendChatCompletion(newMessage: AIMessage(role: .user, content: prompt), previousMessages: previousMessages, model: .gptV3_5(.gptTurbo), maxTokens: 2048, n: 1) { [weak self] result in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    switch result {
                    case .success(let aiResult):
                        if let text = aiResult.choices.first?.message?.content {
                            self?.response = text
                        }
                    case .failure(let error):
                        self?.response = "Error: \(error.localizedDescription)"
                    }
                }
            }
        }
 }
