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

// MARK: - Prerequisites
class Prerequisites: Codable {
    let minGpa: Double?
    let minDeptCredits: MinDeptCredits?
    let applicantLevel, minCoreTechnicalCourse: String?
    let course: PrerequisitesCourse?
    let requirement: String?
    let minDeptGpa: MinDeptGpa?
    let courses: CoursesUnion?
    let minDeptCourse: MinDeptCourse?

    enum CodingKeys: String, CodingKey {
        case minGpa = "min_gpa"
        case minDeptCredits = "min_dept_credits"
        case applicantLevel = "applicant_level"
        case minCoreTechnicalCourse = "min_core_technical_course"
        case course, requirement
        case minDeptGpa = "min_dept_gpa"
        case courses
        case minDeptCourse = "min_dept_course"
    }

    init(minGpa: Double?, minDeptCredits: MinDeptCredits?, applicantLevel: String?, minCoreTechnicalCourse: String?, course: PrerequisitesCourse?, requirement: String?, minDeptGpa: MinDeptGpa?, courses: CoursesUnion?, minDeptCourse: MinDeptCourse?) {
        self.minGpa = minGpa
        self.minDeptCredits = minDeptCredits
        self.applicantLevel = applicantLevel
        self.minCoreTechnicalCourse = minCoreTechnicalCourse
        self.course = course
        self.requirement = requirement
        self.minDeptGpa = minDeptGpa
        self.courses = courses
        self.minDeptCourse = minDeptCourse
    }
}

enum PrerequisitesCourse: Codable {
    case purpleCourse(PurpleCourse)
    case stringArray([String])

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([String].self) {
            self = .stringArray(x)
            return
        }
        if let x = try? container.decode(PurpleCourse.self) {
            self = .purpleCourse(x)
            return
        }
        throw DecodingError.typeMismatch(PrerequisitesCourse.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for PrerequisitesCourse"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .purpleCourse(let x):
            try container.encode(x)
        case .stringArray(let x):
            try container.encode(x)
        }
    }
}

// MARK: - PurpleCourse
class PurpleCourse: Codable {
    let courseName: String
    let minGpa: Double

    enum CodingKeys: String, CodingKey {
        case courseName = "course_name"
        case minGpa = "min_gpa"
    }

    init(courseName: String, minGpa: Double) {
        self.courseName = courseName
        self.minGpa = minGpa
    }
}

enum CoursesUnion: Codable {
    case coursesClass(CoursesClass)
    case unionArray([CourseElement])

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([CourseElement].self) {
            self = .unionArray(x)
            return
        }
        if let x = try? container.decode(CoursesClass.self) {
            self = .coursesClass(x)
            return
        }
        throw DecodingError.typeMismatch(CoursesUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for CoursesUnion"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .coursesClass(let x):
            try container.encode(x)
        case .unionArray(let x):
            try container.encode(x)
        }
    }
}

enum CourseElement: Codable {
    case fluffyCourse(FluffyCourse)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        if let x = try? container.decode(FluffyCourse.self) {
            self = .fluffyCourse(x)
            return
        }
        throw DecodingError.typeMismatch(CourseElement.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for CourseElement"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .fluffyCourse(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

// MARK: - FluffyCourse
class FluffyCourse: Codable {
    let course: CourseCourseUnion?
    let requirements: [String]?
    let minGpa: Double?
    let courses: [String]?

    enum CodingKeys: String, CodingKey {
        case course, requirements
        case minGpa = "min_gpa"
        case courses
    }

    init(course: CourseCourseUnion?, requirements: [String]?, minGpa: Double?, courses: [String]?) {
        self.course = course
        self.requirements = requirements
        self.minGpa = minGpa
        self.courses = courses
    }
}

enum CourseCourseUnion: Codable {
    case string(String)
    case stringArray([String])

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([String].self) {
            self = .stringArray(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(CourseCourseUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for CourseCourseUnion"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let x):
            try container.encode(x)
        case .stringArray(let x):
            try container.encode(x)
        }
    }
}

// MARK: - CoursesClass
class CoursesClass: Codable {
    let minGpa: Double
    let courses: [String]

    enum CodingKeys: String, CodingKey {
        case minGpa = "min_gpa"
        case courses
    }

    init(minGpa: Double, courses: [String]) {
        self.minGpa = minGpa
        self.courses = courses
    }
}

// MARK: - MinDeptCourse
class MinDeptCourse: Codable {
    let dept: String
    let number: Int
    let minGpa: Double

    enum CodingKeys: String, CodingKey {
        case dept, number
        case minGpa = "min_gpa"
    }

    init(dept: String, number: Int, minGpa: Double) {
        self.dept = dept
        self.number = number
        self.minGpa = minGpa
    }
}

// MARK: - MinDeptCredits
class MinDeptCredits: Codable {
    let department: String
    let number: Int
    let minGpa: Double?

    enum CodingKeys: String, CodingKey {
        case department, number
        case minGpa = "min_gpa"
    }

    init(department: String, number: Int, minGpa: Double?) {
        self.department = department
        self.number = number
        self.minGpa = minGpa
    }
}

// MARK: - MinDeptGpa
class MinDeptGpa: Codable {
    let dept: String
    let gpa: Double

    init(dept: String, gpa: Double) {
        self.dept = dept
        self.gpa = gpa
    }
}

// TypeAlias for easy calling
typealias Major = MajorElement
