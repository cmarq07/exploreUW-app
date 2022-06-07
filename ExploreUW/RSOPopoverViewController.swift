//
//  RSOPopoverViewController.swift
//  ExploreUW
//
//  Created by Jerry CH Wu on 6/6/22.
//

import UIKit

class RSOPopoverViewController: UIViewController {
    
    var name: String = ""
    var text_description: String = ""
    var contact: String = ""

    @IBOutlet weak var rsoName: UILabel!
    @IBOutlet weak var rsoTextDescription: UILabel!
    @IBOutlet weak var rsoContactDetails: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rsoName.text = name
        rsoTextDescription.text = text_description
        rsoContactDetails.text = contact
    }

}
