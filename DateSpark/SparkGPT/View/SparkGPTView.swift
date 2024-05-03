//  SparkGPTView.swift
//  DateSpark-S24-Svitlik-Russell
//
//  Created by Sarah Svitlik on 3/13/24.

import SwiftUI
import OpenAISwift
import OpenAIKit
 
struct SparkGPTView: View {
    @State var response: String = ""
    @State var messages: [Message] = []
    @State var isLoading: Bool = false
    @State var txt: String = ""
    @State var description: String = ""
    @State var question: String = ""
    let organizationName: String = "Personal"
    private let apiToken: String = "sk-proj-rOQDZohcRjcuYtphurXqT3BlbkFJlbtM6uvSPkzdt87I1P6w"
    let titleFont = Font.largeTitle.lowercaseSmallCaps()

    public let openAI = OpenAIKit(apiToken: "sk-proj-rOQDZohcRjcuYtphurXqT3BlbkFJlbtM6uvSPkzdt87I1P6w", organization: "org-AGjsVJi2tjy6VBltQ9HmvodS")
    
    var body: some View {
        VStack {
            ZStack {
            Text("SparkGPT")
                .font(titleFont)
                .padding(.top, 50)
        }
            List {
                ForEach($messages, id: \.id) { $message in
                    HStack {
                        if message.role == .user {
                            Spacer()
                            Text(message.content)
                                .padding()
                                .background(CustomColors.darkRed)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        } else {
                            Text(message.content)
                                .padding()
                                .background(Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            Spacer()
                        }
                    }
                }
            }

                
                Spacer()

                HStack {
                                TextField("Ask me for ideas!", text: $question)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                Button(action: {
                                    sendQuestion()
                                    self.question = ""
                                }) {
                                    Image(systemName: "paperplane.fill")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(CustomColors.lightPink)
                                }
                                .buttonStyle(BorderlessButtonStyle())
                                .padding(.horizontal)
                            }
                            .padding(.bottom)
                         }
                        .padding()
                    }
    
    
    func sendQuestion() {
        isLoading = true
        messages.append(Message(content: question, role: .user))
        
        
        let prompt = question
        let keywords = ["date", "idea", "romontaic", "fun", "idea", "ideas", "dinner", "birthday", "outing"]
        
        if keywords.contains(where: question.lowercased().contains){
            
            openAI.sendChatCompletion(newMessage: AIMessage(role: .user, content: prompt), previousMessages: [], model: .gptV3_5(.gptTurbo), maxTokens: 2048, n: 1) { result in
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                
                switch result {
                case .success(let aiResult):
                    if let text = aiResult.choices.first?.message?.content {
                        DispatchQueue.main.async {
                            self.messages.append(Message(content: text, role: .SparkGPT))
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
                else {
                    self.messages.append(Message(content: "I can only help with date ideas, please let me know what time of date you are looking for!", role: .SparkGPT))
                }
            }
        }
        
        #Preview {
            SparkGPTView()
        }
    

struct Message: Identifiable {
    let id = UUID()
    let content: String
    var role: Role
}

enum Role {
    case user
    case SparkGPT
}

