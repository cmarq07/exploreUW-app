//
//  MajorsViewController.swift
//  ExploreUW
//
//  Created by Christian Marquis Calloway on 5/30/22.
//

import UIKit

class MajorsViewController: UIViewController {
    
    // Core Data
    var majors: [Major] = []
    
    // Outlets
    @IBOutlet weak var MajorsTable: UITableView!
    @IBOutlet weak var connectionImage: UIImageView!
    
    // Properties
    let dataUrl = "https://jsonkeeper.com/b/7RD8"
    
    // MARK: Overriden Functions
    // ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Reachability
        // Check if the user can connect to the online JSON data
        let reachability = try! Reachability(hostname: dataUrl)
        
        if(reachability.connection == .wifi || reachability.connection  == .cellular) { // User online
            print("User is online, using online database")
            connectionImage.image = UIImage(systemName: "wifi")
            readOnlineFile()
        } else { // User offline
            print("User is offline, using local JSON data")
            connectionImage.image = UIImage(systemName: "wifi.slash")
            if let localData = self.readLocalFile(forName: "Majors") {
                let parseData = self.parse(jsonData: localData)
                majors = parseData!
            }
        }
        
        
        // Change the MajorsTable corner radius
        MajorsTable.layer.cornerRadius = 10
        
        // Register the "MajorViewCell" nib file for the TableView
        MajorsTable.register(UINib(nibName: "MajorViewCell", bundle: nil), forCellReuseIdentifier: "majorCell")
        
        // Set TableView data source and delegate
        MajorsTable.delegate = self
        MajorsTable.dataSource = self
    }
    
    // Function to read  Local Files
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
    
    // Function to read online Files
    private func readOnlineFile()  {
        var newArr: [Major] = []
        
        URLSession.shared.dataTask(with: URL(string: dataUrl)!) { [weak self] data, response, error in
            // Check if data was returned
            if let data = data {
                // Try to serialize the data as JSON
                do {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.fragmentsAllowed) as? [Any] {
                        
                        for item in json {
                            if let object = item as? [String: Any] {
                                let newMajorObj = Major(majorName: "", majorType: "", college: "", department: nil, tracks: nil, prerequisites: nil, minor: false, notes: nil)
                                // Major Properties
                                let majorName = object["major_name"] as? String ?? nil
                                let majorType = object["major_type"] as? String ?? nil
                                let college = object["college"] as? String ?? nil
                                let department = object["department"] as? String ?? nil
                                let tracks = object["tracks"] as? String ?? nil
                                let notes = object["notes"] as? String ?? nil
                                let prerequisites = object["prerequisites"] as AnyObject
                                let minor = object["minor"] as? Bool ?? false
                                
                                // Prerequsite Properties
                                let newPrereqsObj = Prerequisites(minGpa: nil, minDeptCredits: nil, applicantLevel: nil, minCoreTechnicalCourse: nil, course: nil, requirement: nil, minDeptGpa: nil, courses: nil, minDeptCourse: nil)
                                let minGpa = prerequisites["min_gpa"] as? Double ?? nil
                                let requirement = prerequisites["requirement"] as? String ?? nil
                                let applicantLevel = prerequisites["applicant_level"] as? String ?? nil
                                let minCoreTechnicalCourse = prerequisites["min_core_technical_course"] as? String ?? nil
                                // Complex Prerequisite Properties
                                let newDeptCredit = MinDeptCredits(department: nil, number: nil, minGpa: nil)
                                if let minDeptCredits = prerequisites["min_dept_credits"] as? AnyObject {
                                    let credDept = minDeptCredits["department"] as? String ?? nil
                                    let credNum = minDeptCredits["number"] as? Int ?? nil
                                    let credGpa = minDeptCredits["min_gpa"] as? Double ?? nil
                                    newDeptCredit.department = credDept
                                    newDeptCredit.number = credNum
                                    newDeptCredit.minGpa  = credGpa
                                }
                                let newDeptGpa = MinDeptGpa(dept: nil, gpa: nil)
                                if let minDeptGpa = prerequisites["min_dept_credits"] as? AnyObject {
                                    let gpaDepartment = minDeptGpa["department"] as? String ?? nil
                                    let gpaAmt = minDeptGpa["gpa"] as? Double ?? nil
                                    newDeptGpa.dept = gpaDepartment
                                    newDeptGpa.gpa = gpaAmt
                                }
                                let newDeptCourse = MinDeptCourse(dept: nil, number: nil, minGpa: nil)
                                if let minDeptCourse = prerequisites["min_dept_credits"] as? AnyObject {
                                    let courseDept = prerequisites["department"] as? String ?? nil
                                    let courseNum = prerequisites["number"] as? Int ?? nil
                                    let courseGpa = prerequisites["min_gpa"] as? Double ?? nil
                                    newDeptCourse.minGpa = courseGpa
                                    newDeptCourse.number  = courseNum
                                    newDeptCourse.dept = courseDept
                                }
                                if let courseArr = prerequisites["course"] as? [String] {
                                    newPrereqsObj.course = .stringArray(courseArr)
                                }
                                if let courseObj = prerequisites["course"] as? NSObject {
                                    let objAsArray = courseObj as? [String]
                                    if((objAsArray) == nil) {
                                        let courseName = prerequisites["course_name"] as? String ?? nil
                                        let courseGpa = prerequisites["min_gpa"] as? Double ?? nil
                                        let newCourse = PurpleCourse(courseName: courseName, minGpa:  courseGpa)
                                        newPrereqsObj.course = .purpleCourse(newCourse)
                                    }
                                }
                                
                                if let courses = prerequisites["courses"] as? [[String: Any]] {
                                    for item in courses {
                                        if let thing = item["course"] as? [String] {
                                            newPrereqsObj.course = .stringArray(item["course"] as! [String])
                                        }
                                        print(item["course"] as? [String])
                                        
                                    }
                                }
                                
                                // Append all data to the Prereq Obj
                                newPrereqsObj.minGpa = minGpa
                                newPrereqsObj.minDeptGpa = newDeptGpa
                                newPrereqsObj.minDeptCredits = newDeptCredit
                                newPrereqsObj.minDeptCourse = newDeptCourse
                                newPrereqsObj.minDeptGpa = newDeptGpa
                                newPrereqsObj.applicantLevel = applicantLevel
                                newPrereqsObj.requirement = requirement
                                newPrereqsObj.minCoreTechnicalCourse = minCoreTechnicalCourse
                                
                                // Append all data to the Major
                                newMajorObj.majorName = majorName ?? ""
                                newMajorObj.majorType = majorType ?? ""
                                newMajorObj.college = college ?? ""
                                newMajorObj.department = department
                                newMajorObj.tracks = tracks
                                newMajorObj.prerequisites = newPrereqsObj
                                newMajorObj.minor = minor
                                newMajorObj.notes = notes
                                
                                newArr.append(newMajorObj)
                            }
                        }
                    }
                    
                    
                    
                    // Do stuff on the main thread
                    DispatchQueue.main.async {
                        self!.majors = newArr
                        self!.MajorsTable.reloadData()
                    }
                } catch { // Failed to serialize JSON, return generic empty array
                    print("Error serializing JSON data: \(error)")
                    return
                }
            }
        }.resume() // Successfully read the online file
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
