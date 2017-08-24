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
    func optionsModified(to options: [String: Any])
    func clearCanvas()
    func saveCanvas()
}

class OptionsViewController: UIViewController {
    
    // MARK: Properties.
    @IBOutlet weak var lineWidthSlider: UISlider!
    
    weak var delegate: DataEnteredDelegate? = nil
    var options = [String: Any]() // Options bag: SHP = Shape, LIN = Line width, CLR = Color.
    var optionsTmp = [String: Any]() // Default / previous values.
    
    // MARK: Overrides.
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
            self.view.backgroundColor = UIColor.lightGray
        }
        
        // Sets the line width slider to real value.
        lineWidthSlider.setValue(Float(optionsTmp["LIN"] as! CGFloat), animated: true)
    }
    
    // MARK: Event handlers.
    @IBAction func colorSelected(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            options["CLR"] = UIColor.blue.cgColor
        case 1:
            options["CLR"] = UIColor.red.cgColor
        case 2:
            options["CLR"] = UIColor.yellow.cgColor
        case 3:
            options["CLR"] = UIColor.purple.cgColor
        case 4:
            options["CLR"] = UIColor.green.cgColor
        default:
            options["CLR"] = UIColor.blue.cgColor
        }
    }
    
    @IBAction func lineWidthChanged(_ sender: UISlider) {
        options["LIN"] = CGFloat(sender.value)
    }
    
    @IBAction func shapeSelected(_ sender: UIButton) {
        switch sender.tag {
        case Shapes.freeHand.rawValue:
            options["SHP"] = Shapes.freeHand
        case Shapes.line.rawValue:
            options["SHP"] = Shapes.line
        case Shapes.oval.rawValue:
            options["SHP"] = Shapes.oval
        case Shapes.rectangle.rawValue:
            options["SHP"] = Shapes.rectangle
        case Shapes.square.rawValue:
            options["SHP"] = Shapes.square
        case Shapes.triangle.rawValue:
            options["SHP"] = Shapes.triangle
        default:
            options["SHP"] = Shapes.freeHand
        }
    }

    @IBAction func clearCanvas(_ sender: UIButton) {
        let clearAlert = UIAlertController(title: "⚠️", message: "Clear Canvas?", preferredStyle: UIAlertControllerStyle.alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let clear = UIAlertAction(title: "Clear", style: .destructive, handler: { (action) in
            self.delegate?.clearCanvas()
            self.performSegue(withIdentifier: "unwindToCanvasSegue", sender: self)
            return
        })
        
        clearAlert.addAction(clear)
        clearAlert.addAction(cancel)
        
        present(clearAlert, animated: true, completion: nil)
    }
    
    @IBAction func saveCanvas(_ sender: UIButton) {
        let saveConfirm = UIAlertController(title: "💩", message: "Save Canvas?", preferredStyle: UIAlertControllerStyle.alert)
        
        saveConfirm.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action) in
            self.delegate?.saveCanvas()
            self.performSegue(withIdentifier: "unwindToCanvasSegue", sender: self)
            return
        }))
        
        saveConfirm.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(saveConfirm, animated: true, completion: nil)
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        // Set to previous values if no options were selected.
        if options["SHP"] == nil { options["SHP"] = optionsTmp["SHP"] }
        if options["LIN"] == nil { options["LIN"] = optionsTmp["LIN"] }
        if options["CLR"] == nil { options["CLR"] = optionsTmp["CLR"] }
        
        // Pass options bag back and return to canvas.
        delegate?.optionsModified(to: options)
        performSegue(withIdentifier: "unwindToCanvasSegue", sender: self)
    }
}
