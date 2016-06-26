//: Playground - noun: a place where people can play
// possible design pattern?
import UIKit
import XCPlayground

struct AppModel {
    var repeats: Int
    var vocabulary: [String] = []
    var verificationLength: Int
    var url: NSURL?
}

enum Gender: CustomStringConvertible {
    case male, female
    
    var description: String {
        switch self {
        case .male:
            return "M"
        case .female:
            return "F"
        }
    }
}

struct Consumer {
    var gender: Gender
    var username: String
    var password: String
    var url: NSURL?
}

struct Enrollment {
    enum Status {
        case initialized, requested, processing, completed, failed, removedRequested, removing
    }
    var consumer: Consumer
    var application: AppModel
    var status: Status
}

typealias TimePosition = Int
struct Phrase {
    var name: String
    var start: TimePosition
    var stop: TimePosition
}
struct AudioFile {
    var url: NSURL
}
struct Analysis {
    var audioUrl: NSURL
    var filedata: NSFileManager
}

