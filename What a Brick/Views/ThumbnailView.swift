//
//  ThumbnailView.swift
//  What a Brick
//
//  Created by Kuba Florek on 21/09/2020.
//

import SwiftUI
import SceneKit

struct ThumbnailView: View {
    let brick: brick
    
    @State private var scene: SCNScene?
    
    let node = SCNNode()
    
    var body: some View {
        HStack {
            ZStack {
                Color("listBorder")
                    //.frame(width: UIScreen.main.bounds.width / 3, height: 100)
                    .frame(width: 130, height: 100)
                    .clipShape(CustomCorners(corners: [.bottomRight, .topRight], size: 15))
                
                SceneView(scene: scene, pointOfView: node, options: [.autoenablesDefaultLighting])
                    .frame(width: 130, height: 98)
                    .background(Color.white)
                    .clipShape(CustomCorners(corners: [.bottomRight, .topRight], size: 15))
            }
            
            GeometryReader { geo in
                VStack(alignment: .center) {
                    Text(brick.size)
                        .font(.title)
                        .bold()
                    
                    Spacer()
                    
                    Text(brick.color)
                        .font(brick.color == "Bright Yellowish-Green" ? .none : .title2)
                }
                .foregroundColor(brick.color == "Black" ? .white : .black)
                .frame(width: geo.size.width)
            }
            .padding()
            .padding(.trailing, 20)
        }
        .background(LinearGradient(gradient: Gradient(colors: [.white, Color(UIColor.getColorByName(brick.color))]), startPoint: .leading, endPoint: .trailing))
        .onAppear(perform: setupScene)
    }
    
    /// Setups SCNScene and camera node
    func setupScene() {
        switch brick.size {
        case "2x4":
            node.position = SCNVector3(0, 5, 40)
        case "1x4":
            node.position = SCNVector3(0, 5, 35)
        case "1x3":
            node.position = SCNVector3(0, 5, 30)
        case "1x1":
            node.position = SCNVector3(0, 5, 25)
        default:
            node.position = SCNVector3(0, 5, 30)
        }
        
        node.camera = SCNCamera()
        
        scene = SCNScene(named: "\(brick.size).usdz")
        
        let obj = scene?.rootNode.childNode(withName: "obj", recursively: true)
        
        obj?.geometry?.firstMaterial?.diffuse.contents = UIColor.getColorByName(brick.color)
        
        let action = SCNAction.repeatForever(SCNAction.rotate(by: .pi, around: SCNVector3(0, 1, 0), duration: 5))
        
        obj?.runAction(action)
    }
}
