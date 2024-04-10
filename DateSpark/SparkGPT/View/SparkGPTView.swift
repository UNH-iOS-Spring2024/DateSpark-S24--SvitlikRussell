//
//  SparkGPTView.swift
//  DateSpark-S24-Svitlik-Russell
//
//  Created by Sarah Svitlik on 3/13/24.

import SwiftUI
import OpenAISwift
import OpenAIKit

struct SparkGPTView: View {
    private let apiToken: String = "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"
    public let openAI: OpenAIKit

    @StateObject var viewModel: SparkGPTViewModel
    
    init(openAI: OpenAIKit = OpenAIKit(apiToken: "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")) {
            self.openAI = openAI
            self._viewModel = StateObject(wrappedValue: SparkGPTViewModel(openAI: openAI))
        }
    
    var body: some View {
        VStack {
            // Display the chat response
            Text(viewModel.response)
            
            Spacer()
            
            HStack {
                TextField("Need date ideas?", text: $viewModel.text)
                Button("Send") {
                    viewModel.sendQuestion()
                }
            }
        }
        .padding()
        .overlay(
            Group {
                if viewModel.isLoading {
                    ProgressView()
                }
            }
        )
    }
}
    
#Preview {
    SparkGPTView()
}
