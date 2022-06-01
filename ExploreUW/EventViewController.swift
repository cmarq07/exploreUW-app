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
        initList()
    }
    
    func initList() {
        // This is hardcoded data before we implement the database
        let event1 = Event(title: "Event 1", date: "Jan 1", description: "Desc 1")
        eventList.append(event1)
        
        let event2 = Event(title: "Event 2", date: "Jan 2", description: "Desc 2")
        eventList.append(event2)
        
        let event3 = Event(title: "Event 3", date: "Jan 3", description: "Desc 3")
        eventList.append(event3)
        
        let event4 = Event(title: "Event 4", date: "Jan 4", description: "Desc 4")
        eventList.append(event4)
        
        let event5 = Event(title: "Event 5", date: "Jan 5", description: "Desc 5")
        eventList.append(event5)
        
        let event6 = Event(title: "Event 6", date: "Jan 6", description: "Desc 6")
        eventList.append(event6)
        
        let event7 = Event(title: "Event 7", date: "Jan 7", description: "Desc 7")
        eventList.append(event7)
        
        let event8 = Event(title: "Event 8", date: "Jan 8", description: "Desc 8")
        eventList.append(event8)
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
