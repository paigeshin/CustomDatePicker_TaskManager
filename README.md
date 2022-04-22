# CustomDatePicker_TaskManager

```swift

//
//  CustomDatePicker.swift
//  TaskCalendarView
//
//  Created by paige shin on 2022/04/22.
//

import SwiftUI

// MARK: - MODELS, TASK
// Task
struct Task: Identifiable {
    var id: String = UUID().uuidString
    var title: String
    var time: Date = Date()
}

// Total Task Meta View...
struct TaskMetaData: Identifiable {
    var id: String = UUID().uuidString
    var task: [Task]
    var taskDate: Date
}

// Sample Date For Testing...
func getSampleDate(offset: Int) -> Date {
    let calednar: Calendar = Calendar.current
    let date: Date = calednar.date(byAdding: .day, value: offset, to: Date()) ?? Date()
    return date
}

// Sample Tasks
var tasks: [TaskMetaData] = [
    
    TaskMetaData(task: [
        Task(title: "Talk to iJustine"),
        Task(title: "iPhone 13 Great Design Change"),
        Task(title: "Nothing Much Workout !!!"),
    ], taskDate: getSampleDate(offset: 1)),

    TaskMetaData(task: [
        Task(title: "Talk to Jenna Ezarik"),
    ], taskDate: getSampleDate(offset: -3)),
    
    TaskMetaData(task: [
        Task(title: "Metting with Tim Cook"),
    ], taskDate: getSampleDate(offset: -8)),
    
    TaskMetaData(task: [
        Task(title: "Next Version of SwiftUI"),
    ], taskDate: getSampleDate(offset: 10)),
    
    TaskMetaData(task: [
        Task(title: "Nothing Much Workout !!!"),
    ], taskDate: getSampleDate(offset: -22)),
    
    TaskMetaData(task: [
        Task(title: "iPhone 13 Great Design Change"),
    ], taskDate: getSampleDate(offset: 15)),
    
    
    TaskMetaData(task: [
        Task(title: "PaigeSoftware App Updates..."),
    ], taskDate: getSampleDate(offset: -20)),
]

// MARK: - MODELS, DateValue
struct DateValue: Identifiable {
    var id: String = UUID().uuidString
    var day: Int
    var date: Date
}

struct CustomDatePicker: View {
    
    @Binding var currentDate: Date
    
    // Month update on arrow button click
    @State private var currentMonth: Int = 0
    
    // Name of Day
    private let days: [String] = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    // Days
    private let columns: [GridItem] = Array(repeating: GridItem(.flexible()), count: 7)
    
    var body: some View {
        
        VStack(spacing: 35) {
            // MARK: - HEADER
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(extractDate()[0])
                        .font(.caption)
                        .fontWeight(.semibold)
                    Text(extractDate()[1])
                        .font(.title.bold())
                } //: VSTACK
                Spacer(minLength: 0)
                
                Button {
                    withAnimation {
                        currentMonth -= 1
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                }
                
                Button {
                    currentMonth += 1
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                }
                
            } //: HSTACK - HEADER
            .padding(.horizontal)
            
            // MARK: - DAY VIEW
            HStack(spacing: 0) {
                ForEach(days, id: \.self) { day in
                    Text(day)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
            } //: HSTACK - DAY VIEW
            

            // MARK: - DATES
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(extractDate()) { value in
                    CardView(value: value)
                        // MARK: CALENDAR VERSION ONLY
                        .background(
                            Capsule()
                                .fill(Color.pink)
                                .padding(.horizontal, 8)
                                .opacity(isSameDay(date1: value.date, date2: currentDate) ? 1 : 0)
                        )
                        .onTapGesture {
                            currentDate = value.date
                        }
                }
            } //: LAZYVGRID DATES
            
            // MARK: - TASK, TASK ADDED VERSIO N
            VStack(spacing: 15) {
                Text("Tasks")
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 20)
                if let task = tasks.first(where: { task in
                    return isSameDay(date1: task.taskDate, date2: currentDate)
                }) {
                    ForEach(task.task) { task in
                        VStack(alignment: .leading, spacing: 10) {
                            // For Custom Timing...
                            Text(task.time
                                .addingTimeInterval(CGFloat.random(in: 0...5000)),
                                 style: .time)
                        
                            Text(task.title)
                                .font(.title2.bold())
                        } //: VSTACK
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            Color
                                .purple
                                .opacity(0.5)
                                .cornerRadius(10)
                        ) //: background
                    }
                } else {
                    Text("No Task Found")
                }
            } //: VSTACK
            .padding()
            
        } //: VSTACK
        .onChange(of: currentMonth) { newValue in
            // updating Month...
            currentDate = getCurrentMonth()
        }
        
    }
    
    // MARK: CHANGE DAY DESIGN IF YO UWANT
    @ViewBuilder
    private func CardView(value: DateValue) -> some View {
        VStack {
            if value.day != -1 {
                // MARK: CALENDAR VERSION ONLY
//                Text("\(value.day)")
//                    .font(.title3.bold())
  

                // MARK: - TASK ADDED VERSION
                if let task = tasks.first(where: { task in
                    return isSameDay(date1: task.taskDate, date2: value.date)
                }) {
                    Text("\(value.day)")
                        .font(.title3.bold())
                        .foregroundColor(isSameDay(date1: task.taskDate, date2: currentDate) ? .white : .primary)
                        .frame(maxWidth: .infinity)
                    Spacer()
                    Circle()
                        .fill(isSameDay(date1: task.taskDate, date2: currentDate) ? .white : Color.pink)
                        .frame(width: 8, height: 8)
                } else {
                    Text("\(value.day)")
                        .font(.title3.bold())
                        .foregroundColor(isSameDay(date1: value.date, date2: currentDate) ? .white : .primary)
                        .frame(maxWidth: .infinity)
                    Spacer()
                }
                
            }
        }
        .padding(.vertical, 9)
        .frame(height: 60, alignment: .top)
    }
    
    
    
    // extracting Year And Month for display...
    private func extractDate() -> [String] {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "YYYY MMMM"
        let date: String = formatter.string(from: currentDate)
        return date.components(separatedBy: " ")
    }
    
    // with `currentMonth`, extract relevant dates
    private func extractDate() -> [DateValue] {
        let calendar: Calendar = Calendar.current
        // Getting Current Month Data...
        let currentMonth: Date = getCurrentMonth()
        var days: [DateValue] = currentMonth.getAllDates().compactMap { date -> DateValue in
            // getting days...
            let day: Int = calendar.component(.day, from: date)
            return DateValue(day: day, date: date)
        }
        // MARK: YOU CAN FIX OFFSET DAYS HERE
        // adding offset days to get exact week day...
        let firstWeekDay = calendar.component(.weekday, from: days.first!.date)
        for _ in 0..<firstWeekDay - 1 {
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        return days
    }
    
    // get current date of month with `currentMonth`
    private func getCurrentMonth() -> Date {
        let calendar: Calendar = Calendar.current
        // Getting Current Month Data...
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else {
            return Date()
        }
        return currentMonth
    }
}

// MARK: - TASK ADDED VERSION
extension CustomDatePicker {
    // Checking Dates...
    func isSameDay(date1: Date, date2: Date) -> Bool {
        let calendar: Calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }
}

struct CustomDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        Home(date: .init())
    }
}

// Extending Date to get Current Month Dates...
extension Date {
    
    func getAllDates() -> [Date] {
        let calendar: Calendar = Calendar.current
        
        // getting start Date...
        let dateComponents: DateComponents = calendar.dateComponents([.year, .month], from: self)
        let startDate: Date = calendar.date(from: dateComponents)!
        
        let range: Range<Int> = calendar.range(of: .day, in: .month, for: startDate)!
        
        // getting date...
        return range.compactMap { day -> Date in
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
        }
    }
    
}


```
