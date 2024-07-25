//
//  DashboardView.swift
//  Academ
//
//  Created by T Krobot on 18/11/23.
//

import SwiftUI
import Charts
struct ChartAssessment: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var mark: Int
}
struct DonutChartView: View {
    var subject: Subject
    //    @EnvironmentObject var subjectmanager: SubjectManager
    @ObservedObject var userData: UserData
    @EnvironmentObject var systemmanager: SystemManager
    
    var formattedResult: String {
        return subject.currentOverall().isNaN || subject.currentOverall().isSignalingNaN ? "--" : systemmanager.gradeCalculate(mark: Double(subject.currentOverall()), formatt: "%.0f")
    }
    var lineColor:Color{
        if subject.currentOverall()<userData.pass{
            return .red
        }else if subject.currentOverall()<subject.targetMark{
            return .yellow
        }else{
            return .green
        }
        
            
    }
    var body: some View {
        
        ZStack {
            Circle()
                .stroke(lineWidth: 6)
                .opacity(0.3)
                .foregroundColor(Color.gray)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(subject.currentOverall()) / 100.0)
                .stroke(style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round))
                .foregroundStyle(lineColor)
                .rotationEffect(Angle(degrees: -90))
            Text("\(formattedResult)")
                .foregroundStyle(Color.primary)
        }
        
    }
}

struct DashboardView: View {
    @EnvironmentObject var subjectmanager: SubjectManager
    @ObservedObject var userData: UserData
    @EnvironmentObject var systemmanager: SystemManager
    var body: some View {
        NavigationStack{
            Form {
                Section{
                    if subjectmanager.subjects.count == 0 {
                        Text("No subjects")
                            .foregroundColor(.gray)
                        
                    }else{
                        ScrollView(.horizontal){
                            HStack {
                                ForEach($subjectmanager.subjects){ $subject in
                                    NavigationLink{
                                        SubjectDetailView(sub:$subject,userData:userData)
                                    }label:{
                                        VStack{
                                            DonutChartView(subject: subject, userData: userData)
                                                .frame(width: 70, height: 50)
                                                .padding(4)
                                            Text(subject.name)
                                                .foregroundColor(.primary)
                                        }
                                    }
                                }
                            }
                            
                        }
                        
                        .cornerRadius(4)
                    }
                }
                .listRowBackground(userData.themelists[userData.colorSelect].secondColor)
                
                if subjectmanager.subjects.count == 0 {
                    Section{
                        Text("No subjects available. Go add some in the subjects tab!")
                            .foregroundColor(.gray)
                    }
                    .listRowBackground(userData.themelists[userData.colorSelect].secondColor)
                }else{
                    ForEach($subjectmanager.subjects){ $subject in
                        
                        if subject.assessmentArray(type:1).count > 1 {
                            // Text("\(subject.name) results")
                            Section(subject == subjectmanager.subjects.first ? "Subjects" : "") {
                                NavigationLink(destination: SubjectDetailView(sub: $subject,userData: userData)){
                                    VStack{
                                        Text("\(subject.name) mark trends")
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .offset(y: 8)
                                            .font(.title2)
                                        ZStack{
                                            Chart(subject.assessments) { assessment in
                                                if assessment.examDone{
                                                    LineMark(
                                                        x: .value("Assessment", assessment.name),
                                                        y: .value("Mark", percentage(amount: assessment.markAttained, total: assessment.totalMarks))
                                                    )
                                                    .foregroundStyle(.red)
                                                }
                                            }
                                            Chart(subject.assessments) { assessment in
                                                
                                                
                                                if assessment.examDone{
                                                    LineMark(
                                                        x: .value("Assessment", assessment.name),
                                                        y: .value("Mark", subject.targetMark)
                                                    )
                                                    .foregroundStyle(.green)
                                                }
                                                
                                            }
                                            Chart(subject.assessments) { assessment in
                                                
                                                
                                                if assessment.examDone{
                                                    LineMark(
                                                        x: .value("Assessment", assessment.name),
                                                        y: .value("Mark", subject.currentOverall())
                                                    )
                                                }
                                                
                                                
                                            }
                                        }
                                        
                                        
                                        
                                        
                                    }
                                    .frame(width: 300, height: 200)
                                    .chartYScale(domain:0...100)
                                    
                                }
                                HStack{
                                    Image(systemName: "circle.fill")
                                        .foregroundColor(.red)
                                    Text("WA marks")
                                    Text("  ")
                                    Image(systemName: "circle.fill")
                                        .foregroundColor(.green)
                                    Text("Goal marks")
                                    Text("  ")
                                    Image(systemName: "circle.fill")
                                        .foregroundColor(Color(hex:"0096FF"))
                                    Text("Overall marks")
                                }
                            }
                            
                            .listRowBackground(userData.themelists[userData.colorSelect].secondColor)
                        } else {
                            Section{
                                NavigationLink(destination: SubjectDetailView(sub: $subject,userData: userData)){
                                    Text("\(subject.name) needs at least two scores to see mark trends.")
                                        .foregroundColor(.gray)
                                }
                            }
                            .listRowBackground(userData.themelists[userData.colorSelect].secondColor)
                            
                        }
                    }
                    
                }
                
                
                
                
            }
            .background(userData.themelists[userData.colorSelect].mainColor)
            .scrollContentBackground(userData.themelists[userData.colorSelect].hideBackground ? .hidden : .visible)
            .navigationTitle("Dashboard")
        }
    }
    
}
struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView(userData: UserData())
            .environmentObject(SubjectManager())
            .environmentObject(SystemManager())
    }
}

