//
//  Model.swift
//  Academ
//
//  Created by T Krobot on 18/11/23.
//

import Foundation
import SwiftUI

struct Assessment: Identifiable, Codable, Hashable{
    var id = UUID()
    var name: String
    var weightage: Double
    var totalMarks: Double
    var examDone: Bool
    var markAttained: Double
    var examDate: Date
    var haveReminder: Bool
    var reminder: Date
    var percentage: Double{
        return markAttained/totalMarks*100
    }
}
struct Subject: Identifiable, Codable, Equatable{
    var id = UUID()
    var name: String
    var assessments: [Assessment]
    var targetMark: Double
    // var hasGoal: Bool
    var credits: Int
    var numOfAssessments: Int
    //    var isHMT = false
    var isFoundation = false
    var isMTSB = false
    func assessmentArray(type:Int)->[Double]{
        var numArray:[Double] = []
        for i in assessments{
            if i.examDone{
                if type == 0{
                    numArray.append(i.totalMarks) // maximum number of marks
                }else if type == 1{
                    numArray.append(i.markAttained) // number of marks attained
                }else if type == 2{
                    numArray.append(i.weightage) // weightage
                }
            }else{
                if type == 3{
                    numArray.append(i.totalMarks)
                }
            }
        }
        return numArray
    }//gets a value from the assessments array (type 0 is totalMarks for done assessments, 1 is marksAttained, 2 is weightage, 3 is totalMarks for not done exams)
    func arrayPercentage()->[Double]{
        let amountArray = assessmentArray(type:1) // marks attained
        let totaledArray = assessmentArray(type:0) // max marks
        var percentageArray:[Double] = []
        for i in 0..<amountArray.count{
            percentageArray.append(percentage(amount: amountArray[i], total: totaledArray[i]))
        }
        return percentageArray
    }//calculates percentage and puts it in an array
    func highest()->Double{
        let doubleArray = arrayPercentage()
        var high:Double=0
        for i in doubleArray{
            if i > high{
                high=i
            }
        }
        return high
    }//finds the highest value in an array
    /*func average()->Double{
     let doubleArray = arrayPercentage()
     var sum:Double = 0
     for i in doubleArray{
     sum+=i
     }
     sum/=Double(doubleArray.count)
     return sum
     
     }*///finds the average of doubles in an array (deprecated)
    func currentOverall() -> Double {
        let examWeightages = assessmentArray(type: 2)
        let arrayPercentages = arrayPercentage()
        
        guard !examWeightages.isEmpty && examWeightages.count == arrayPercentages.count else {
            // Handle the case where either examPercentages is empty or its count is different from arrayPercentages count.
            return 0.0
        }
        
        var total: Double = 0
        
        for i in examWeightages.indices {
            total += examWeightages[i] * arrayPercentages[i]
        }
        
        let totalExamPercentages = examWeightages.reduce(0, +)
        return totalExamPercentages != 0 ? total / totalExamPercentages : 0.0
        
        
    }//finds the current overall based on the percentage
    func weightedGoal()->Double{
        var percentageSum:Double=0
        for i in 0..<arrayPercentage().count{
            percentageSum+=arrayPercentage()[i]/100*assessmentArray(type: 2)[i]
        }
        var valueSum:Double = 0
        for i in assessmentArray(type: 2){
            valueSum+=i
        }
        valueSum=100-valueSum
        let sum = (targetMark-percentageSum)/valueSum*100
        return sum
    }//finds the percentage needed to achieve the goal
    func checkIfSubjectGradeExceeds100() -> Double{
        
        var finalGradeForSubject:Double = 0.0
        // var exceeds100 = false
        for test in  (assessments) {
            finalGradeForSubject += test.weightage
            
            //        if finalGradeForSubject >= 100.0 {
            //             exceeds100 = true
            //         }
        }
        return finalGradeForSubject
    }//pretty self explanatory
    func getUnfinishedAssessments()->[Assessment]{
        var unfinishedArray:[Assessment]=[]
        for i in assessments{
            if !i.examDone{
                unfinishedArray.append(i)
            }
        }
        return unfinishedArray
    }
}
struct GradeSystem: Codable{
    var name: String
    var grades: [Grade]
}
struct Grade: Codable, Identifiable{
    var id = UUID()
    var name: String
    var minMark: Double
    var maxMark: Double
    var gradePoint: Double
}



func percentage(amount:Double,total:Double)->Double{
    return amount/total*100
}

struct themeColors: Identifiable{
    var id = UUID()
    var themeName: String
    var hideBackground : Bool
    var mainColor : Color
    var secondColor : Color
    var LightMode : Bool
}

//var HMT = GradeSystem(name: "hmt", grades: [
//    Grade(name: "Distinction", minMark: 80, maxMark: 100, gradePoint: 0.0),
//    Grade(name: "Merit", minMark: 65, maxMark: 79, gradePoint: 0.0),
//    //tbc
//])
var foundation = GradeSystem(name: "alf", grades: [
    Grade(name: "AL A", minMark: 75, maxMark: 100, gradePoint: 7.0),
    Grade(name: "AL B", minMark: 30, maxMark: 74, gradePoint: 8.0),
    Grade(name: "AL C", minMark: 0, maxMark: 29, gradePoint: 9.0)
])

