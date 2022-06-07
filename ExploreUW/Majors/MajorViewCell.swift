//
//  MajorViewCell.swift
//  ExploreUW
//
//  Created by Christian Marquis Calloway on 6/1/22.
//

import UIKit

// MARK: MajorViewCell
class MajorViewCell: UITableViewCell {
    
    // MARK: Outlets
    @IBOutlet weak var majorNameLabel: UILabel!
    @IBOutlet weak var majorTypeLabel: UILabel!
    @IBOutlet weak var collegeLabel: UILabel!
    @IBOutlet weak var deptLabel: UILabel!
    @IBOutlet weak var tracksLabel: UILabel!
    @IBOutlet weak var prereqsLabel: UILabel!
    @IBOutlet weak var notesTitle: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    
    // MARK: Overriden Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK: - ConfigureCell
    // Configure the data inside the major cell
    func configureCell(major: Major) {
        // Initialize the major data
        let majorName = major.majorName
        let majorTypeLong = major.majorType
        let college = major.college
        let department = major.department
        let tracks = setTracksString(tracks: major.tracks)
        let prerequisites = major.prerequisites
        let hasMinor = major.minor
        let shortcode = setMajorTypeShortcode(majorType: majorTypeLong)
        let notes = major.notes
        
        majorNameLabel.text = majorName
        if(hasMinor) {
            majorNameLabel.text! += "*"
        }
        majorTypeLabel.text = shortcode
        collegeLabel.text = college
        deptLabel.text = department
        tracksLabel.text = tracks
        prereqsLabel.attributedText = setPrerequisitesString(prereqs: prerequisites)
        notesLabel.text = notes?.replacingOccurrences(of: "--", with: "\n")
    }
    
    private func setMajorTypeShortcode(majorType: String) -> String {
        var majorTypeShort = ""
        if(majorType.contains(" ")) {
            let arr = majorType.split(separator: " ")
            majorTypeShort = "\(Array(arr[0])[0])\(Array(arr[1])[0])"
            
        } else if(majorType.contains("-")) {
            let arr = majorType.split(separator: "-")
            majorTypeShort = "\(Array(arr[0])[0])\(Array(arr[1])[0])"
        }
        
        return majorTypeShort
    }
    
    private func setTracksString(tracks: String?) -> String {
        var trackString = ""
        if(tracks != nil) {
            let tracksArray = tracks!.components(separatedBy: ", ")
            for track in tracksArray {
                // Comma separated version
                // trackString += track + ", "
                trackString += track + "\n"
            }
        }
        
        trackString = String(trackString.dropLast(1))
        trackString = trackString.replacingOccurrences(of: ".", with: ",")
        
        if(tracks == "" || tracks == nil) {
            trackString = "No specific tracks available"
        }
        
        return trackString
    }
    
