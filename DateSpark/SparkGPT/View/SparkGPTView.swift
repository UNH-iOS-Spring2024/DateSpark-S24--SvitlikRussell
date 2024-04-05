//
//  SparkGPTView.swift
//  DateSpark-S24-Svitlik-Russell
//
//  Created by Sarah Svitlik on 3/13/24.
 
import SwiftUI

//
//  SparkGPTView.swift
//  DateSpark-S24-Svitlik-Russell
//
//  Created by Sarah Svitlik on 3/13/24.
 

import SwiftUI
import OpenAISwift

 
struct SparkGPTView: View {
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
                    // self.send()
                    print("Button pressed")
                }
            }
        }
        .onAppear {
            // viewModel.setup()
        }
        .padding()
    }
}
    
#Preview {
    SparkGPTView()
}
