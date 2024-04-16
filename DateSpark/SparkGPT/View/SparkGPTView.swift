//  SparkGPTView.swift
//  DateSpark-S24-Svitlik-Russell
//
//  Created by Sarah Svitlik on 3/13/24.

import SwiftUI
import OpenAISwift
import OpenAIKit

struct SparkGPTView: View {
    @State var response: String = ""
    @State var isLoading: Bool = false
    @State var txt: String = ""
    
    private let apiToken: String = "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"
    public let openAI: OpenAIKit = OpenAIKit(apiToken: "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")
    
    var body: some View {
        VStack {
            // Display the chat response
            Text(response)
            
            Spacer()
            
            HStack {
                TextField("Need date ideas?", text: $txt)
                Button("Send") {
                    sendQuestion()
                }
            }
        }
        .padding()
        .overlay(
            Group {
                if isLoading {
                    ProgressView()
                }
            }
        )
    }
    
    func sendQuestion() {
        isLoading = true
        response = ""
        
        let prompt = txt
        openAI.sendStreamChatCompletion(newMessage: AIMessage(role: .user, content: txt), model: .gptV3_5(.gptTurbo), maxTokens: 2048) { result in
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
        
        #Preview {
            SparkGPTView()
        }
    
