//
//  CanvasViewController.swift
//  Mrror
//
//  Created by Xavier Francis on 17/08/17.
//  Copyright © 2017 Xavier Francis. All rights reserved.
//

import UIKit

// UIImage extension to create image from UIView.
extension UIImage {
    convenience init(myView: UIView) {
        UIGraphicsBeginImageContextWithOptions(myView.bounds.size, myView.isOpaque, 0.0)
        myView.drawHierarchy(in: myView.bounds, afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage)!)
    }
}

class CanvasViewController: UIViewController, DataEnteredDelegate {

    // MARK: Properties.
    @IBOutlet weak var canvas: UIView!
    
    var start: CGPoint = CGPoint.zero
    var finish: CGPoint = CGPoint.zero
    var customPath: UIBezierPath?
    var layer: CAShapeLayer?
    var lineCap: String = kCALineCapRound
    var lineWidth = CGFloat(3.0)
    var color = UIColor.blue.cgColor
    var shape = Shapes.freeHand
    let shapes = [Shapes.freeHand, Shapes.line, Shapes.oval, Shapes.rectangle, Shapes.square, Shapes.triangle]
    
    // MARK: Overrides.
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showOptionsSegue" {
            let optionsViewController = segue.destination as! OptionsViewController
//            optionsViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext // Allows the canvas to be seen behind the options screen.
            
            var optionsTmp = [String: Any]()
            optionsTmp["LIN"] = lineWidth
            optionsTmp["CLR"] = color
            
            optionsViewController.optionsTmp = optionsTmp
            optionsViewController.delegate = self
        }
    }
    
    @IBAction func shapeSelected(_ sender: UIButton) {
        switch sender.tag {
        case Shapes.freeHand.rawValue:
            shape = Shapes.freeHand
        case Shapes.line.rawValue:
            shape = Shapes.line
        case Shapes.oval.rawValue:
            shape = Shapes.oval
        case Shapes.rectangle.rawValue:
            shape = Shapes.rectangle
        case Shapes.square.rawValue:
            shape = Shapes.square
        case Shapes.triangle.rawValue:
            shape = Shapes.triangle
        default:
            shape = Shapes.freeHand
        }
    }
    
    // MARK: Actions.
    @IBAction func draw(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            customPath = UIBezierPath()
            start = sender.location(in: sender.view)
            layer = CAShapeLayer()
            layer?.fillColor = color
            layer?.lineWidth = lineWidth
            layer?.strokeColor = color
            layer?.lineCap = lineCap
            canvas.layer.addSublayer(layer!)
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
            case .square:
                let translation = sender.translation(in: sender.view)
                layer?.path = Shape().square(startPoint: start, translationPoint: translation).cgPath
            case .rectangle:
                let translation = sender.translation(in: sender.view)
                layer?.path = Shape().rectangle(startPoint: start, translationPoint: translation).cgPath
            case .triangle:
                finish = sender.location(in: sender.view)
                customPath? = UIBezierPath()
                customPath?.move(to: CGPoint(x: start.x, y: start.y))
                customPath?.addLine(to: CGPoint(x: finish.x, y: finish.y))
                customPath?.addLine(to: CGPoint(x: finish.x - ((finish.x - start.x) * 2), y: finish.y))
                customPath?.close()
                layer?.path = customPath?.cgPath
            }
        }
    }
    
    @IBAction func clearCanvasBtnDidClick(_ sender: UIBarButtonItem) {
        let clearAlert = UIAlertController(title: "⚠️", message: "Clear Canvas?", preferredStyle: UIAlertControllerStyle.alert)
        
        let clear = UIAlertAction(title: "Clear", style: .destructive, handler: { (action) in
            self.canvas.layer.sublayers = nil
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        clearAlert.addAction(clear)
        clearAlert.addAction(cancel)
        
        present(clearAlert, animated: true, completion: nil)
    }
    
    @IBAction func saveCanvasBtnDidClick(_ sender: UIBarButtonItem) {
        let saveConfirm = UIAlertController(title: "💩", message: "Save Canvas?", preferredStyle: UIAlertControllerStyle.alert)
        
        let save = UIAlertAction(title: "Save", style: .default, handler: { (action) in
            let img = UIImage.init(myView: self.canvas)
            UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        saveConfirm.addAction(save)
        saveConfirm.addAction(cancel)
        
        present(saveConfirm, animated: true, completion: nil)
    }
    
    @IBAction func unwindToCanvas(segue: UIStoryboardSegue) {
        // Do nothing.
    }
    
    // MARK: Conform to protocol DataEnteredDelegate.
    func optionsModified(to options: [String: Any]) {
        color = options["CLR"] as! CGColor
        lineWidth = options["LIN"] as! CGFloat
    }
}
