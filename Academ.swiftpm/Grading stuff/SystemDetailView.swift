import SwiftUI

struct SystemDetailView: View {
    @Binding var system: GradeSystem
    @ObservedObject var userData: UserData
    @State private var showSheet = false
    @EnvironmentObject var systemmanager: SystemManager
    
    var body: some View {
        //        if let index = systemmanager.systems.firstIndex(where: { $0 == system }) {
        NavigationStack {
            Form {
                Section("Info") {
                    HStack{
                        Text("Name:")
                        TextField("Enter", text: $system.name)
                    }
                }
                .listRowBackground(userData.themelists[userData.colorSelect].secondColor)
                
                Section("Grades"){
                    
                    ForEach($system.grades, editActions: .all){$grade in
                        NavigationLink{
                            GradeDetailView(grade: $grade, userData: userData)
                        }label: {
                            Text(grade.name)
                        }
                    }
                    
                }
                .listRowBackground(userData.themelists[userData.colorSelect].secondColor)
                .sheet(isPresented: $showSheet){
                    NewGradeView(system: $system, userData: userData)
                }
            }
            .navigationTitle(system.name)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    HStack {
                        EditButton()
                        //                            Button{
                        //                                userData.systemIndex = index
                        //                            }label: {
                        //                                Image(systemName: index == userData.systemIndex ? "star.fill" : "star")
                        //                            }
                        Button{
                            showSheet = true
                        }label: {
                            HStack{
                                Image(systemName: "plus")
                            }
                        }
                    }
                    .padding(.trailing, 8)
                    .background(userData.themelists[userData.colorSelect].secondColor)
                    .mask {
                        RoundedRectangle(cornerRadius: 10)
                    }
                }
            }
            .background(
                LinearGradient(
                    colors: userData.themelists[userData.colorSelect].mainColor,
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .scrollContentBackground(.hidden)
        }
        //        }
    }
}

#Preview {
    SystemDetailView(
        system: .constant(GradeSystem(name: "MSG", grades: [
            Grade(name: "A1", minMark: 75, maxMark: 100, gradePoint: 1.0),
            Grade(name: "A2", minMark: 70, maxMark: 74, gradePoint: 2.0),
            Grade(name: "B3", minMark: 65, maxMark: 69, gradePoint: 3.0),
            Grade(name: "B4", minMark: 60, maxMark: 64, gradePoint: 4.0),
            Grade(name: "C5", minMark: 55, maxMark: 59, gradePoint: 5.0),
            Grade(name: "C6", minMark: 50, maxMark: 54, gradePoint: 6.0),
            Grade(name: "D7", minMark: 45, maxMark: 49, gradePoint: 7.0),
            Grade(name: "E8", minMark: 40, maxMark: 44, gradePoint: 8.0),
            Grade(name: "F9", minMark: 0, maxMark: 39, gradePoint: 9.0),
        ], type: .MSG)),
        userData: UserData()
    )
}
