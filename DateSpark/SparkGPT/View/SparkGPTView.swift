//
//  SparkGPTView.swift
//  DateSpark-S24-Svitlik-Russell
//
//  Created by Sarah Svitlik on 3/13/24.

import SwiftUI
import OpenAISwift
import OpenAIKit

struct SparkGPTView: View {
    @StateObject var viewModel = SparkGPTViewModel(openAI: OpenAIKit(apiToken: "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", organization: "DateSpark"))

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
