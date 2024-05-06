//
//  Card.swift
//  DateSpark-S24-Svitlik-Russell
//
//  Created by Sarah Svitlik on 3/5/24.
//

import SwiftUI

struct Card: View {
    
    @State private var isTap: Bool = false
    
    let cornerRadius : CGFloat
    let width : CGFloat
    let height : CGFloat
    let color : Color
    let focusColor : Color?
    let elevation : CGFloat
    
    let views   : () -> AnyView
    let click   : () -> Void
    let longClick   : () -> Void
    
    init(
        cornerRadius : CGFloat = 16,
        width : CGFloat = CGFloat.infinity,
        height : CGFloat = 140,
        color : Color = Color(.white),
        focusColor : Color? = nil,
        elevation : CGFloat = 15,
        
        views : @escaping () -> AnyView,
        click : @escaping () -> Void = {},
        longClick : @escaping () -> Void = {}
    ) {
        self.focusColor = focusColor
        self.cornerRadius = cornerRadius
        self.width = width
        self.height = height
        self.color = color
        self.elevation = elevation
        
        self.views = views
        self.click = click
        self.longClick = longClick
    }
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(isTap ? focusColor ?? color : color)
                .frame(maxWidth: width, maxHeight: height)
                .shadow(radius: elevation)
            
            VStack{
                views()
            }
            
        }
//        .padding(.bottom, 20)
        .onTapGesture{
            click()
        }
        .onLongPressGesture(minimumDuration: 0.3, pressing: {
            pressing in isTap = pressing
        }, perform: { longClick()
        })

    }
}

#Preview {
    Card(cornerRadius: 25, height: 200, focusColor: Color(.systemBlue).opacity(0.05)){
        AnyView(
            Text("Movies here")
        )
    }
}
