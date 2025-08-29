//
//  ContentView.swift
//  ClecProject
//
//  Created by Lucas Dal Pra Brascher on 25/08/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var projectManager = ProjectManager()
    
    var body: some View {
        NavigationView {
            Group {
                if projectManager.hasProjects {
                    DashboardView()
                } else {
                    InitialView()
                }
            }
            .environmentObject(projectManager)
        }
        .preferredColorScheme(.light)
    }
}

#Preview {
    ContentView()
}
