//
//  DetailedView.swift
//  What a Brick
//
//  Created by Kuba Florek on 22/09/2020.
//

import SwiftUI
import SceneKit
import Foundation

struct DetailedView: View {
    @Environment(\.openURL) var openURL
    
    let brick: brick
    
    @State private var scene: SCNScene?
    @State private var showQuickLook = false
    
    let node = SCNNode()
    
    var body: some View {
        ZStack {
            ScrollView {
                ScrollViewReader { value in
                    VStack {
                        Color(UIColor.getColorByName(brick.color))
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)
                            .clipShape(CustomCorners(corners: UIDevice.hasNotch() ? [.allCorners] : [.bottomRight, .bottomLeft], size: 25))
                        
                        
                        Button(action: {
                            openURL(URL(string: brick.link.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
                        }) {
                            Image("bricklink")
                                .resizable()
                                .scaledToFit()
                                .padding(5)
                                .roundedRectangleInfoStyle(color: .yellow, isFullSize: true)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .id(1)
                        
                        HStack {
                            Text(brick.size)
                                .roundedRectangleInfoStyle(color: .white, isFullSize: false)
                                .contextMenu {
                                    Text("Size")
                                    
                                    Button(action: {
                                        UIPasteboard.general.string = brick.size
                                    }) {
                                        Text("Copy to clipboard")
                                        Image(systemName: "square.and.arrow.down.on.square")
                                    }
                                }
                            
                            Text(brick.designId)
                                .roundedRectangleInfoStyle(color: .white, isFullSize: false)
                                .contextMenu {
                                    Text("Design ID")
                                    
                                    Button(action: {
                                        UIPasteboard.general.string = brick.designId
                                    }) {
                                        Text("Copy to clipboard")
                                        Image(systemName: "square.and.arrow.down.on.square")
                                    }
                                }
                        }
                        .padding(.horizontal)
                        
                        Text(brick.color)
                            .roundedRectangleInfoStyle(color: .white, isFullSize: true)
                            .contextMenu {
                                Text("Color Name")
                                
                                Button(action: {
                                    UIPasteboard.general.string = brick.color
                                }) {
                                    Text("Copy to clipboard")
                                    Image(systemName: "square.and.arrow.down.on.square")
                                }
                            }
                        
                        Text(brick.colorFamily)
                            .roundedRectangleInfoStyle(color: .white, isFullSize: true)
                            .contextMenu {
                                Text("Color Family")
                                
                                Button(action: {
                                    UIPasteboard.general.string = brick.colorFamily
                                }) {
                                    Text("Copy to clipboard")
                                    Image(systemName: "square.and.arrow.down.on.square")
                                }
                            }
                        
                        HStack {
                            Text(brick.elementId)
                                .roundedRectangleInfoStyle(color: .white, isFullSize: false)
                                .contextMenu {
                                    Text("Element ID")
                                    
                                    Button(action: {
                                        UIPasteboard.general.string = brick.elementId
                                    }) {
                                        Text("Copy to clipboard")
                                        Image(systemName: "square.and.arrow.down.on.square")
                                    }
                                }
                            
                            Text(brick.category)
                                .roundedRectangleInfoStyle(color: .white, isFullSize: false)
                                .contextMenu {
                                    Text("Category")
                                    
                                    Button(action: {
                                        UIPasteboard.general.string = brick.category
                                    }) {
                                        Text("Copy to clipboard")
                                        Image(systemName: "square.and.arrow.down.on.square")
                                    }
                                }
                        }
                        .padding([.horizontal, .bottom])
                    }
                    .onAppear() {
                        value.scrollTo(1, anchor: .center)
                    }
                }
                .animation(.spring())
            }
            
            VStack {
                SceneView(scene: scene, pointOfView: node, options: [.autoenablesDefaultLighting, .allowsCameraControl])
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)
                    .background(Color.white)
                    .clipShape(CustomCorners(corners: [.bottomRight, .bottomLeft], size: 25))
                    .shadow(radius: 10)
                
                Spacer()
            }
        }
        .background(Color(UIColor.getColorByName(brick.color)))
        .navigationBarItems(trailing:
            Button(action: {
                showQuickLook = true
            }) {
                Image(systemName: "arkit")
                    .font(.largeTitle)
            }
        )
        .sheet(isPresented: $showQuickLook) {
            ARView(brick: brick)
        }
        .ignoresSafeArea(.all, edges: .top)
        .statusBar(hidden: true)
        .onAppear(perform: setupScene)
    }
    
    /// Setups SCNScene and camera node
    func setupScene() {
        node.position = SCNVector3(0, 10, 50)
        
        node.camera = SCNCamera()
        
        scene = SCNScene(named: "\(brick.size).usdz")
        
        let obj = scene?.rootNode.childNode(withName: "obj", recursively: true)
        
        obj?.geometry?.firstMaterial?.diffuse.contents = UIColor.getColorByName(brick.color)
    }
}
