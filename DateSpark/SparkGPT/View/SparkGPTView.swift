//
//  SparkGPTView.swift
//  DateSpark-S24-Svitlik-Russell
//
//  Created by Sarah Svitlik on 3/13/24.
 
//Used SwiftUI with ChatGPT Tutorial: https://www.youtube.com/watch?v=bUDCW2NeO8Y

import SwiftUI
import OpenAISwift

final class ViewModel: ObservableObject {
    
   // init (){}
    
    private var client: OpenAISwift?
    
    func setup(){
        client = OpenAISwift(config: OpenAISwift.Config.makeDefaultOpenAI(apiKey: "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"))
            print("API Configured")
    }
    
    func send(text: String,
              completion: @escaping (String) -> Void) {
        client?.sendCompletion(with: text,
                               maxTokens: 500,
                               completionHandler:  { result in
            switch result {
            case.success(let model):
                let output = model.choices?.first?.text ?? ""
                completion(output)
            case .failure(_):
                break
            }
        })
        }
        
    }
 
struct SparkGPTView: View {
    @ObservedObject var viewModel = ViewModel()
    @State var text = ""
    @State var models = [String]()
    
    var body: some View {
        VStack (alignment: .leading){
            ForEach(models, id: \.self) { string in
                Text(string)
            }
            
            Spacer()
            
            HStack {
                TextField("Need date ideas?", text: $text)
                Button("Send") {
                    print("Button pressed")
                }
            }
        }
         
        .padding()
    }
}

#Preview {
    SparkGPTView()
}
