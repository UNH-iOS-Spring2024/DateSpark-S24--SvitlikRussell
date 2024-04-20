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
    @State var description: String = ""
    @State var question: String = ""
    let organizationName: String = "Personal"
    private let apiToken: String = "sk-proj-HE6uylswy2zmIMtmpTHhT3BlbkFJXeAnYN3zpP0JJ4Pm0DEf"
    
    public let openAI = OpenAIKit(apiToken: "sk-proj-HE6uylswy2zmIMtmpTHhT3BlbkFJXeAnYN3zpP0JJ4Pm0DEf", organization: "org-AGjsVJi2tjy6VBltQ9HmvodS")
    
    var body: some View {
           VStack {
              
               
               Text("SparkGPT: \(response)")
                   .padding(.horizontal)
                   .padding(.bottom, 500)

               Spacer()

               HStack {
                   TextField("Ask me for ideas!", text: $question)
                       .textFieldStyle(RoundedBorderTextFieldStyle())
                   Button(action: {
                       sendQuestion()
                   }) {
                       Image(systemName: "paperplane")
                           .resizable()
                           .frame(width: 30, height: 30)
                           .foregroundColor(.lightPink)
                   }
                   .buttonStyle(BorderlessButtonStyle())
                   .padding(.horizontal)
               }
               
               TextEditor(text: $description)
                   .background(Color(.systemBackground))
                   .foregroundColor(Color(.label))
                   .padding(.horizontal)
                   .frame(minHeight: 100)
           }
           .padding()
       }

    
    
    func sendQuestion() {
        isLoading = true
        response = ""
        
        let prompt = question
        openAI.sendChatCompletion(newMessage: AIMessage(role: .user, content: prompt), previousMessages: [], model: .gptV3_5(.gptTurbo), maxTokens: 2048, n: 1) { result in
            DispatchQueue.main.async {
                self.isLoading = false
            }
            
            switch result {
            case .success(let aiResult):
                if let text = aiResult.choices.first?.message?.content {
                    DispatchQueue.main.async {
                        self.response = text
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
        
        #Preview {
            SparkGPTView()
        }
    
