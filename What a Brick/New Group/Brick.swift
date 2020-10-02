//
//  Brick.swift
//  What a Brick
//
//  Created by Kuba Florek on 19/09/2020.
//

import SwiftUI

struct brick: Codable, Hashable {
    let size: String
    let color: String
    let colorFamily: String
    let category: String
    let elementId: String
    let designId: String
    let link: String
}

class Collection: ObservableObject {
    @Published private(set) var bricks: [brick]
    static let saveKey = "savedData"

    init() {
        if let data = UserDefaults.standard.data(forKey: Self.saveKey) {
            if let decoded = try? JSONDecoder().decode([brick].self, from: data) {
                self.bricks = decoded
                return
            }
        }

        self.bricks = []
    }
    
    func add(colorName: String, brickSize: String) {
        let allBricks: [brick] = Bundle.main.decode([brick].self, from: "bricks.json")
        
        let filtered = allBricks.filter {
            $0.color == colorName && $0.size == brickSize
        }
        
        bricks += filtered
        
        save()
    }
    
    private func save() {
        if let encoded = try? JSONEncoder().encode(bricks) {
            UserDefaults.standard.set(encoded, forKey: Self.saveKey)
        }
    }
    
    func remove(at offsets: IndexSet) {
        bricks.remove(atOffsets: offsets)
        save()
    }
}