    // Set the prerequisite string
    private func setPrerequisitesString(prereqs: Prerequisites?) -> NSAttributedString {
        
        // MARK: Base Cases
        guard let prereqs = prereqs else {
            return NSMutableAttributedString(string: "No prerequisites required for this major")
        }
        guard let boldFont = UIFont(name: "Open Sans Semibold", size: 16.0) else {
            return NSMutableAttributedString(string: "No prerequisites required for this major")
        }
        
        // MARK: Set Properties
        let boldAttributes = [
            NSAttributedString.Key.font : boldFont
        ]
        let newLine = NSAttributedString(string: "\n")
        let returnString = NSMutableAttributedString()
        
        // MARK: MinGPA
        if let minGpa = prereqs.minGpa {
            let boldString1 = NSAttributedString(string: "Minimum overall GPA", attributes: boldAttributes)
            let string = NSAttributedString(string: " of ")
            let boldString2 = NSAttributedString(string: "\(minGpa)", attributes: boldAttributes)
            returnString.append(attributedText([boldString1, string, boldString2, newLine]))
        }
        
        // MARK: ApplicantLevel
        if let applicantLevel = prereqs.applicantLevel {
            let string = NSAttributedString(string: "Must be a ")
            let boldString = NSAttributedString(string: "\(applicantLevel)", attributes: boldAttributes)
            returnString.append(attributedText([string, boldString, newLine]))
        }
        
        // MARK: Course (Singular)
        if let course = prereqs.course {
            if case let .stringArray(s) = course {
                let isOptional = true
                if(s.count == 1) {
                    let string = NSAttributedString(string: "Must take ")
                    let boldString = NSAttributedString(string: "\(s[0])", attributes: boldAttributes)
                    returnString.append(attributedText([string, boldString, newLine]))
                } else {
                    let result = createListString(withElements: s, isOptional: isOptional)
                    let string = NSAttributedString(string: "Must take one of ")
                    let boldString = NSAttributedString(string: "\(result)", attributes: boldAttributes)
                    returnString.append(attributedText([string, boldString, newLine]))
                }
            }
            
            if case let .purpleCourse(c) = course {
                let string1 = NSAttributedString(string: "Must take ")
                let boldString1 = NSAttributedString(string: "\(c.courseName)", attributes: boldAttributes)
                let string2 = NSAttributedString(string: " with a minimum grade of ")
                let boldString2 = NSAttributedString(string: "\(c.minGpa)", attributes: boldAttributes)
                returnString.append(attributedText([string1, boldString1, string2, boldString2, newLine]))
            }
        }
        
        // MARK: Course (Multiple)
        if let courses = prereqs.courses {
            if case let .coursesClass(courses) = courses {
                let string1 = NSAttributedString(string: "Must take ")
                let string2 = NSAttributedString(string: " with a minimum grade of ")
                let string3 = NSAttributedString(string: " in each course")
                let boldString1 = NSAttributedString(string: "\(createListString(withElements: courses.courses, isOptional: false))", attributes: boldAttributes)
                let boldString2 = NSAttributedString(string: "\(courses.minGpa)", attributes: boldAttributes)
                
                returnString.append(attributedText([string1, boldString1, string2, boldString2, string3, newLine]))
            }
            
            if case let .unionArray(coursesArr) = courses {
                for course in coursesArr {
                    // Detailed Course
                    if case let .fluffyCourse(c) = course {
                        if let course = c.course {
                            if case let .stringArray(s) = course {
                                print("StringArray: \(s)\n")
                                
                                if let minGpa = c.minGpa {
                                    let string1 = NSAttributedString(string: "Must take one of ")
                                    let string2 = NSAttributedString(string: " with a minimum grade of ")
                                    let string3 = NSAttributedString(string: " in that course")
                                    let boldString1 = NSAttributedString(string: "\(createListString(withElements: s, isOptional: true))", attributes: boldAttributes)
                                    let boldString2 = NSAttributedString(string: "\(minGpa)", attributes: boldAttributes)
                                    
                                    returnString.append(attributedText([string1, boldString1, string2, boldString2, string3, newLine]))
                                } else {
                                    let result = createListString(withElements: s, isOptional: true)
                                    let string = NSAttributedString(string: "Must take one of ")
                                    let boldString = NSAttributedString(string: "\(result)", attributes: boldAttributes)
                                    returnString.append(attributedText([string, boldString, newLine]))
                                }
                            }
                            
                            if case let .string(s) = course {
                                print("String: \(s)\n")
                                if let minGpa = c.minGpa {
                                    let string1 = NSAttributedString(string: "Must take ")
                                    let string2 = NSAttributedString(string: " with a minimum grade of ")
                                    let boldString1 = NSAttributedString(string: "\(s)", attributes: boldAttributes)
                                    let boldString2 = NSAttributedString(string: "\(minGpa)", attributes: boldAttributes)
                                    
                                    returnString.append(attributedText([string1, boldString1, string2, boldString2, newLine]))
                                } else {
                                    let string = NSAttributedString(string: "Must take ")
                                    let boldString = NSAttributedString(string: "\(s)", attributes: boldAttributes)
                                    returnString.append(attributedText([string, boldString, newLine]))
                                }
                            }
                        }
                        
                        if let coursesArray = c.courses {
                            print("Courses Array: \(coursesArray)\n")
                            
                            if let minGpa = c.minGpa {
                                let string1 = NSAttributedString(string: "Must take ")
                                let string2 = NSAttributedString(string: " with a minimum grade of ")
                                let string3 = NSAttributedString(string: " in each course")
                                let boldString1 = NSAttributedString(string: "\(createListString(withElements: coursesArray, isOptional: false))", attributes: boldAttributes)
                                let boldString2 = NSAttributedString(string: "\(minGpa)", attributes: boldAttributes)
                                
                                returnString.append(attributedText([string1, boldString1, string2, boldString2, string3, newLine]))
                            } else {
                            let result = createListString(withElements: coursesArray, isOptional: false)
                            let string = NSAttributedString(string: "Must take ")
                            let boldString = NSAttributedString(string: "\(result)", attributes: boldAttributes)
                            
                            returnString.append(attributedText([string, boldString, newLine]))
                            }
                        }
                        
                        if let reqs = c.requirements {
                            print("\(reqs)\n")
                            
                            let string = NSAttributedString(string: "Requires ")
                            let boldString = NSAttributedString(string: "\(createListString(withElements: reqs, isOptional: false))", attributes: boldAttributes)
                            
                            returnString.append(attributedText([string, boldString, newLine]))
                        }
                    }
                    
                    // String Course
                    if case let .string(s) = course {
                        let string = NSAttributedString(string: "Must take ")
                        let boldString = NSAttributedString(string: "\(s)", attributes: boldAttributes)
                        returnString.append(attributedText([string, boldString, newLine]))
                    }
                }
                print("================================")
            }
        }
        
        // MARK: Outside
        
        return returnString.trimmedAttributedString()
    }
    
