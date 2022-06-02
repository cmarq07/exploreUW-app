//
//  MajorClass.swift
//  ExploreUW
//
//  Created by Christian Marquis Calloway on 6/2/22.
//

import Foundation

// MARK: - MajorElement
class MajorElement: Codable {
    let majorName: String
    let majorType: String
    let college: String
    let department: String?
    let tracks: String?
    let prerequisites: Prerequisites?
    let minor: Bool
    let notes: String?

    enum CodingKeys: String, CodingKey {
        case majorName = "major_name"
        case majorType = "major_type"
        case college, department, tracks, prerequisites, minor, notes
    }

    init(majorName: String, majorType: String, college: String, department: String?, tracks: String?, prerequisites: Prerequisites?, minor: Bool, notes: String?) {
        self.majorName = majorName
        self.majorType = majorType
        self.college = college
        self.department = department
        self.tracks = tracks
        self.prerequisites = prerequisites
        self.minor = minor
        self.notes = notes
    }
}

enum College: String, Codable {
    case artsAndSciences = "Arts and Sciences"
    case collegeOfBuiltEnvironments = "College of Built Environments"
    case collegeOfEducation = "College of Education"
    case collegeOfEngineering = "College of Engineering"
    case informationSchool = "Information School"
}

enum Department: String, Codable {
    case arts = "Arts"
    case humanities = "Humanities"
    case naturalSciences = "Natural Sciences"
    case socialSciences = "Social Sciences"
}

enum MajorType: String, Codable {
    case capacityConstrained = "Capacity-Constrained"
    case minimumRequirement = "Minimum Requirement"
    case openMajor = "Open Major"
}

// MARK: - Prerequisites
class Prerequisites: Codable {
    let minGpa: Double?
    let minArtCredits: MinArtCreditsUnion?
    let applicantLevel: String?
    let minCoreDanceCredits: Int?
    let minCoreTechnicalCourse: String?
    let course: CourseUnion?
    let requirement: String?
    let minEnglishGpa: Int?
    let minGeogCourse: MinGeogCourse?

    enum CodingKeys: String, CodingKey {
        case minGpa = "min_gpa"
        case minArtCredits = "min_art_credits"
        case applicantLevel = "applicant_level"
        case minCoreDanceCredits = "min_core_dance_credits"
        case minCoreTechnicalCourse = "min_core_technical_course"
        case course, requirement
        case minEnglishGpa = "min_english_gpa"
        case minGeogCourse = "min_geog_course"
    }

    init(minGpa: Double?, minArtCredits: MinArtCreditsUnion?, applicantLevel: String?, minCoreDanceCredits: Int?, minCoreTechnicalCourse: String?, course: CourseUnion?, requirement: String?, minEnglishGpa: Int?, minGeogCourse: MinGeogCourse?) {
        self.minGpa = minGpa
        self.minArtCredits = minArtCredits
        self.applicantLevel = applicantLevel
        self.minCoreDanceCredits = minCoreDanceCredits
        self.minCoreTechnicalCourse = minCoreTechnicalCourse
        self.course = course
        self.requirement = requirement
        self.minEnglishGpa = minEnglishGpa
        self.minGeogCourse = minGeogCourse
    }
}

enum CourseUnion: Codable {
    case courseClass(CourseClass)
    case stringArray([String])

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([String].self) {
            self = .stringArray(x)
            return
        }
        if let x = try? container.decode(CourseClass.self) {
            self = .courseClass(x)
            return
        }
        throw DecodingError.typeMismatch(CourseUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for CourseUnion"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .courseClass(let x):
            try container.encode(x)
        case .stringArray(let x):
            try container.encode(x)
        }
    }
}

// MARK: - CourseClass
class CourseClass: Codable {
    let courseName: String
    let minGpa: Int

    enum CodingKeys: String, CodingKey {
        case courseName = "course_name"
        case minGpa = "min_gpa"
    }

    init(courseName: String, minGpa: Int) {
        self.courseName = courseName
        self.minGpa = minGpa
    }
}

enum MinArtCreditsUnion: Codable {
    case integer(Int)
    case minArtCreditsClass(MinArtCreditsClass)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(MinArtCreditsClass.self) {
            self = .minArtCreditsClass(x)
            return
        }
        throw DecodingError.typeMismatch(MinArtCreditsUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for MinArtCreditsUnion"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .minArtCreditsClass(let x):
            try container.encode(x)
        }
    }
}

// MARK: - MinArtCreditsClass
class MinArtCreditsClass: Codable {
    let number: Int
    let minGpa: Double

    enum CodingKeys: String, CodingKey {
        case number
        case minGpa = "min_gpa"
    }

    init(number: Int, minGpa: Double) {
        self.number = number
        self.minGpa = minGpa
    }
}

// MARK: - MinGeogCourse
class MinGeogCourse: Codable {
    let number: String
    let minGpa: Int

    enum CodingKeys: String, CodingKey {
        case number
        case minGpa = "min_gpa"
    }

    init(number: String, minGpa: Int) {
        self.number = number
        self.minGpa = minGpa
    }
}

typealias Major = MajorElement

// Major Class
/* class Major: Codable {
    
    // Properties
    var majorName: String
    var majorType: String
    var college: String
    var department: String?
    var tracks: [String]?
    var prerequisites: AnyObject?
    var hasMinor: Bool
    var notes: String?
    
    private enum CodingKeys: String, CodingKey {
        case majorName
        case majorType
        case college
        case department
        case tracks
        case prerequisites
        case hasMinor
        case notes
    }
    
    init() {
        self.majorName = ""
        self.majorType = ""
        self.college = ""
        self.department = ""
        self.hasMinor = false
    }
    
    init(majorName: String, majorType: String, college: String, department: String?, tracks: [String]?, prerequisites: AnyObject?, hasMinor: Bool, notes: String?) {
        self.majorName = majorName
        self.majorType = majorType
        self.college = college
        self.department = department
        self.tracks = tracks
        self.prerequisites = prerequisites
        self.hasMinor = hasMinor
        self.notes = notes
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(majorName, forKey: .majorName)
        try container.encode(majorName, forKey: .majorType)
        try container.encode(majorName, forKey: .college)
        try container.encode(majorName, forKey: .department)
        try container.encode(majorName, forKey: .tracks)
        try container.encode(majorName, forKey: .prerequisites)
        try container.encode(majorName, forKey: .hasMinor)
        try container.encode(majorName, forKey: .notes)
        
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        majorName = try values.decode(String.self, forKey: .majorName)
        majorType = try values.decode(String.self, forKey: .majorType)
        college = try values.decode(String.self, forKey: .college)
        department = try values.decode(String.self, forKey: .department)
        tracks = try values.decode([String].self, forKey: .tracks)
        hasMinor = try values.decode(Bool.self, forKey: .hasMinor)
        notes = try values.decode(String.self, forKey: .notes)
    }
}

class Majors: Codable {
    
    // Properties
    var majors: [Major]
    
    init() {
        self.majors = []
    }
}
*/
