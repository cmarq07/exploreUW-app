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
    let documentCopy = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("RSOcopy.json")

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var rsoTable: UITableView!
    @IBOutlet weak var addBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFile(mainPath: mainPath!, subPath: documentCopy)
        rsoTable.dataSource = self
        rsoTable.delegate = self
        searchBar.delegate = self
        filteredRSO = rsoList
    }
    
    // MARK: Read and load files
    func loadFile(mainPath: URL, subPath: URL) {
        if FileManager.default.fileExists(atPath: subPath.path) {
            decodeData(pathName: subPath)
            if rsoList.isEmpty {
                decodeData(pathName: mainPath)
            }
        } else {
            decodeData(pathName: mainPath)
        }
    }
    
    func decodeData(pathName: URL) {
        do {
            let jsonData = try Data(contentsOf: pathName)
            let decoder = JSONDecoder()
            rsoList = try decoder.decode([RSO].self, from: jsonData)
        } catch {
            print(error)
        }
    }
    
    // MARK: Table functions
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
    
    // MARK: Search bar functions

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
                print(self!.rsoList.count)
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
            encoder.outputFormatting = .prettyPrinted
            let encodeData = try encoder.encode(rsoList)
            try encodeData.write(to: documentCopy)
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
