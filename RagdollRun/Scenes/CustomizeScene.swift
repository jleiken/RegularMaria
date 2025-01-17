//
//  CustomizeScene.swift
//  RagdollRun
//
//  Created by Jacob Leiken on 5/31/20.
//  Copyright © 2020 Jacob Leiken. All rights reserved.
//

import SpriteKit

class CustomizeScene: MessagesScene {
    
    private static var _staticScene: SKScene?
                
    override func didMove(to view: SKView) {
        CustomizeScene._staticScene = scene
        let topOrBottom = scene!.size.height/2
                
        // set the background and clouds
        scene?.backgroundColor = Formats.BACKGROUND
        addMenuClouds(scene!)
        
        // add a title
        let title = SKLabelNode(text: "Customize your avatar")
        title.fontSize = 28.0
        title.fontColor = Formats.HIGHLIGHT
        title.fontName = Formats.TITLE_FONT
        title.position = CGPoint(x: 0, y: topOrBottom*0.78)
        scene?.addChild(title)
        
        // back button
        let backBut = makeLabel("< Back")
        backBut.fontColor = .black
        backBut.fontSize = 20.0
        backBut.name = SpriteNames.BACK_NAME
        backBut.position = CGPoint(x: -scene!.size.width*3/8, y: topOrBottom - scene!.size.height/20)
        scene?.addChild(backBut)
        
        // coin count indicator
        let coinIndicator = makeLabel("💰 \(CloudVars.coinCount)")
        coinIndicator.name = SpriteNames.CI_NAME
        coinIndicator.fontColor = .black
        coinIndicator.fontSize = 20.0
        coinIndicator.position = CGPoint(x: scene!.size.width*1/3, y: backBut.position.y)
        scene?.addChild(coinIndicator)
        
        // purchase coins section, only shown if the user is authorized for in-app purchases
        if StoreObserver.shared.isAuthorizedForPayments {
            let purchaseLabel = makeLabel("Purchase 💰")
            purchaseLabel.fontColor = Formats.HIGHLIGHT
            purchaseLabel.fontName = Formats.TITLE_FONT
            purchaseLabel.fontSize = title.fontSize
            purchaseLabel.position = CGPoint(x: 0, y: -topOrBottom*0.5)
            scene?.addChild(purchaseLabel)
            
            let y = -topOrBottom*0.64
            var col = 0
            for coins in COIN_OPTIONS {
                let buttonSize = sizeByScene(scene!, xFactor: 0.08, yFactor: 0.045)
                let button = makeRoundedButton(buttonSize)
                button.position = CGPoint(x: xCoordMod3(scene!, col), y: y)
                let name = "\(SpriteNames.COIN_NAME)\(coins)"
                button.name = name
                
                let cLabel = makeLabel("💰\(coins)")
                cLabel.name = name
                cLabel.fontSize = 16.0
                cLabel.position.x = 0
                cLabel.position.y = buttonSize.height/4
                
                // Only if this is a valid transaction should we add it
                if let price = StoreManager.shared.price(matchingIdentifier: name), let symbol = NSLocale.current.currencySymbol {
                    let pLabel = makeLabel("\(symbol)\(price)")
                    pLabel.horizontalAlignmentMode = .center
                    pLabel.name = name
                    pLabel.fontColor = .white
                    pLabel.fontSize = 16.0
                    pLabel.position.x = 0
                    pLabel.position.y = -buttonSize.height/4
                    
                    button.addChild(cLabel)
                    button.addChild(pLabel)
                    scene?.addChild(button)
                    col += 1
                }
            }
        }
        
        // grid of skins that can be unlocked
        makeGrid(scene: scene!)
    }
    
