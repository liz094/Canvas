//
//  CanvasViewController.swift
//  canvas
//
//  Created by Lin Zhou on 4/12/17.
//  Copyright © 2017 Lin Zhou. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController {

    @IBOutlet weak var trayView: UIView!
    var trayOriginalCenter: CGPoint!
    var trayDownOffset: CGFloat!
    var trayUp: CGPoint!
    var trayDown: CGPoint!
    
    var newlyCreatedFace: UIImageView!
    var newlyCreatedFaceOriginalCenter: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trayDownOffset = 200
        trayUp = trayView.center
        trayDown = CGPoint(x: trayView.center.x ,y: trayView.center.y + trayDownOffset)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func didPanTray(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: view)
        if sender.state == .began{
            print("Pan Gesture began")
            trayOriginalCenter = trayView.center
            
        }
        else if sender.state == .changed{
            print("Pan gesture is changing")
            //move up and down
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y/10)
        }
        else if sender.state == .ended{
            print("Pan gesture ended")
            //the tray should either snap to the open or closed position, depending on the velocity
            let velocity = sender.velocity(in: view)
            
            //moving up the ending tray motion with a bounce using the damping ratio and initial spring velocity
            if (velocity.y >= 0) {
                UIView.animate(withDuration:0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options:[] ,
                               animations: { () -> Void in
                                self.trayView.center = self.trayDown
                }, completion: nil)
            }
                //moving down
            else{
                UIView.animate(withDuration: 0.4, animations: { 
                    self.trayView.center = self.trayUp
                })
            }
        }
        
    }
    
    func didPanNewFace(sender: UIPanGestureRecognizer){
        let translation = sender.translation(in: view)
        
        if sender.state == .began {
            print("pan new face began")
            newlyCreatedFace = sender.view as! UIImageView
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            UIView.animate(withDuration: 0.2, animations: { 
                self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
            })
        } else if sender.state == .changed {
            print("pan new face is changing")
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        } else if sender.state == .ended {
            print("pan new face ended")
            UIView.animate(withDuration: 0.1, animations: { 
                self.newlyCreatedFace.transform = self.view.transform.scaledBy(x: 1.2, y: 1.2)
            })
        }
    }
    
    @IBAction func didPanFace(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view) // get the translation
        
        if sender.state == .began{
            print("pan face began")
            /* create a new image view that contains the same image as the view that was panned on*/
            let imageView = sender.view as! UIImageView
            newlyCreatedFace = UIImageView(image: imageView.image)
            view.addSubview(newlyCreatedFace) //Add the new face to the main view
            newlyCreatedFace.center = imageView.center
            newlyCreatedFace.center.y += trayView.frame.origin.y  //Since the original face is in the tray, but the new face is in the main view, you have to offset the coordinates

            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPanNewFace(sender:)))
            
            newlyCreatedFace.isUserInteractionEnabled = true
            newlyCreatedFace.addGestureRecognizer(panGestureRecognizer)

            
            //scale up
            UIView.animate(withDuration: 0.2, animations: {
                self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            })
            
        }
        else if sender.state == .changed{
            print("pan face is changing")
            
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
            
        }
        else if sender.state == .ended{
            print("pan face ended")
            UIView.animate(withDuration: 0.1, animations: {
                self.newlyCreatedFace.transform = self.view.transform.scaledBy(x: 1.0, y: 1.0)
            })
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
