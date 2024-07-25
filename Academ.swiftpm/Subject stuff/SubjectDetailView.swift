//
//  SubjectDetailView.swift
//  Academ
//
//  Created by yoeh iskandar on 18/11/23.
//

import SwiftUI
import Charts
struct SubjectDetailView: View {
    @Binding var sub: Subject
    @State private var displaySheet = false
    @State private var showAlert = false
    @ObservedObject var userData: UserData
    var body: some View {
        
        NavigationStack {
            Form{
                Section(header: Text("subject info")) {
                    TextField("Name",text:$sub.name)
                    HStack{
                        Text("No. of Assessments")
                        TextField("Num",value:$sub.numOfAssessments, formatter: NumberFormatter())
                    }
                    HStack{
                        Text("Overall Goal:")
                        TextField("Percentage",value:$sub.targetMark,formatter: NumberFormatter())
                        Text("%")
                    }//overall goal
                    if sub.assessmentArray(type: 1).count>0{
                        NavigationLink{
                            SubjectOverallView(subje: $sub,userData: userData)
                        }label: {
                            Text("Overall")
                        }
                    }
                    if userData.haveCredits{
                        HStack{
                            Text("Credit")
                            TextField("Hours",value: $sub.credits, formatter: NumberFormatter())
                        }
                    }
                }
                .listRowBackground(userData.themelists[userData.colorSelect].secondColor)
                Section(header: Text("Assessments")) {
                    List($sub.assessments,editActions:.all){$assessment in
                        NavigationLink(destination: AssessmentDetailView(assess: $assessment,userData: userData)){
                            Text(assessment.name)
                            Text("")
                                .font(.caption)
                        }
                    }
                    if !(sub.assessments.count >= sub.numOfAssessments){
                        Button {
                            print("sooon")
                            displaySheet = true
                        } label: {
                            Text("+  Add an assessment")
                        }
                    }
                    
                }
                .listRowBackground(userData.themelists[userData.colorSelect].secondColor)
                Section(header: Text("Subject trends (%)")){
                    GraphView(sub: sub, userData: userData)
                }
                .listRowBackground(userData.themelists[userData.colorSelect].secondColor)
            }
            .background(userData.themelists[userData.colorSelect].mainColor)
            .scrollContentBackground(userData.themelists[userData.colorSelect].hideBackground ? .hidden : .visible)
            .navigationTitle($sub.name)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            .onAppear{
                if (sub.assessments.count == sub.numOfAssessments || sub.numOfAssessments == 0)&&(sub.checkIfSubjectGradeExceeds100()>Double(100)){
                    showAlert=true
                }
            }
            .alert("Your inputted weightage is higher than 100%.",isPresented: $showAlert){
                
            }message: {
                Text("Please change your assessment's weightage")
            }
        }
        .sheet(isPresented: $displaySheet) {
            NewAssessmentView(sub:$sub,userData: userData)
        }
        
        
        
        
    }
}
struct SubjectDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SubjectDetailView(sub: .constant(Subject(name: "Mathematics", assessments: [
            Assessment(name: "WA1", weightage: 10, totalMarks: 20, examDone: true, markAttained: 12, examDate: Date(), haveReminder: false, reminder: Date()),
            Assessment(name: "WA2", weightage: 15, totalMarks: 30, examDone: true, markAttained: 23, examDate: Date(), haveReminder: false, reminder: Date()),
            Assessment(name: "WA3", weightage: 15, totalMarks: 45, examDone: true, markAttained: 37, examDate: Date(), haveReminder: false, reminder: Date()),
            Assessment(name: "EYE", weightage: 60, totalMarks: 120, examDone: false, markAttained: 0, examDate: Date(), haveReminder: true, reminder: Date())
        ], targetMark: 80, credits: 0, numOfAssessments: 4)),userData: UserData())
    }
}
