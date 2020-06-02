//
//  CustomizeScene.swift
//  RagdollRun
//
//  Created by Jacob Leiken on 5/31/20.
//  Copyright © 2020 Jacob Leiken. All rights reserved.
//

import SpriteKit

class CustomizeScene: SKScene {
            
    override func didMove(to view: SKView) {
        let topOrBottom = scene!.size.height/2
        
        // set the background
        let background = SKSpriteNode(imageNamed: "BackgroundImage")
        background.size = scene!.size
        background.zPosition = -1.0
        scene!.addChild(background)
        
        // add a title
        let title = SKLabelNode(text: "Customize your avatar")
        title.fontSize = 28.0
        title.fontColor = ORANGE
        title.fontName = TITLE_FONT
        title.position = CGPoint(x: 0, y: topOrBottom*2/3)
        scene!.addChild(title)
        
        // back button
        let backBut = makeLabel(text: "< Back")
        backBut.fontColor = .black
        backBut.fontSize = 20.0
        backBut.name = BACK_NAME
        backBut.position = CGPoint(x: -scene!.size.width*3/8, y: topOrBottom - scene!.size.height/15)
        scene!.addChild(backBut)
        
        // coin count indicator
        let coinIndicator = makeLabel(text: "💰 \(coinCount)")
        coinIndicator.fontColor = .black
        coinIndicator.fontSize = 20.0
        coinIndicator.position = CGPoint(x: scene!.size.width*1/3, y: backBut.position.y)
        scene!.addChild(coinIndicator)
        
        // grid of skins that can be unlocked
        makeGrid(scene: scene!, items: STYLES)
    }
    
    func makeGrid(scene: SKScene, items: [String: [StyleApplicator]]) {
        var xPos = 0, yPos = 1
        for (name, textures) in items {
            if textures.count < 6 {
                print("skipping texture \(name) because it wasn't inited fully")
                continue
            }
            let avatar = makeModelAvatar(scene, name, textures)
            avatar.name = name
            avatar.children.forEach({body in body.name = name})
            let button = SKSpriteNode(color: .black, size: sizeByScene(scene, xFactor: 0.08, yFactor: 0.1))
            if name == selectedStyle {
                button.color = .darkGray
            }
            button.name = name
            button.addChild(avatar)
            scene.addChild(button)
            
            let buttonOffset = CGFloat(yPos)*button.size.height*1.3
            let y = scene.size.height/2.5 - buttonOffset
            button.position = CGPoint(x: xCoordMod3(scene, xPos), y: y)
            xPos += 1
            // increment the row if we've finished the current one
            if xPos % 3 == 0 {
                yPos += 1
            }
        }
    }
    
    func xCoordMod3(_ scene: SKScene, _ xPos: Int) -> CGFloat {
        let modVal = xPos % 3
        switch modVal {
        case 0:
            return -scene.size.width / 3
        case 1:
            return 0
        case 2:
            return scene.size.width / 3
        default:
            return 0
        }
    }
    
    func makeModelAvatar(_ scene: SKScene, _ name: String, _ style: [StyleApplicator]) -> SKNode {
        let fullNode = SKNode()
        let torso = SKSpriteNode(color: .white, size: sizeByScene(scene, xFactor: 0.01, yFactor: 0.04))
        style[0](torso)
        fullNode.addChild(torso)
        torso.position = CGPoint(x: 0, y: torso.size.height/3)
        let head = SKSpriteNode(color: .white, size: sizeByScene(scene, xFactor: 0.013, yFactor: 0.013))
        style[1](head)
        fullNode.addChild(head)
        head.position = CGPoint(x: 0, y: torso.size.height*2/3)
        let armL = SKSpriteNode(color: .white, size: sizeByScene(scene, xFactor: 0.013, yFactor: 0.007))
        style[2](armL)
        fullNode.addChild(armL)
        armL.position = CGPoint(x: -torso.size.width*3/4, y: torso.size.height/3)
        let armR = SKSpriteNode(color: .white, size: sizeByScene(scene, xFactor: 0.013, yFactor: 0.007))
        style[3](armR)
        fullNode.addChild(armR)
        armR.position = CGPoint(x: torso.size.width*3/4, y: torso.size.height/3)
        let legL = SKSpriteNode(color: .white, size: sizeByScene(scene, xFactor: 0.007, yFactor: 0.023))
        style[4](legL)
        fullNode.addChild(legL)
        legL.position = CGPoint(x: -torso.size.width/2, y: -torso.size.height/3)
        let legR = SKSpriteNode(color: .white, size: sizeByScene(scene, xFactor: 0.007, yFactor: 0.023))
        style[5](legR)
        fullNode.addChild(legR)
        legR.position = CGPoint(x: torso.size.width/2, y: -torso.size.height/3)
        
        let label = SKLabelNode(text: name)
        label.fontColor = .white
        label.fontName = LABEL_FONT
        label.fontSize = 16.0
        label.position = CGPoint(x: 0, y: -torso.size.height)
        fullNode.addChild(label)
        
        return fullNode
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let pos = touch.location(in: scene!)
            let touchedNode = self.atPoint(pos)

            if touchedNode.name == BACK_NAME {
                view?.presentScene(
                    MenuScene(fileNamed: "MenuScene")!,
                    transition: SKTransition.fade(withDuration: 0.2))
            } else if let name = touchedNode.name {
                // name must be a button, which is a texture, so set that as the new selection
                // set the previously selected button to be black, the new one to be darkGray
                getButton(ofName: selectedStyle, scene!)?.color = .black
                selectedStyle = name
                getButton(ofName: selectedStyle, scene!)?.color = .darkGray
            }
        }
    }
    
    /// gets the first child of scene with name ofName and tries to cast it to an SKSpriteNode. nil with any exceptions
    func getButton(ofName: String, _ scene: SKScene) -> SKSpriteNode? {
        let index = scene.children.firstIndex(where: { $0.name == ofName })
        if let i = index {
            return scene.children[i] as? SKSpriteNode
        }
        return nil
    }
}