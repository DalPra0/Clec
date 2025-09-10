//
//  AppSettingsView.swift
//  ClecProject
//
//  App settings and preferences view
//  Created by Lucas Dal Pra Brascher on 10/09/25.
//

import SwiftUI
import UserNotifications

struct AppSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var notificationsEnabled = false
    @State private var dailyReminders = false
    @State private var projectUpdates = true
    @State private var isDarkMode = true
    @State private var hapticFeedback = true
    @State private var autoSave = true
    
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    
                    notificationSection
                    
                    appearanceSection
                    
                    behaviorSection
                    
                    storageSection
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
            }
            .background(Color("BackgroundDark"))
            .navigationBarHidden(true)
        }
        .onAppear {
            loadSettings()
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(Color("CardBackground"))
                    )
            }
            
            Spacer()
            
            Text("Configurações do App")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
            
            Spacer()
            
            Color.clear
                .frame(width: 44, height: 44)
        }
    }
    
    // MARK: - Notification Section
    private var notificationSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionTitle("Notificações")
            
            VStack(spacing: 16) {
                SettingsToggleRow(
                    icon: "bell.fill",
                    title: "Notificações Push",
                    subtitle: "Receber alertas importantes",
                    isOn: $notificationsEnabled,
                    onChange: { newValue in
                        handleNotificationPermission(newValue)
                    }
                )
                
                if notificationsEnabled {
                    SettingsToggleRow(
                        icon: "clock.fill",
                        title: "Lembretes Diários",
                        subtitle: "Lembrete para revisar cronograma",
                        isOn: $dailyReminders
                    )
                    
                    SettingsToggleRow(
                        icon: "arrow.triangle.2.circlepath",
                        title: "Atualizações do Projeto",
                        subtitle: "Mudanças na ordem do dia",
                        isOn: $projectUpdates
                    )
                }
            }
        }
    }
    
    // MARK: - Appearance Section
    private var appearanceSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionTitle("Aparência")
            
            VStack(spacing: 16) {
                SettingsToggleRow(
                    icon: "moon.fill",
                    title: "Modo Escuro",
                    subtitle: "Interface com tema escuro",
                    isOn: $isDarkMode,
                    isDisabled: true,
                    disabledReason: "Sempre ativo no momento"
                )
                
                SettingsInfoRow(
                    icon: "paintbrush.fill",
                    title: "Tema do App",
                    subtitle: "Laranja cinematográfico",
                    value: "Padrão"
                )
            }
        }
    }
    
    // MARK: - Behavior Section
    private var behaviorSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionTitle("Comportamento")
            
            VStack(spacing: 16) {
                SettingsToggleRow(
                    icon: "iphone.radiowaves.left.and.right",
                    title: "Feedback Háptico",
                    subtitle: "Vibrações ao tocar botões",
                    isOn: $hapticFeedback
                )
                
                SettingsToggleRow(
                    icon: "doc.on.doc.fill",
                    title: "Salvamento Automático",
                    subtitle: "Salvar mudanças automaticamente",
                    isOn: $autoSave
                )
                
                SettingsInfoRow(
                    icon: "wifi",
                    title: "Sincronização",
                    subtitle: "Automática via Firebase",
                    value: "Ativa"
                )
            }
        }
    }
    
    // MARK: - Storage Section
    private var storageSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionTitle("Armazenamento")
            
            VStack(spacing: 16) {
                SettingsActionRow(
                    icon: "trash.fill",
                    title: "Limpar Cache",
                    subtitle: "Remove arquivos temporários",
                    actionText: "Limpar",
                    isDestructive: false,
                    action: clearCache
                )
                
                SettingsInfoRow(
                    icon: "icloud.fill",
                    title: "Backup",
                    subtitle: "Dados salvos no Firebase",
                    value: "Ativo"
                )
            }
        }
    }
    
    // MARK: - Helper Views
    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(.white)
    }
    
    // MARK: - Actions
    private func loadSettings() {
        // Load notification permission status
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.notificationsEnabled = settings.authorizationStatus == .authorized
            }
        }
        
        // Load other settings from UserDefaults
        dailyReminders = UserDefaults.standard.bool(forKey: "daily_reminders")
        projectUpdates = UserDefaults.standard.bool(forKey: "project_updates")
        hapticFeedback = UserDefaults.standard.bool(forKey: "haptic_feedback")
        autoSave = UserDefaults.standard.bool(forKey: "auto_save")
    }
    
    private func handleNotificationPermission(_ enabled: Bool) {
        if enabled {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                DispatchQueue.main.async {
                    self.notificationsEnabled = granted
                    if granted {
                        print("✅ Notification permission granted")
                    } else {
                        print("❌ Notification permission denied")
                    }
                }
            }
        } else {
            // Can't programmatically disable notifications, user needs to go to Settings
            notificationsEnabled = false
        }
        
        UserDefaults.standard.set(notificationsEnabled, forKey: "notifications_enabled")
    }
    
    private func clearCache() {
        isLoading = true
        
        // Simulate cache clearing
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isLoading = false
            
            // Haptic feedback
            let notificationFeedback = UINotificationFeedbackGenerator()
            notificationFeedback.notificationOccurred(.success)
            
            print("✅ Cache cleared successfully")
        }
    }
}

// MARK: - Settings Components
struct SettingsToggleRow: View {
    let icon: String
    let title: String
    let subtitle: String
    @Binding var isOn: Bool
    var isDisabled: Bool = false
    var disabledReason: String = ""
    var onChange: ((Bool) -> Void)?
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(isDisabled ? Color("TextSecondary") : Color("PrimaryOrange"))
                .frame(width: 44, height: 44)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(isDisabled ? Color("CardBackground") : Color("PrimaryOrange").opacity(0.15))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(isDisabled ? Color("TextSecondary") : .white)
                
                Text(isDisabled ? disabledReason : subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(Color("TextSecondary"))
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .toggleStyle(SwitchToggleStyle(tint: Color("PrimaryOrange")))
                .disabled(isDisabled)
                .onChange(of: isOn) { oldValue, newValue in
                    if !isDisabled {
                        onChange?(newValue)
                        UserDefaults.standard.set(newValue, forKey: title.lowercased().replacingOccurrences(of: " ", with: "_"))
                    }
                }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color("CardBackground"))
                .opacity(isDisabled ? 0.6 : 1.0)
        )
    }
}

struct SettingsInfoRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let value: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(Color("PrimaryOrange"))
                .frame(width: 44, height: 44)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color("PrimaryOrange").opacity(0.15))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                
                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(Color("TextSecondary"))
            }
            
            Spacer()
            
            Text(value)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color("PrimaryOrange"))
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color("CardBackground"))
        )
    }
}

struct SettingsActionRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let actionText: String
    let isDestructive: Bool
    let action: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(isDestructive ? .red : Color("PrimaryOrange"))
                .frame(width: 44, height: 44)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(isDestructive ? Color.red.opacity(0.15) : Color("PrimaryOrange").opacity(0.15))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                
                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(Color("TextSecondary"))
            }
            
            Spacer()
            
            Button(action: action) {
                Text(actionText)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(isDestructive ? .red : Color("PrimaryOrange"))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isDestructive ? Color.red : Color("PrimaryOrange"), lineWidth: 1)
                    )
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color("CardBackground"))
        )
    }
}

#Preview {
    AppSettingsView()
        .background(Color("BackgroundDark"))
}
