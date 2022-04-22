//
//  Home.swift
//  TaskCalendarView
//
//  Created by paige shin on 2022/04/22.
//

import SwiftUI

struct Home: View {
    
    @State var date: Date = Date()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
             
                // Custom Date Picker...
                CustomDatePicker(currentDate: $date)
                
            }
            .padding(.vertical)
        }
        // Safe Area View...
        .safeAreaInset(edge: .bottom) {
            HStack {
                Button {
                    
                } label: {
                    Text("Add Task")
                        .fontWeight(.bold)
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)
                        .background(
                            Color.orange, in: Capsule()
                        )
                        .padding()
                }
                
                Button {
                    
                } label: {
                    Text("Add Reminder")
                        .fontWeight(.bold)
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)
                        .background(
                            Color.purple, in: Capsule()
                        )
                        .padding()
                }
            } //: hstack
            .padding(.horizontal)
            .padding(.top, 10)
            .foregroundColor(.white)
            .background(.ultraThinMaterial)
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
