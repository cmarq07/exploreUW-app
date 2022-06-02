//
//  MajorsViewController.swift
//  ExploreUW
//
//  Created by Christian Marquis Calloway on 5/30/22.
//

import UIKit

class MajorsViewController: UIViewController {
    
    // Data
    //var major = Major(majorName: "Informatics", majorType: "Capacity-Constrained", college: "Information School", department: nil, tracks: ["Biomedical and Health Informatics", "Data Science", "Human-Computer Interaction", "Information Architecture", "Information Assurance and Cybersecurity", "Custom Track"], prerequisites: nil, hasMinor: true, notes: nil)
    var majors: [Major] = []
    
    // Outlets
    @IBOutlet weak var MajorsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let localData = self.readLocalFile(forName: "Majors") {
            let parseData = self.parse(jsonData: localData)
            majors = parseData!
        }
        //data.append(major)
        // Do any additional setup after loading the view.
        
        // Register the "MajorViewCell" nib file for the TableView
        MajorsTable.register(UINib(nibName: "MajorViewCell", bundle: nil), forCellReuseIdentifier: "majorCell")
        
        // Set TableView data source and delegate
        MajorsTable.delegate = self
        MajorsTable.dataSource = self
    }
    
    // Function to read the Local Files
    private func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name,
                                                 ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
    }
    
    // Function to parse the json data read from the file
    private func parse(jsonData: Data) -> [Major]? {
        do {
            let decodedData = try JSONDecoder().decode([Major].self, from: jsonData) // Should be an array of majors
            return decodedData
        } catch {
            print("Decoding error -- returning nothing")
            return nil
        }
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
        return majors.count
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
//            let currentMajor = data[indexPath.row]
//            cell.configureCell(majors: currentMajor)

            // Return the configured cell
            return cell
        }
        // Return a generalized cell if the cell can't be converted to a "Major" cell
        return UITableViewCell()
    }
}
