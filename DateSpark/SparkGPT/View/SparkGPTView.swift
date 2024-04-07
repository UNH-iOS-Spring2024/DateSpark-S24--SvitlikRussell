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
