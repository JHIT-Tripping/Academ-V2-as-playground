//
//  SystemManager.swift
//  Academ
//
//  Created by T Krobot on 24/11/23.
//

//import Foundation
//import SwiftUI
//
//class SystemManager: ObservableObject {
//    @Published var systems: [GradeSystem] = []
//    {
//        didSet {
//            save()
//        }
//    }
//    
//    init() {
//        load()
//    }
//    func gradeCalculate(mark:Double,formatt:String, userData: UserData, customSys: GradeSystem?)->String{
//        var resultGrade = ""
//        if let syst = customSys{
//            for i in syst.grades{
//                if mark >= i.minMark && mark <= i.maxMark{
//                    resultGrade = i.name
//                    break
//                }
//            }
//        }else if !systems.isEmpty{
//            for i in systems[0].grades{
//                if mark >= i.minMark && mark <= i.maxMark{
//                    resultGrade = i.name
//                    break
//                }
//            }
//        }else{
//            resultGrade = "\(String(format:formatt,mark))%"
//        }
//        return resultGrade
//    }
//    func getNames()->[String]{
//        var nameArray:[String] = []
//        for i in systems{
//            nameArray.append(i.name)
//        }
//        return nameArray
//    }
//    func gradePointCalculate(mark:Double, userData: UserData)->Double{
//        var resultGradePoint:Double = 0
//        if userData.gradeType != .none{
//            let selectedSystem = systems[0]
//            for i in selectedSystem.grades{
//                if mark >= i.minMark{
//                    resultGradePoint = i.gradePoint
//                    break
//                }
//            }
//        }else{
//            resultGradePoint = 0.0
//        }
//        return resultGradePoint
//    }
//    func getArchiveURL() -> URL {
//        let plistName = "systems.plist"
//        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        
//        return documentsDirectory.appendingPathComponent(plistName)
//    }
//    
//    func save() {
//        let archiveURL = getArchiveURL()
//        let propertyListEncoder = PropertyListEncoder()
//        let encodedGradeSystems = try? propertyListEncoder.encode(systems)
//        try? encodedGradeSystems?.write(to: archiveURL, options: .noFileProtection)
//    }
//    
//    func load() {
//        let archiveURL = getArchiveURL()
//        let propertyListDecoder = PropertyListDecoder()
//        
//        if let retrievedGradeSystemData = try? Data(contentsOf: archiveURL),
//           let systemsDecoded = try? propertyListDecoder.decode([GradeSystem].self, from: retrievedGradeSystemData) {
//            systems = systemsDecoded
//        }
//    }
//}

import Foundation
import Observation

@Observable class SystemManager {
    var systems: [GradeSystem] = [] {
        didSet {
            save()
        }
    }
    
    init() {
        load()
    }
    
    private func getArchiveURL() -> URL {
        URL.documentsDirectory.appending(path: "systems.json")
    }
    func gradeCalculate(mark:Double,formatt:String, userData: UserData, customSys: GradeSystem?)->String{
        var resultGrade = ""
        if let syst = customSys{
            for i in syst.grades{
                if mark >= i.minMark && mark <= i.maxMark{
                    resultGrade = i.name
                    break
                }
            }
        }else if !systems.isEmpty{
            for i in systems[0].grades{
                if mark >= i.minMark && mark <= i.maxMark{
                    resultGrade = i.name
                    break
                }
            }
        }else{
            resultGrade = "\(String(format:formatt,mark))%"
        }
        return resultGrade
    }
    func getNames()->[String]{
        var nameArray:[String] = []
        for i in systems{
            nameArray.append(i.name)
        }
        return nameArray
    }
    func gradePointCalculate(mark:Double, userData: UserData)->Double{
        var resultGradePoint:Double = 0
        if userData.gradeType != .none{
            let selectedSystem = systems[0]
            for i in selectedSystem.grades{
                if mark >= i.minMark{
                    resultGradePoint = i.gradePoint
                    break
                }
            }
        }else{
            resultGradePoint = 0.0
        }
        return resultGradePoint
    }
    private func save() {
        let archiveURL = getArchiveURL()
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        
        let encodedSystems = try? jsonEncoder.encode(systems)
        try? encodedSystems?.write(to: archiveURL, options: .noFileProtection)
    }
    
    private func load() {
        let archiveURL = getArchiveURL()
        let jsonDecoder = JSONDecoder()
        
        if let retrievedSystemData = try? Data(contentsOf: archiveURL),
           let systemsDecoded = try? jsonDecoder.decode([GradeSystem].self, from: retrievedSystemData) {
            systems = systemsDecoded
        }
    }
}
