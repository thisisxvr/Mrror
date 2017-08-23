//
//  OptionsViewController.swift
//  Mrror
//
//  Created by Xavier Francis on 21/08/17.
//  Copyright © 2017 Xavier Francis. All rights reserved.
//

import UIKit

// Protocol used to send data back to parent ViewController.
protocol DataEnteredDelegate: class {
    func optionsModified(options: [String: Any]?)
}

class OptionsViewController: UIViewController {
    
    @IBOutlet weak var lineWidthSlider: UISlider!
    weak var delegate: DataEnteredDelegate? = nil
    var options: [String: Any]? // Options bag: SHP = Shape, LIN = Line width, CLR = Color.
    var lineWidthTmp: CGFloat = 0.0 // Temporary var to set line width slider to real value.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Blur the background.
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            self.view.backgroundColor = UIColor.clear
            
            let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.light))
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            self.view.insertSubview(blurEffectView, at: 0)
        } else {
            self.view.backgroundColor = UIColor.brown
        }
        
        lineWidthSlider.value = Float(lineWidthTmp)  // Sets the line width slider to real value.
    }
    
    @IBAction func colorSelected(_ sender: UIButton) {
//        switch sender.tag {
//        case 0:
//            options["CLR"] = UIColor.blue.cgColor
//        case 1:
//            options["CLR"] = UIColor.red.cgColor
//        case 2:
//            options["CLR"] = UIColor.yellow.cgColor
//        case 3:
//            options["CLR"] = UIColor.purple.cgColor
//        case 4:
//            options["CLR"] = UIColor.green.cgColor
//        default:
//            options["CLR"] = UIColor.blue.cgColor
//        }
    }
    
    @IBAction func lineWidthChanged(_ sender: UISlider) {
        options?["LIN"] = CGFloat(sender.value)
//        print(options["LIN"]!)
    }
    
    @IBAction func shapeSelected(_ sender: UIButton) {
//        switch sender.tag {
//        case Shapes.freeHand.rawValue:
//            options["SHP"] = Shapes.freeHand
//        case Shapes.line.rawValue:
//            options["SHP"] = Shapes.line
//        case Shapes.oval.rawValue:
//            options["SHP"] = Shapes.oval
//        case Shapes.rectangle.rawValue:
//            options["SHP"] = Shapes.rectangle
//        case Shapes.square.rawValue:
//            options["SHP"] = Shapes.square
//        case Shapes.triangle.rawValue:
//            options["SHP"] = Shapes.triangle
//        default:
//            options["SHP"] = Shapes.freeHand
//        }
    }

    @IBAction func clearCanvas(_ sender: UIButton) {
        let clearAlert = UIAlertController(title: "⚠️", message: "Clear Canvas?", preferredStyle: UIAlertControllerStyle.alert)
        
        clearAlert.addAction(UIAlertAction(title: "Clear", style: .default, handler: { (action) in
//            self.navigationController?.popViewController(animated: true)
//            self.delegate?.optionsModified(options: nil)
//            self.backButton()
            return
        }))
        
        clearAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(clearAlert, animated: true, completion: nil)
    }
    
    @IBAction func saveDrawing(_ sender: UIButton) {
//        self.renderToImage()
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        if options?["LIN"] == nil {
            options?["LIN"] = lineWidthTmp
        }
        
        delegate?.optionsModified(options: options)
        _ = self.navigationController?.popViewController(animated: true)
    }
}
