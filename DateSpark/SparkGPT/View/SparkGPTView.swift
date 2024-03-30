//
//  SparkGPTView.swift
//  DateSpark-S24-Svitlik-Russell
//
//  Created by Sarah Svitlik on 3/13/24.
//

//Used SwiftUI with ChatGPT Tutorial: https://www.youtube.com/watch?v=bUDCW2NeO8Y

import SwiftUI
import OpenAISwift

struct SparkGPTView: View {
    private var client: OpenAISwift?
    @State private var text = ""
    @State private var models = [String]()
    
    init() {
        let apiConfig = OpenAISwift.Config.makeDefaultOpenAI(apiKey: "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")
        self.client = OpenAISwift(config: apiConfig)
    }
    
    var body: some View {
        VStack (alignment: .leading) {
            ForEach(models, id: \.self) { string in
                Text(string)
            }
        }
        Spacer()
        
        HStack {
            TextField("Type Here...", text: $text)
            Button("Send") {
                self.sendMessage()
            }
        }
        .padding()
    }
    
    private func sendMessage() {
        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        models.append("Me: \(text)")
        client?.sendCompletion(with: text, maxTokens: 500) { result in
            switch result {
            case .success(let model):
                let output = model.choices?.first?.text ?? ""
                DispatchQueue.main.async {
                    self.models.append("ChatGPT: " + output)
                    self.text = ""
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}



#Preview {
    SparkGPTView()
}
