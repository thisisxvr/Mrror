//
//  OptionsViewController.swift
//  Mrror
//
//  Created by Xavier Francis on 21/08/17.
//  Copyright © 2017 Xavier Francis. All rights reserved.
//

import UIKit

// protocol used for sending data back
protocol DataEnteredDelegate: class {
    func optionsModified(args: [Int])
}

class OptionsViewController: UIViewController {
    
    // making this a weak variable so that it won't create a strong reference cycle
    weak var delegate: DataEnteredDelegate? = nil
    
    @IBAction func shapeSelected(_ sender: UIButton) {
    }

    @IBAction func backButton(_ sender: UIButton) {
        // call this method on whichever class implements our delegate protocol
        delegate?.optionsModified(args: arguments!)
        
        // go back to the previous view controller
        self.navigationController?.popViewController(animated: true)
    }
}
