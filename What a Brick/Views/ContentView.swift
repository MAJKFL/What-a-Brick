//
//  ContentView.swift
//  What a Brick
//
//  Created by Kuba Florek on 04/09/2020.
//

import SwiftUI

struct ContentView: View {
    @State var image: UIImage?
    @State var showCaptureImageView: Bool = true
    
    var body: some View {
        let showCamera = Binding<Bool>(
            get: {
                showCaptureImageView
            },
            set: {
                if image == nil {
                    showCaptureImageView = true
                } else {
                    showCaptureImageView = $0
                }
            }
        )
        
        ZStack {
            if image != nil && showCaptureImageView == false {
                BrickRecognizeView(image: $image, pickNewBrick: showCamera)
            } else if showCaptureImageView == true {
                ZStack {
                    CaptureImageView(isShown: showCamera, image: $image)
                    
                    Circle()
                        .frame(width: 10, height: 10)
                        .opacity(0)
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                }
                .transition(.move(edge: .bottom))
            }
        }
        .animation(.easeIn)
    }
}

struct CaptureImageView {
  
  @Binding var isShown: Bool
  @Binding var image: UIImage?
  
  func makeCoordinator() -> Coordinator {
    return Coordinator(isShown: $isShown, image: $image)
  }
}

extension CaptureImageView: UIViewControllerRepresentable {
  func makeUIViewController(context: UIViewControllerRepresentableContext<CaptureImageView>) -> UIImagePickerController {
    let picker = UIImagePickerController()
    picker.delegate = context.coordinator
    // For using in simulator comment this line
    picker.sourceType = .camera
    return picker
  }
  
  func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<CaptureImageView>) {
    
  }
}

