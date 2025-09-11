import SwiftUI

struct ContentView: View {
    @StateObject private var projectManager = ProjectManager()
    @StateObject private var userManager = UserManager()
    
    @EnvironmentObject var authService: AuthService
    
    @State var isUserOld = UserDefaults.standard.bool(forKey: "isUserOld")
    
    var body: some View {
        Group {
            if isUserOld {
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
            } else {
                OnboardingView(isUserOldLocal: $isUserOld)
            }
        }
        .onAppear{
            print(isUserOld)
            //p/ ver o onboarding de novo eh so descomentar essa parada kk..
//            UserDefaults.standard.set(false, forKey: "isUserOld")
        }
        .preferredColorScheme(.light)
    }
}
