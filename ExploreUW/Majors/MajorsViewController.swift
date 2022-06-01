//
//  MajorsViewController.swift
//  ExploreUW
//
//  Created by Christian Marquis Calloway on 5/30/22.
//

import UIKit
import Foundation

// Major Class
class Major {
    
    // Properties
    var majorName: String
    var majorType: String
    var college: String
    var department: String?
    var tracks: [String]?
    var prerequisites: AnyObject?
    var hasMinor: Bool
    var notes: String?
    
    init() {
        self.majorName = ""
        self.majorType = ""
        self.college = ""
        self.department = ""
        self.hasMinor = false
    }
    
    init(majorName: String, majorType: String, college: String, department: String?, tracks: [String]?, prerequisites: AnyObject?, hasMinor: Bool, notes: String?) {
        self.majorName = majorName
        self.majorType = majorType
        self.college = college
        self.department = department
        self.tracks = tracks
        self.prerequisites = prerequisites
        self.hasMinor = hasMinor
        self.notes = notes
    }
}

class MajorsViewController: UIViewController {
    
    // Data
    var major1 = Major(majorName: "Informatics", majorType: "Capacity-Constrained", college: "Information School", department: nil, tracks: [], prerequisites: nil, hasMinor: true, notes: nil)
    var data: [Major] = []
    
    // Outlets
    @IBOutlet weak var MajorsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tracksString = "Biomedical and Health Informatics, Data Science, Human-Computer Interaction, Information Architecture, Information Assurance and Cybersecurity, Custom Track"
        let tracksArray = tracksString.components(separatedBy: ", ")
        major1.tracks = tracksArray
        
        data.append(major1)
        // Do any additional setup after loading the view.
        
        // Register the "MajorViewCell" nib file for the TableView
        MajorsTable.register(UINib(nibName: "MajorViewCell", bundle: nil), forCellReuseIdentifier: "majorCell")
        
        // Set TableView data source and delegate
        MajorsTable.delegate = self
        MajorsTable.dataSource = self
    }
}

extension MajorsViewController: UITableViewDelegate {
    
    // Occur on table view cell press
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: Make something happen
    }
}

extension MajorsViewController: UITableViewDataSource {
    
    // How many rows should be in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    // How many sections there should be (default 1)
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Creating the cell data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Try to convert the cell to a "Major" cell
        if let cell = tableView.dequeueReusableCell(withIdentifier: "majorCell", for: indexPath) as?  MajorViewCell {
            
            // Get the current major matching with the data
            let currentMajor = data[indexPath.row]
            cell.configureCell(major: currentMajor)

            // Return the configured cell
            return cell
        }
        // Return a generalized cell if the cell can't be converted to a "Major" cell
        return UITableViewCell()
    }
}
