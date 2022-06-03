//
//  EventViewController.swift
//  ExploreUW
//
//  Created by Ryan Oh on 6/1/22.
//

import UIKit

class EventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var eventTableView: UITableView!
    var eventList = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let localData = self.readLocalFile(forName: "Events") {
            let parseData = self.parse(jsonData: localData)
            eventList = parseData!
        }
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
    private func parse(jsonData: Data) -> [Event]? {
        do {
            let decodedData = try JSONDecoder().decode([Event].self, from: jsonData) // Should be an array of majors
            return decodedData
        } catch {
            print("Decoding error -- returning nothing")
            print(error)
            return nil
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "tableViewCellID") as! TableViewCell
        
        let thisEvent = eventList[indexPath.row]
        
        tableViewCell.eventTitle.text = thisEvent.title
        tableViewCell.eventDate.text = thisEvent.date
        
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detailSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detailSegue") {
            let indexPath = self.eventTableView.indexPathForSelectedRow!
            let tableViewDetail = segue.destination as? TableViewDetail
            let selectedEvent = eventList[indexPath.row]
            tableViewDetail?.selectedEvent = selectedEvent
            self.eventTableView.deselectRow(at: indexPath, animated: true)
            
            
        }
    }
    


}
