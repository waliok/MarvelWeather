//
//  SpriteScenes.swift
//  MarvelWeather
//
//  Created by Waliok on 18/04/2023.
//

import SpriteKit

class SnowFall: SKScene {
    override func sceneDidLoad() {
        size = UIScreen.main.bounds.size
        scaleMode = .resizeFill
        anchorPoint = CGPoint(x: 0.5, y: 1)
        backgroundColor = .clear
        let node = SKEmitterNode(fileNamed: "SnowFall.sks")!
        addChild(node)
        node.particlePositionRange.dx = UIScreen.main.bounds.width
    }
}

class SnowFallLanding: SKScene {
    override func sceneDidLoad() {
        size = UIScreen.main.bounds.size
        scaleMode = .resizeFill
        anchorPoint = CGPoint(x: 0.5, y: 1)
        backgroundColor = .clear
        let node = SKEmitterNode(fileNamed: "SnowFallLanding.sks")!
        addChild(node)
        node.particlePositionRange.dx = UIScreen.main.bounds.width - 100
    }
}
