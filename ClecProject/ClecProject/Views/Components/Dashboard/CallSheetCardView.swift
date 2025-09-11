//
//  CallSheetCardView.swift
//  ClecProject
//
//  Created by Gemini
//

import SwiftUI

struct CallSheetCardView: View {
    let callSheet: CallSheetModel
    
    var body: some View {
        HStack(spacing: 0) {
            // Color Bar
            callSheet.callSheetColor.swiftUIColor
                .frame(width: 8)
            
            // Content
            VStack(alignment: .leading, spacing: 12) {
                Text(callSheet.sheetName)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(Color("TextPrimary"))
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(formattedDateAndTime())
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color("TextSecondary"))
                    
                    HStack(spacing: 8) {
                        Image(systemName: "mappin.and.ellipse")
                            .font(.system(size: 14))
                        Text(callSheet.getLocation()?.address ?? "Local não definido")
                    }
                    .font(.system(size: 14))
                    .foregroundColor(Color("TextSecondary"))
                    
                    // Optional Reminder Row
                    // This can be implemented when reminder logic is added
                    /*
                    HStack(spacing: 8) {
                        Image(systemName: "bell.fill")
                            .font(.system(size: 14))
                        Text("30 minutos antes")
                    }
                    .font(.system(size: 14))
                    .foregroundColor(Color("TextSecondary"))
                    */
                }
            }
            .padding(16)
            
            Spacer()
        }
        .background(Color("CardBackground"))
        .cornerRadius(12)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private func formattedDateAndTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "pt_BR")
        dateFormatter.dateFormat = "EEE. dd 'de' MMMM"
        let datePart = dateFormatter.string(from: callSheet.day)

        guard let startTime = callSheet.getStartTime(), let endTime = callSheet.getEndTime() else {
            return datePart
        }

        let startTimeFormatter = DateFormatter()
        startTimeFormatter.locale = Locale(identifier: "en_US_POSIX")
        startTimeFormatter.dateFormat = "H:mm"
        let startTimeString = startTimeFormatter.string(from: startTime)

        let endTimeFormatter = DateFormatter()
        endTimeFormatter.locale = Locale(identifier: "en_US_POSIX")
        endTimeFormatter.dateFormat = "h:mm a"
        var endTimeString = endTimeFormatter.string(from: endTime).lowercased()
        endTimeString = endTimeString.replacingOccurrences(of: ":00", with: "")

        return "\(datePart) . \(startTimeString) - \(endTimeString)"
    }
}
