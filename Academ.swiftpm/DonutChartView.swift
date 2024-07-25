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
    var width: CGFloat
    var body: some View {
        
        ZStack {
            Circle()
                .stroke(lineWidth: width)
                .opacity(0.3)
                .foregroundColor(Color.gray)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(subject.currentOverall()) / 100.0)
                .stroke(style: StrokeStyle(lineWidth: width, lineCap: .round, lineJoin: .round))
                .foregroundStyle(lineColor)
                .rotationEffect(Angle(degrees: -90))
            Text("\(formattedResult)")
                .foregroundStyle(Color.primary)
        }
        
    }
}
