//
//  What_a_BrickApp.swift
//  What a Brick
//
//  Created by Kuba Florek on 04/09/2020.
//

import SwiftUI

@main
struct What_a_BrickApp: App {
    var collection = Collection()
    
    @State private var selection = 1
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $selection) {
                ContentView()
                .tabItem {
                    Image(systemName: "viewfinder")
                    Text("Scan")
                }.tag(0)
                
                CollectionView()
                .tabItem {
                    Image(systemName: "shippingbox.fill")
                    Text("Collection")
                }.tag(1)
            }
            .environmentObject(collection)
        }
    }
}
