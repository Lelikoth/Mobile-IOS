//
//  ContentView.swift
//  ToDo
//
//  Created by user277759 on 11/20/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var tasks = [
        Task(id: 1, title: "Task 1", image: "por"),
        Task(id: 2, title: "Task 2", image: "por"),
        Task(id: 3, title: "Task 3", image: "por"),
        Task(id: 4, title: "Task 4", image: "por")
    ]
    
    
    var body: some View{
        NavigationStack{
            List($tasks) { $task in NavigationLink(destination: TaskView(task: $task)) {
                HStack{
                    if let status = task.status {
                        switch status {
                        case .inProgress:
                            Image(systemName: "arrow.right.circle.fill")
                                .foregroundColor(.yellow)
                        case .done:
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        case .error:
                            Image(systemName:"exclamationmark.circle.fill")
                                .foregroundColor(.red)
                        }
                    }
                    Text(task.title)
                }
            }
            .swipeActions(edge: .leading) {
                Button(role: .destructive, action: {
                    if let index = tasks.firstIndex(where: { $0.id == task.id}) {
                        tasks.remove (at: index)
                    }
                }) {
                    Label("Delete", systemImage: "trash")
                    }
                }
            }
            .navigationBarTitle("ToDo List", displayMode: .inline)
        }
    }
}
#Preview {
    ContentView()
}
