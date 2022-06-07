//
//  RSOViewController.swift
//  ExploreUW
//
//  Created by Jerry CH Wu on 6/2/22.
//

import UIKit
import Foundation

class RSO: Codable {
    var name: String!
    var description: String!
    var type: String!
    var email: String!
    
    enum CodingKeys: String, CodingKey {
        case name = "title"
        case type = "rso_type"
        case email = "contact"
        case description
    }
    
    init(name: String, description: String, type: String, email: String) {
        self.name = name
        self.description = description
        self.type = type
        self.email = email
    }
}

class RSOViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    var rsoList = [RSO]()
    var filteredRSO = [RSO]()
    var searchActive : Bool = false
    let mainPath = Bundle.main.url(forResource: "RSOs", withExtension: "json")

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var rsoTable: UITableView!
    @IBOutlet weak var addBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let localData = self.readLocalFile(forName: "RSOs") {
            let parseData = self.parse(jsonData: localData)
            rsoList = parseData!
        }
        rsoTable.dataSource = self
        rsoTable.delegate = self
        searchBar.delegate = self
        filteredRSO = rsoList
    }
    
    private func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.url(forResource: name,
                                                 withExtension: "json"),
               let jsonData = try String(contentsOfFile: bundlePath.path).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        return nil
    }
    
    private func parse(jsonData: Data) -> [RSO]? {
        do {
            let decodedData = try JSONDecoder().decode([RSO].self, from: jsonData) // Should be an array of RSOs
            return decodedData
        } catch {
            print("Decoding error -- returning nothing")
            print(error)
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRSO.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rsoCell = tableView.dequeueReusableCell(withIdentifier: "rsoCell") as! RSOTableViewCell
        let thisRSO = filteredRSO[indexPath.row]
        rsoCell.rsoName.text = thisRSO.name
        rsoCell.rsoType.text = thisRSO.type
        let color = modifyTypeLabelBackground(rsoType: thisRSO.type)
        rsoCell.rsoType.backgroundColor = color
        rsoCell.rsoDescription.text = thisRSO.description
        return rsoCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "rsoSegue", sender: self)
    }
    
    func modifyTypeLabelBackground(rsoType: String) -> UIColor {
        switch rsoType {
        case "Academics":
            return UIColor.blue
        case "Sports":
            return UIColor.red
        case "Cultural":
            return UIColor.systemGreen
        default:
            return UIColor.black
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            filteredRSO = rsoList.filter { // Check names
                $0.name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil ||
                $0.type.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            }
            self.rsoTable.reloadData()
        } else {
            filteredRSO = rsoList
            self.rsoTable.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    @IBAction func unwind( _ seg: UIStoryboardSegue) {
        print("Unwinding Segue")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "rsoSegue" {
            let rsoVC = segue.destination as! RSOPopoverViewController
            let rsoIndex = rsoTable.indexPathForSelectedRow!
            rsoVC.name = filteredRSO[rsoIndex.row].name
            rsoVC.text_description = rsoList[rsoIndex.row].description
            rsoVC.contact = rsoList[rsoIndex.row].email
            self.rsoTable.deselectRow(at: rsoIndex, animated: true)
        }
        if segue.identifier == "addSegue" {
            showAddRSOViewController()
        }
    }
    
    // MARK: Register RSO Functions
    @IBAction func addRSO(_ sender: Any) {
        performSegue(withIdentifier: "addSegue", sender: self)
    }
    
    func showAddRSOViewController() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController else {
            return
        }
        vc.didRegisterRSO = { [weak self] (item) in
            if self != nil {
                self!.rsoList.append(item)
                self!.writeJSON(items: self!.rsoList)
                self!.filteredRSO = self!.rsoList
                self!.rsoTable.reloadData()
            }
        }
        present(vc, animated: true, completion: nil)
    }
    
    private func writeJSON(items: [RSO]) {
        do {
            let encoder = JSONEncoder()
            let encodeData = try encoder.encode(rsoList)
            encoder.outputFormatting = .prettyPrinted
            try encodeData.write(to: mainPath!)
            if let localData = self.readLocalFile(forName: "RSOs") {
                let parseData = self.parse(jsonData: localData)
                print(parseData!.count)
            }
//            let fileURL = try FileManager.default.url(for: .desktopDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("RSOs.json")
//            print(fileURL)
//            let encoder = JSONEncoder()
//            try encoder.encode(items).write(to: fileURL)
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