    func makeGrid(scene: SKScene) {
        var xPos = 0, yPos = 1
        for name in STYLES_ORDERING {
            let textures = STYLES[name]!
            if textures.count < 6 {
                print("skipping texture \(name) because it wasn't inited fully")
                continue
            }
            
            // make the sample avatar and add it to a button
            let avatar = makeModelAvatar(scene, name, textures)
            avatar.name = name
            avatar.children.forEach({body in body.name = name})
            var yFactor: CGFloat = 0.1
            if UIDevice.current.userInterfaceIdiom == .pad {
                yFactor = 0.09
            }
            let button = SKSpriteNode(color: .black, size: sizeByScene(scene, xFactor: 0.08, yFactor: yFactor))
            let buttonOffset = CGFloat(yPos)*button.size.height*1.3
            let y = scene.size.height/2 - buttonOffset
            button.position = CGPoint(x: xCoordMod3(scene, xPos), y: y)
            
            // style based on unlock status
            if name == CloudVars.selectedStyle {
                button.color = .darkGray
            } else if !CloudVars.unlockedStyles.contains(name) {
                button.color = .lightGray
                
                // if the button's not unlocked, add a cost indicator below it
                let cost = SKLabelNode(text: "💰\(STYLES_PRICES[name]!)")
                cost.name = name + SpriteNames.CI_NAME
                cost.fontColor = .black
                cost.fontName = Formats.LABEL_FONT
                cost.fontSize = 16.0
                cost.position = CGPoint(x: button.position.x, y: button.position.y - button.size.height*2/3)
                scene.addChild(cost)
            }
            button.name = name
            button.addChild(avatar)
            scene.addChild(button)
            
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
    
    func makeRoundedButton(_ size: CGSize) -> SKShapeNode {
        let buttonPath = CGPath(
            roundedRect: CGRect(origin: CGPoint.zero, size: size),
            cornerWidth: 7,
            cornerHeight: 7,
            transform: nil)
        let button = SKShapeNode(path: buttonPath, centered: true)
        button.strokeColor = .black
        button.fillColor = .black
        
        let shadow = SKShapeNode(path: buttonPath, centered: true)
        shadow.fillColor = Formats.SHADOW_COLOR
        shadow.strokeColor = Formats.SHADOW_COLOR
        shadow.alpha = Formats.SHADOW_ALPHA
        shadow.position = Formats.SHADOW_STANDARD_OFFSET
        shadow.zPosition = -1
        shadow.name = name
        button.addChild(shadow)
        
        return button
    }
    
    func makeModelAvatar(_ scene: SKScene, _ name: String, _ style: [StyleApplicator]) -> SKNode {
        let fullNode = SKNode()
        let torso = SKSpriteNode(color: .white, size: sizeByScene(scene, xFactor: 0.01, yFactor: 0.03))
        style[0](torso)
        fullNode.addChild(torso)
        torso.position = CGPoint(x: 0, y: torso.size.height/3)
        let head = SKSpriteNode(color: .white, size: sizeByScene(scene, xFactor: 0.013, yFactor: 0.013))
        style[1](head)
        fullNode.addChild(head)
        head.position = CGPoint(x: 0, y: torso.size.height)
        let armL = SKSpriteNode(color: .white, size: sizeByScene(scene, xFactor: 0.013, yFactor: 0.007))
        style[2](armL)
        fullNode.addChild(armL)
        armL.position = CGPoint(x: -torso.size.width, y: torso.size.height/2)
        let armR = SKSpriteNode(color: .white, size: sizeByScene(scene, xFactor: 0.013, yFactor: 0.007))
        style[3](armR)
        fullNode.addChild(armR)
        armR.position = CGPoint(x: torso.size.width, y: torso.size.height/2)
        let legL = SKSpriteNode(color: .white, size: sizeByScene(scene, xFactor: 0.007, yFactor: 0.023))
        style[4](legL)
        fullNode.addChild(legL)
        legL.position = CGPoint(x: -torso.size.width/2, y: -torso.size.height/6-legL.size.height/2)
        let legR = SKSpriteNode(color: .white, size: sizeByScene(scene, xFactor: 0.007, yFactor: 0.023))
        style[5](legR)
        fullNode.addChild(legR)
        legR.position = CGPoint(x: torso.size.width/2, y: -torso.size.height/6-legL.size.height/2)
        
        let label = SKLabelNode(text: name)
        label.fontColor = .white
        label.fontName = Formats.LABEL_FONT
        label.fontSize = 16.0
        label.position = CGPoint(x: 0, y: legL.position.y-legL.size.height-8)
        fullNode.addChild(label)
        
        return fullNode
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let pos = touch.location(in: scene!)
            let touchedNode = self.atPoint(pos)

            if touchedNode.name == SpriteNames.BACK_NAME {
                presentScene(
                    view, makeScene(of: MenuScene.self, with: "MenuScene"),
                    transition: SKTransition.fade(withDuration: 0.2))
            } else if let name = touchedNode.name {
                // name must be a button
                // check if it's an in-app puchase button
                if name.contains(SpriteNames.COIN_NAME) {
                    // If it is, submit a request for payment
                    StoreManager.shared.paymentRequest(matchingIdentifier: name)
                } else {
                    // if it's not an in-app purchase button it's a theme button
                    // so set that as the new selection if it's unlocked
                    if CloudVars.unlockedStyles.contains(name) {
                        // set the previously selected button to be black, the new one to be darkGray
                        getButton(ofName: CloudVars.selectedStyle, scene!)?.color = .black
                        CloudVars.selectedStyle = name
                        getButton(ofName: CloudVars.selectedStyle, scene!)?.color = .darkGray
                    } else if let button = getButton(ofName: name, scene!) {
                        // check if we can pay for this, if we can unlock it and activate it
                        if CloudVars.coinCount >= STYLES_PRICES[name]! {
                            // remove the price from the coin count and update the coin count indicator
                            CloudVars.coinCount -= STYLES_PRICES[name]!
                            CustomizeScene.updateCoinCount()
                            // add this as an unlocked style
                            CloudVars.unlockedStyles.append(name)
                            // remove the cost indicator
                            scene?.childNode(withName: name + SpriteNames.CI_NAME)?.removeFromParent()
                            // recursively call this function to do the actual selection
                            touchesEnded(touches, with: event)
                        } else {
                            // not yet unlocked, flash red
                            let prevColor = button.color
                            button.run(SKAction.sequence([
                                SKAction.colorize(with: .red, colorBlendFactor: 1.0, duration: 0.2),
                                SKAction.colorize(with: prevColor, colorBlendFactor: 1.0, duration: 0.2),
                            ]))
                        }
                    }
                }
            }
        }
    }
    
    static func updateCoinCount() {
        if let ciLabel = _staticScene?.childNode(withName: SpriteNames.CI_NAME) as? SKLabelNode {
            ciLabel.text = "💰 \(CloudVars.coinCount)"
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
