import SwiftUI

struct ContentView: View {
    @StateObject private var projectManager = ProjectManager()
    @StateObject private var userManager = UserManager()
    
    @EnvironmentObject var authService: AuthService
    
    var body: some View {
        Group {
            if authService.userSession != nil {
                NavigationView {
                    Group {
                        if projectManager.hasProjects {
                            DashboardView()
                        } else {
                            InitialView()
                        }
                    }
                }
                .environmentObject(projectManager)
                .environmentObject(userManager)
            } else {
                LoginView()
            }
        }
        .preferredColorScheme(.light)
    }
}
