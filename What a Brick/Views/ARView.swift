//
//  ARView.swift
//  What a Brick
//
//  Created by Kuba Florek on 22/09/2020.
//

import SwiftUI

struct ARView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let brick: brick
    
    var body: some View {
        ZStack {
            ARQuickLookView(name: "\(brick.size)\(brick.color)")
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .padding()
                            .background(Color.black.opacity(0.75))
                            .foregroundColor(.white)
                            .font(.title)
                            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                            .padding()
                    }
                }
                
                Spacer()
            }
        }
    }
}
