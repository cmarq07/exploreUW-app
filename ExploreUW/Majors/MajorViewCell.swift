//
//  MajorViewCell.swift
//  ExploreUW
//
//  Created by Christian Marquis Calloway on 6/1/22.
//

import UIKit

class MajorViewCell: UITableViewCell {
    
    // Outlets
    @IBOutlet weak var majorNameLabel: UILabel!
    @IBOutlet weak var majorTypeLabel: UILabel!
    @IBOutlet weak var collegeLabel: UILabel!
    @IBOutlet weak var deptLabel: UILabel!
    @IBOutlet weak var tracksLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Configure the data inside the major cell
    func configureCell(major: Major) {
        // Initialize the major data
        let majorName = major.majorName
        let majorTypeLong = major.majorType
        let college = major.college
        let department = major.department
        let tracks = major.tracks!
        let prerequisites = major.prerequisites
        let hasMinor = major.hasMinor
        
        
        var majorTypeShort = ""
        if(majorTypeLong.contains(" ")) {
            let arr = majorTypeLong.split(separator: " ")
            majorTypeShort = "\(Array(arr[0])[0])\(Array(arr[1])[0])"
            
        } else if(majorTypeLong.contains("-")) {
            let arr = majorTypeLong.split(separator: "-")
            majorTypeShort = "\(Array(arr[0])[0])\(Array(arr[1])[0])"
        }
        
        //var tracksArray: [String] = tracks.components(separatedBy: ", ")
        var trackString = ""
        for track in tracks {
            trackString += track + ", "
        }
        
        self.majorNameLabel.text = majorName
        self.majorTypeLabel.text = majorTypeShort
        self.collegeLabel.text = college
        self.deptLabel.text = department
        self.tracksLabel.text = trackString
    }
    
}
