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
        self.title = "Options"
        // Blur the background.
//        if !UIAccessibilityIsReduceTransparencyEnabled() {
//            self.view.backgroundColor = UIColor.clear
//
//            let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.light))
//            blurEffectView.frame = self.view.bounds
//            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//
//            self.view.insertSubview(blurEffectView, at: 0)
//        } else {
//            self.view.backgroundColor = UIColor.lightGray
//        }
        
        // Sets the line width slider to real value.
        lineWidthSlider.setValue(Float(optionsTmp["LIN"] as! CGFloat), animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        // Set to previous values if no options were selected.
        if options["LIN"] == nil { options["LIN"] = optionsTmp["LIN"] }
        if options["CLR"] == nil { options["CLR"] = optionsTmp["CLR"] }
        
        // Pass options bag back and return to canvas.
        delegate?.optionsModified(to: options)
//        performSegue(withIdentifier: "unwindToCanvasSegue", sender: self)
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
}
