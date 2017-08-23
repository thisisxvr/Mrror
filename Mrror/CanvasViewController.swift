//
//  CanvasViewController.swift
//  Mrror
//
//  Created by Xavier Francis on 17/08/17.
//  Copyright © 2017 Xavier Francis. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController {
    
    var start: CGPoint = CGPoint.zero
    var finish: CGPoint = CGPoint.zero
    var customPath: UIBezierPath?
    var layer: CAShapeLayer?
    var lineCap: String = kCALineCapRound
    var lineWidth = CGFloat(3.0)
    var color = UIColor.blue.cgColor
    var shape = Shapes.freeHand
    let shapes = [Shapes.freeHand, Shapes.line, Shapes.oval, Shapes.rectangle, Shapes.square, Shapes.triangle]
    let stackView = UIStackView()

    @IBOutlet weak var canvas: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(stackView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    @IBAction func showOptionsView(_ sender: UIButton) {
//        // Only apply the blur if the user hasn't disabled transparency effects.
//        if !UIAccessibilityIsReduceTransparencyEnabled() {
//            self.view.backgroundColor = UIColor.clear
//            
//            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
//            let blurEffectView = UIVisualEffectView(effect: blurEffect)
//            blurEffectView.frame = self.view.bounds
//            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//            
//            self.view.addSubview(blurEffectView)
//        } else {
//            self.view.backgroundColor = UIColor.lightGray
//        }
//    }
    
    @IBAction func draw(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            customPath = UIBezierPath()
            start = sender.location(in: sender.view)
            layer = CAShapeLayer()
            layer?.fillColor = color
            layer?.lineWidth = lineWidth
            layer?.strokeColor = color
            layer?.lineCap = lineCap
            self.view.layer.addSublayer(layer!)
            
//            self.view.subviews.first(where: canvas).layer.addSublayer(layer!)
        } else if sender.state == .changed {
            switch shape {
            case .freeHand:
                finish = sender.location(in: sender.view)
                customPath?.move(to: start)
                customPath?.addLine(to: finish)
                start = finish
                customPath?.close()
                layer?.path = customPath?.cgPath
            case .line:
                finish = sender.location(in: sender.view)
                layer?.path = Shape().line(startPoint: start, endPoint: finish).cgPath
            case .oval:
                let translation = sender.translation(in: sender.view)
                layer?.path = Shape().oval(startPoint: start, translationPoint: translation).cgPath
            case .rectangle:
                let translation = sender.translation(in: sender.view)
                layer?.path = Shape().rectangle(startPoint: start, translationPoint: translation).cgPath
            case .triangle:
                finish = sender.location(in: sender.view)
//                    customPath? = UIBezierPath()
                customPath?.move(to: CGPoint(x: start.x, y: start.y))
                customPath?.addLine(to: CGPoint(x: finish.x, y: finish.y))
                customPath?.addLine(to: CGPoint(x: finish.x - ((finish.x - start.x) * 2), y: finish.y))
                customPath?.close()
                layer?.path = customPath?.cgPath
            case .square: break
            }
        }
    }

    @IBAction func shapeDidSelect(_ sender: UIButton) {
        shape = shapes[sender.tag]
    }
    
    // MARK: Unwind Segue
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        // do nothing
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showOptionsSegue" {
            let optionsViewController = segue.destination as! OptionsViewController
            optionsViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext // Allows the canvas to be seen behind the options screen.
            optionsViewController.lineWidthTmp = lineWidth // Sets the line width slider in the Options view to real value.
            optionsViewController.delegate = self
        }
    }
    
    func optionsModified(options: [String: Any]?) {
        if options != nil {
            shape = options?["SHP"] as! Shapes
            color = options?["CLR"] as! CGColor
            lineWidth = options?["LIN"] as! CGFloat
        } else {
            self.stackView.layer.sublayers = nil
        }
        
        let img = UIImage.init(myView: canvas)
        UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
        
//        if let img = stackView.renderToImage() {
//            if let compressData = UIImageJPEGRepresentation(img, 0.9) {
//                if let compressedImage = UIImage(data: compressData) {
//                    UIImageWriteToSavedPhotosAlbum(compressedImage, nil, nil, nil)
//                    print("Image saved.")
//                }
//            } else {
//                print("Returned nil.")
//            }
//        }
    }
}

