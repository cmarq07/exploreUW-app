//
//  MajorsViewController.swift
//  ExploreUW
//
//  Created by Christian Marquis Calloway on 5/30/22.
//

import UIKit

class MajorsViewController: UIViewController {
    
    var majors: [Major] = []
    
    // Outlets
    @IBOutlet weak var MajorsTable: UITableView!
    
    // MARK: Overriden Functions
    // MARK: ViewWillAppear
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let localData = self.readLocalFile(forName: "Majors") {
            let parseData = self.parse(jsonData: localData)
            majors = parseData!
        }
        // Do any additional setup after loading the view.
        
        // Register the "MajorViewCell" nib file for the TableView
        MajorsTable.register(UINib(nibName: "MajorViewCell", bundle: nil), forCellReuseIdentifier: "majorCell")
        
        // MajorsTable.rowHeight = 400
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
            print(error)
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
    
    // Spacing between majors
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if(section == majors.count) {
            return 0
        } else {
            return 20
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return UIView()
    }
    
    // How many rows should be in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // How many sections there should be (default 1)
    func numberOfSections(in tableView: UITableView) -> Int {
        return majors.count
    }
    
    // Creating the cell data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Try to convert the cell to a "Major" cell
        if let cell = tableView.dequeueReusableCell(withIdentifier: "majorCell", for: indexPath) as?  MajorViewCell {
            
            // Get the current major matching with the data
            let currentMajor = majors[indexPath.section]
            cell.configureCell(major: currentMajor)
            
            // Return the configured cell
            return cell
        }
        // Return a generalized cell if the cell can't be converted to a "Major" cell
        return UITableViewCell()
    }
}
