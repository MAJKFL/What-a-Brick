//
//  BrickRecognizeView.swift
//  What a Brick
//
//  Created by Kuba Florek on 04/09/2020.
//

import SwiftUI
import CoreML
import SceneKit

struct BrickRecognizeView: View {
    @EnvironmentObject var collection: Collection
    
    @Binding var image: UIImage?
    @Binding var pickNewBrick: Bool
    
    @State private var brickSize = ""
    @State private var brickColorName = ""
    @State private var brickColor = Color.white
    @State private var scene: SCNScene?
    let node = SCNNode()
    
    var body: some View {
        VStack {
            SceneView(scene: scene, pointOfView: node, options: [.autoenablesDefaultLighting, .allowsCameraControl])
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)
                .background(Color.white)
                .clipShape(CustomCorners(corners: UIDevice.hasNotch() ? [.allCorners] : [.bottomRight, .bottomLeft], size: 25))
            
            Text(brickSize)
                .roundedRectangleInfoStyle(color: .white, isFullSize: true)
            
            Text(brickColorName)
                .roundedRectangleInfoStyle(color: .white, isFullSize: true)
            
            Button(action: {
                addBrick()
            } ) {
                Text("Add")
                    .roundedRectangleInfoStyle(color: .green, isFullSize: true)
            }
            
            Button("return") {
                pickNewBrick = true
            }
                .font(.title)
            
            Spacer()
        }
        .background(brickColor)
        .clipShape(RoundedRectangle(cornerRadius: UIDevice.hasNotch() ? 25 : 0))
        .ignoresSafeArea(.all)
        .statusBar(hidden: true)
        .transition(AnyTransition.opacity.combined(with: .scale))
        .onAppear(perform: classifyBrickSize)
        .onAppear(perform: classifyBrickColor)
    }
    
    /// Classifies brick size by input image
    func classifyBrickSize() {
        let config = MLModelConfiguration()
        
        let model = try? BrickClassifier(configuration: config)
        
        let resizedImage = image!.resizeTo(size: CGSize(width: 299, height: 299))
        
        let buffer = resizedImage!.toBuffer()!
        
        let input = BrickClassifierInput(image: buffer)
        
        let output = try? model!.prediction(input: input)
        
        if let output = output {
            brickSize = output.classLabel
        } else {
        }
    }
    
    /// Classifies brick color by input image
    func classifyBrickColor() {
        var rotatedImage = image
        
        if image!.size.width < image!.size.height {
            rotatedImage = image!.rotate(radians: .pi/2)!
        }
        
        let uicolor = rotatedImage!.getCenterColor(atLocation: CGPoint(x: rotatedImage!.size.width / 2, y: rotatedImage!.size.height / 2), withFrameSize: rotatedImage!.size)
        
        let colors = UIColor.getAllColors()
        
        var mostSimilarColor = UIColor.black
        
        for color in colors {
            if uicolor!.colorDistanceBetween(uicolor: mostSimilarColor) > uicolor!.colorDistanceBetween(uicolor: color.value) {
                mostSimilarColor = color.value
                brickColorName = color.key
            }
        }
        
        brickColor = Color(mostSimilarColor)
        
        setupScene(color: mostSimilarColor)
    }
    
    /// Setups SCNScene and camera node
    func setupScene(color: UIColor) {
        node.position = SCNVector3(0, 10, 50)
        
        node.camera = SCNCamera()
        
        scene = SCNScene(named: "\(brickSize).usdz")
        
        let obj = scene?.rootNode.childNode(withName: "obj", recursively: true)
        
        obj?.geometry?.firstMaterial?.diffuse.contents = color
    }
    
    /// Adds brick to collection
    func addBrick() {
        collection.add(colorName: brickColorName, brickSize: brickSize)
        
        pickNewBrick = true
        
        image = nil
        
        let generator = UINotificationFeedbackGenerator()
        
        generator.notificationOccurred(.success)
    }
}

/// Shape with rounded input corners
struct CustomCorners: Shape {
    var corners : UIRectCorner
    var size : CGFloat
      
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: size, height: size))
        
        return Path(path.cgPath)
    }
}

/// View modifier for info panels
struct roundedRectangleInfo: ViewModifier {
    let color: Color
    let isFullSize: Bool
    
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.black)
            .frame(width: isFullSize ? UIScreen.main.bounds.width - 30 : (UIScreen.main.bounds.width - 50) / 2, height: UIScreen.main.bounds.height / 10)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
            .shadow(radius: 25)
            .padding(5)
    }
}

/// roundedRectangleInfo view extension
extension View {
    func roundedRectangleInfoStyle(color: Color, isFullSize: Bool) -> some View{
        self.modifier(roundedRectangleInfo(color: color, isFullSize: isFullSize))
    }
}
