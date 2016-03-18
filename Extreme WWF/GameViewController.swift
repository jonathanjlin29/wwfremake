//
//  GameViewController.swift
//  asdfasfaf
//
//  Created by Jonathan Lin on 2/11/16.
//  Copyright (c) 2016 Jon Lin. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    var scene:GameScene!
    override func viewDidLoad() {
        super.viewDidLoad()

        if let scene = GameScene(fileNamed:"GameScene") {
            self.scene = scene
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill

            skView.presentScene(scene)
            
            
        }
        else {
            print("View did not load" )
        }
    }
    
    @IBAction func playMove(sender: UIBarButtonItem) {
//        scene.switchPlayersTiles()
    }

    @IBAction func resetTiles(sender: UIBarButtonItem) {
//        scene.resetTiles()
    }
    override func shouldAutorotate() -> Bool {
        return false
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
