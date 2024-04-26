//  SplashScreenView.swift
//  DateSpark

import SwiftUI

struct SplashScreenView: View {
    @Binding var isActive: Bool
    @State private var progressValue: Double = 0.0
    @State private var flashingOpacity: Double = 1.0
    
    
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            Image("SplashScreen")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.clear)
            
            VStack {
                Spacer()// Double spacer needed for now; move loading bar below image
                Spacer()
                ProgressView(value: progressValue, total: 100)
                    .progressViewStyle(LinearProgressViewStyle(tint: Color.pink))
                    .scaleEffect(x: 2, y: 10, anchor: .center)
                    .frame(width: 200, height: 40) 
                    .background(Color.white)
                    .cornerRadius(20)
                    .border(Color.white)
                        .cornerRadius(20)
                    .shadow(radius: 3)
                    .opacity(flashingOpacity)
                Spacer()
                    .onAppear {
                        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                            if self.progressValue < 100 {
                                self.progressValue += 2
                            } else {
                                timer.invalidate()
                                withAnimation(.easeOut(duration: 0.5)) {
                                    self.flashingOpacity = 0
                                }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    self.isActive = true
                                        }
                            }
                        }
                    }
            }
        }
    }
}
struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView(isActive: .constant(false))
    }
}
