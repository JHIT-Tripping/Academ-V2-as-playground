//
//  SubjectsView.swift
//  Academ
//
//  Created by T Krobot on 18/11/23.
//

import SwiftUI

struct SubjectsView: View {
    @EnvironmentObject var settings: SubjectManager
    @ObservedObject var userData: UserData
    @Environment(SystemManager.self) var systemmanager: SystemManager
    @State private var displaySheet = false
    var body: some View {
        NavigationStack{
            
            Form{
                Section{
                    if settings.subjects.count == 0 {
                        Text("No subjects")
                            .foregroundColor(.gray)
                        
                    }else{
                        ScrollView(.horizontal){
                            HStack {
                                ForEach($settings.subjects){ $subject in
                                    if !subject.assessments.map({$0.markAttained}).isEmpty{
                                        NavigationLink{
                                            SubjectDetailView(sub:$subject,userData:userData)
                                        }label:{
                                            VStack{
                                                DonutChartView(subject: subject, userData: userData, width: 6)
                                                    .frame(width: 70, height: 50)
                                                    .padding(4)
                                                Text(subject.name)
                                                    .foregroundColor(.primary)
                                            }
                                        }
                                    }
                                }
                            }
                            
                        }
                        
                        .cornerRadius(4)
                    }
                }
                .listRowBackground(userData.themelists[userData.colorSelect].secondColor)
                Section{
                    
//                    if userData.selection==1&&userData.haveCredits{
//                        
//                        HStack{
//                            Text("Target GPA")
//                            Text(String(format:"%.2f",settings.compute(isTarget: true,userData:userData)))
//                        }
//                        HStack{
//                            Text("Current GPA")
//                            Text(String(format:"%.2f",settings.compute(isTarget: false,userData:userData)))
//                        }
//                        
//                    }else if userData.selection==2{
//                        HStack{
//                            Text("Target MSG")
//                            Text(String(format:"%.2f",settings.compute(isTarget: true,userData:userData)))
//                        }
//                        HStack{
//                            Text("Current MSG")
//                            Text(String(format:"%.2f",settings.compute(isTarget: false,userData:userData)))
//                        }
//                    }else if userData.selection==3{
//                        HStack{
//                            Text("Target AL")
//                            Text(String(format:"%.0f",settings.compute(isTarget: true,userData:userData)))
//                        }
//                        HStack{
//                            Text("Current AL")
//                            Text(String(format:"%.0f",settings.compute(isTarget: false,userData:userData)))
//                        }
//                    }else if userData.selection==8{
//                        HStack{
//                            Text("Target MAG")
//                            Text(systemmanager.MSGtoMAG(msg: settings.compute(isTarget: true,userData:userData)))
//                        }
//                        HStack{
//                            Text("Current MAG")
//                            Text(systemmanager.MSGtoMAG(msg:settings.compute(isTarget: false,userData:userData)))
//                        }
//                    }
                    
                }
                .listRowBackground(userData.themelists[userData.colorSelect].secondColor)
                Section{
                    if settings.subjects.count == 0 {
                        Text("No subjects")
                            .foregroundColor(.gray)
                    }else{
                        List($settings.subjects,editActions: .all){$subject in
                            NavigationLink{
                                SubjectDetailView(sub:$subject,userData: userData)
                            }label:{
                                HStack{
                                    Text(subject.name)
                                    if subject.assessments.map({$0.markAttained}).count>0{
                                        Spacer()
                                        Text(String(format: "%.0f",subject.currentOverall())+"%")
                                    }
                                }
                            }
                            .listRowBackground(userData.themelists[userData.colorSelect].secondColor)
                        }
                    }
                }
                .listRowBackground(userData.themelists[userData.colorSelect].secondColor)
            }
            .background(.linearGradient(colors: userData.themelists[userData.colorSelect].mainColor, startPoint: .top, endPoint: .bottom))
            .scrollContentBackground(.hidden)
            .navigationTitle("Subjects")
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    HStack{
                        EditButton()
                        Button{
                            displaySheet = true
                        } label: {
                            Image(systemName: "plus")
                            
                        }
                    }
                    .padding(.trailing, 8)
                    .background(userData.themelists[userData.colorSelect].secondColor)
                    .mask{
                        RoundedRectangle(cornerRadius: 10)
                    }
                }
                
            }
            .sheet(isPresented: $displaySheet) {
                NewSubjectView(userData: userData)
                    .presentationDetents([.fraction(0.8)])
                    .presentationDragIndicator(.visible)
                    .listRowBackground(userData.themelists[userData.colorSelect].secondColor)
            }
            .listRowBackground(userData.themelists[userData.colorSelect].secondColor)
        }
    }
}




struct SubjectsView_Previews: PreviewProvider {
    static var previews: some View {
        SubjectsView(userData: UserData())
            .environmentObject(SubjectManager())
            .environment(SystemManager())
    }
}
