//
//  TableViewDetail.swift
//  ExploreUW
//
//  Created by Ryan Oh on 6/1/22.
//

import Foundation
import UIKit

class TableViewDetail: UIViewController {
    
    @IBOutlet weak var detailTitle: UILabel!
    
    @IBOutlet weak var detailDate: UILabel!
    
    @IBOutlet weak var detailDescription: UILabel!
    
    var selectedEvent: Event!
    override func viewDidLoad() {
        super.viewDidLoad()
        detailTitle.text = selectedEvent.title
        detailDate.text = selectedEvent.date
        detailDescription.text = selectedEvent.description
    }
    
}
