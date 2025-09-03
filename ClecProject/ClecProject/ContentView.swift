//
//  ContentView.swift
//  ClecProject
//
//  Created by Lucas Dal Pra Brascher on 25/08/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var projectManager = ProjectManager()
    @StateObject private var userManager = UserManager()
    
    var body: some View {
        NavigationView {
            Group {
                if projectManager.hasActiveProject {
                    DashboardView()
                } else {
                    InitialView()
                }
            }
            .environmentObject(projectManager)
            .environmentObject(userManager)
        }
        .preferredColorScheme(.light)
    }
}

#Preview {
    ContentView()
}
