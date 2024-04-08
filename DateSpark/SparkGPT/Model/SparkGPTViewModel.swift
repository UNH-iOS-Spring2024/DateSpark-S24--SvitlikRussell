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
        openAI.sendStreamChatCompletion(newMessage: AIMessage(role: .user, content: "Hello!"), model: .gptV3_5(.gptTurbo), maxTokens: 2048) { result in
            switch result {
            case .success(let streamResult):
                /// Hadle success response result
                if let streamMessage = streamResult.message?.choices.first?.message {
                    print("Stream message: \(streamMessage)") //"\n\nHello there, how may I assist you today?"
                }
            case .failure(let error):
                // Handle error actions
                print(error.localizedDescription)
            }
        }
    }
}
 
