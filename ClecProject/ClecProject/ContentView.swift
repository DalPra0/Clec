import SwiftUI

struct ContentView: View {
    @StateObject private var projectManager = ProjectManager()
    @StateObject private var userManager = UserManager()
    
    @EnvironmentObject var authService: AuthService
    
    var body: some View {
        Group {
            if authService.userSession != nil {
                // Main authenticated view
                if projectManager.activeProject != nil {
                    DashboardView()
                        .environmentObject(projectManager)
                        .environmentObject(userManager)
                } else {
                    InitialView()
                        .environmentObject(projectManager)
                        .environmentObject(userManager)
                }
            } else {
                LoginView()
            }
        }
        // REMOVIDO: .preferredColorScheme(.light) - AGORA É AUTOMÁTICO!
    }
}