    // MARK: Attributed Text
    private func attributedText(withString string: String, boldString: String, font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string,
                                                         attributes: [NSAttributedString.Key.font: font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
        let range = (string as NSString).range(of: boldString)
        attributedString.addAttributes(boldFontAttribute, range: range)
        return attributedString
    }
    
    private func attributedText(_ strings: [NSAttributedString]) -> NSAttributedString {
        let ret = NSMutableAttributedString()
        for string in strings {
            ret.append(string)
        }
        
        return ret
    }
    
    // MARK: CreateListString
    private func createListString(withElements elements: [String], isOptional optional: Bool) -> String {
        var returnString = ""
        
        let optionalString = optional ? "or" : "and"
        
        // MARK: Base Cases
        if(elements.count == 1) {
            return elements[0]
        } else if(elements.count == 2) {
            return "\(elements[0]) \(optionalString) \(elements[1])"
        }
        
        for i in 0..<elements.count - 1 {
            returnString += elements[i] + ", "
        }
        
        returnString += "\(optionalString) \(elements[elements.count - 1])"
        
        return returnString
    }
}

extension NSMutableAttributedString {
    
    func trimmedAttributedString() -> NSAttributedString {
        let invertedSet = CharacterSet.whitespacesAndNewlines.inverted
        let startRange = string.rangeOfCharacter(from: invertedSet)
        let endRange = string.rangeOfCharacter(from: invertedSet, options: .backwards)
        guard let startLocation = startRange?.upperBound, let endLocation = endRange?.lowerBound else {
            return NSAttributedString(string: string)
        }
        let location = string.distance(from: string.startIndex, to: startLocation) - 1
        let length = string.distance(from: startLocation, to: endLocation) + 2
        let range = NSRange(location: location, length: length)
        return attributedSubstring(from: range)
    }
}
