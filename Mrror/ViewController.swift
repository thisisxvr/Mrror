//
//  ViewController.swift
//  Mrror
//
//  Created by Xavier Francis on 17/08/17.
//  Copyright © 2017 Xavier Francis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var start: CGPoint = CGPoint.zero
    var finish: CGPoint = CGPoint.zero
    var customPath: UIBezierPath?
    var layer: CAShapeLayer?
    var lineCap: String = kCALineCapRound
    var shape = Shapes.freeHand
    let shapes = [Shapes.freeHand, Shapes.line, Shapes.oval, Shapes.rectangle, Shapes.square, Shapes.triangle]

    @IBOutlet weak var canvas: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
    }

    @IBAction func draw(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            customPath = UIBezierPath()
            start = sender.location(in: sender.view)
            layer = CAShapeLayer()
            layer?.fillColor = UIColor.blue.cgColor
            layer?.lineWidth = 1.0
            layer?.strokeColor = UIColor.blue.cgColor
            layer?.lineCap = lineCap
            
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
                    layer?.path = ShapeController().line(startPoint: start, endPoint: finish).cgPath
                case .oval:
                    let translation = sender.translation(in: sender.view)
                    layer?.path = ShapeController().oval(startPoint: start, translationPoint: translation).cgPath
                case .rectangle:
                    let translation = sender.translation(in: sender.view)
                    layer?.path = ShapeController().rectangle(startPoint: start, translationPoint: translation).cgPath
                case .square, .triangle: break
//                    throw Error
            }
        }
    }

    @IBAction func shapeDidSelect(_ sender: UIButton) {
        shape = shapes[sender.tag]
    }
}

