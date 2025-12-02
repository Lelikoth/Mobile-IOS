//
//  Task.swift
//  ToDo
//
//  Created by user277759 on 12/2/25.
//

import Foundation

struct Task: Identifiable {
    let id: Int
    let title: String
    let image: String
    var status: TaskStatus?
}
