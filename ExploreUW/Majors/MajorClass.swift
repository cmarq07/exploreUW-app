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
    let majorType: MajorType
    let college: College
    let department: Department?
    let tracks: [String]?
    let prerequisites: PrerequisitesUnion
    let minor: Bool
    let notes: String?

    enum CodingKeys: String, CodingKey {
        case majorName = "major_name"
        case majorType = "major_type"
        case college, department, tracks, prerequisites, minor, notes
    }

    init(majorName: String, majorType: MajorType, college: College, department: Department?, tracks: [String]?, prerequisites: PrerequisitesUnion, minor: Bool, notes: String?) {
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
    case empty = ""
    case humanities = "Humanities"
    case naturalSciences = "Natural Sciences"
    case socialSciences = "Social Sciences"
}

enum MajorType: String, Codable {
    case capacityConstrained = "Capacity-Constrained"
    case minimumRequirement = "Minimum Requirement"
    case openMajor = "Open Major"
}

enum PrerequisitesUnion: Codable {
    case prerequisitesClass(PrerequisitesClass)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        if let x = try? container.decode(PrerequisitesClass.self) {
            self = .prerequisitesClass(x)
            return
        }
        throw DecodingError.typeMismatch(PrerequisitesUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for PrerequisitesUnion"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .prerequisitesClass(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

// MARK: - PrerequisitesClass
class PrerequisitesClass: Codable {
    let minGpa: String?
    let minArtCredits: MinArtCredits?
    let applicantLevel, minCoreDanceCredits, minCoreTechnicalCourse: String?
    let course: CourseUnion?
    let requirement, minEnglishGpa: String?
    let minGeogCourse: Min?

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

    init(minGpa: String?, minArtCredits: MinArtCredits?, applicantLevel: String?, minCoreDanceCredits: String?, minCoreTechnicalCourse: String?, course: CourseUnion?, requirement: String?, minEnglishGpa: String?, minGeogCourse: Min?) {
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
    let courseName, minGpa: String

    enum CodingKeys: String, CodingKey {
        case courseName = "course_name"
        case minGpa = "min_gpa"
    }

    init(courseName: String, minGpa: String) {
        self.courseName = courseName
        self.minGpa = minGpa
    }
}

enum MinArtCredits: Codable {
    case min(Min)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        if let x = try? container.decode(Min.self) {
            self = .min(x)
            return
        }
        throw DecodingError.typeMismatch(MinArtCredits.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for MinArtCredits"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .min(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

// MARK: - Min
class Min: Codable {
    let number, minGpa: String

    enum CodingKeys: String, CodingKey {
        case number
        case minGpa = "min_gpa"
    }

    init(number: String, minGpa: String) {
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
