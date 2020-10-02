//
//  CollectionView.swift
//  What a Brick
//
//  Created by Kuba Florek on 21/09/2020.
//

import SwiftUI

struct CollectionView: View {
    @EnvironmentObject var collection: Collection
    
    var body: some View {
        NavigationView {
            List {
                ForEach(collection.bricks, id: \.self) { brick in
                    ZStack {
                        ThumbnailView(brick: brick)
                        
                        NavigationLink(destination: DetailedView(brick: brick)) {
                            EmptyView()
                        }
                        .padding(.trailing)
                    }
                    .listRowInsets(EdgeInsets())
                }
                .onDelete(perform: collection.remove)
            }
            .navigationTitle("Collection")
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}
