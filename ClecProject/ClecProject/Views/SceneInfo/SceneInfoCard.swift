//
//  SceneInfoCardView.swift
//  ClecProject
//
//  Created by Giovanni Galarda Strasser on 01/09/25.
//

import SwiftUI

struct SceneInfoCard: View {
    let sceneInfo: CallSheetLineInfo
    let shootingDate: Date
    let startTime: Date?
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: shootingDate)
    }
    
    private var formattedTime: String {
        guard let time = startTime else { return "--:--" }
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: time)
    }
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Cena \(String(format: "%02d", sceneInfo.scene)) - \(sceneInfo.location.name)")
                    .font(.system(size: 20, weight: .bold))
                
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                    Text(formattedDate)
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
            
            Spacer()
            Text(formattedTime)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.green.opacity(0.8))
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.green.opacity(0.2))
                .cornerRadius(12)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    let mockScene = DeveloperHelper.project.callSheet[0].sceneTable[0]
    let mockDate = DeveloperHelper.project.callSheet[0].day
    let mockTime = DeveloperHelper.project.callSheet[0].getStartTime()

    return SceneInfoCard(
        sceneInfo: mockScene,
        shootingDate: mockDate,
        startTime: mockTime
    )
    .padding()
    .background(Color.gray.opacity(0.1))
}
