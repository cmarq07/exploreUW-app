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
    @IBOutlet weak var notesLabel: UILabel!
    
    // MARK: Overriden Functions
    override func awakeFromNib() {
        super.awakeFromNib()
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

        self.majorNameLabel.text = majorName
        self.majorTypeLabel.text = shortcode
        self.collegeLabel.text = college
        self.deptLabel.text = department
        self.tracksLabel.text = tracks
        self.prereqsLabel.attributedText = setPrerequisitesString(prereqs: prerequisites, font: self.prereqsLabel.font)
        self.notesLabel.text = notes
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
                trackString += track + ", "
            }
        }
        
        trackString = String(trackString.dropLast(2))
        trackString = trackString.replacingOccurrences(of: ".", with: ",")
        
        if(tracks == "" || tracks == nil) {
            trackString = "No specific tracks available"
        }
        
        return trackString
    }
    
    private func setPrerequisitesString(prereqs: Prerequisites?, font: UIFont) -> NSMutableAttributedString {
        guard let prereqs = prereqs else {
            return NSMutableAttributedString(string: "No prerequisites required for this major")
        }
        
        let returnString = NSMutableAttributedString()
        
        if let minGpa = prereqs.minGpa {
            returnString.append(attributedText(withString: "Minimum overall GPA of \(minGpa)\n", boldString: "Minimum overall GPA", font: font))
        }
        
        if let applicantLevel = prereqs.applicantLevel {
            returnString.append(attributedText(withString: "Must be a \(applicantLevel)\n", boldString: "baccalaureate", font: font))
        }
        
        return returnString
    }
    
    private func attributedText(withString string: String, boldString: String, font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string,
                                                     attributes: [NSAttributedString.Key.font: font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
        let range = (string as NSString).range(of: boldString)
        attributedString.addAttributes(boldFontAttribute, range: range)
        return attributedString
    }
}
