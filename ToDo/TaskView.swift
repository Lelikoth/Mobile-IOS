//
//  TaskView.swift
//  ToDo
//
//  Created by user277759 on 12/2/25.
//

import Foundation
import SwiftUI

struct TaskView: View {
    @Binding var task: Task
    @State private var selectedStatus: TaskStatus?
    
    
    var body: some View {
        VStack{
            Text(task.title)
                .font(.title)
                .padding()
            Image(task.image)
                .resizable()
                .scaledToFit()
                .frame(height: 200)
            
            VStack {
                Button(action: {
                    self.task.status = .inProgress
                }) {
                    Label("In Progress", systemImage: "arrow.right.circle")
                        .padding(8)
                        .foregroundColor(self.task.status == .inProgress ? Color.white : Color.yellow)
                        .background(self.task.status == .inProgress ? Color.yellow : Color.clear)
                }
                .cornerRadius(15)
                .padding()
                
                Button(action: {
                    self.task.status = .error
                }) {
                    Label("Error", systemImage: "exclamationmark.circle")
                        .padding(8)
                        .foregroundColor(self.task.status == .error ? Color.white : Color.red)
                        .background(self.task.status == .error ? Color.red : Color.clear)
                }
                
                .cornerRadius(15)
                .padding()
                
                Button(action: {
                    self.task.status = .done
                }) {
                    Label("Done", systemImage: "checkmark.circle")
                        .padding(8)
                        .foregroundColor(self.task.status == .done ? Color.white : Color.green)
                        .background(self.task.status == .done ? Color.green : Color.clear)
                }
                .cornerRadius(15)
                .padding()
            }
            Spacer()
        }
        .navigationBarTitle(task.title, displayMode: .inline)
    }
}
