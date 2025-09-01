//
//  RentalDisplay.swift
//  ClecProject
//
//  Created by Giovanni Galarda Strasser on 31/08/25.
//

import SwiftUI

struct RentalDisplay: View {
    let callSheet: CallSheetModel
    let index: Int
    let onSelect: (Int) -> Void
    
    
    //Formata as datas para mostrar igual no figma
    func getDate() -> String {

        let startTimeDate = callSheet.getStartTime()
        let endTimeDate = callSheet.getEndTime()

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "pt_BR")
        
        dateFormatter.dateFormat = "EEE"
        let weekday = dateFormatter.string(from: callSheet.day).capitalized + "."
        
        dateFormatter.dateFormat = "d 'de' MMMM"
        let dayAndMonth = dateFormatter.string(from: callSheet.day)
        
        let datePart = "\(weekday) \(dayAndMonth)"
        
        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let timePart: String

        if let startDate = startTimeDate, let endDate = endTimeDate {
            timeFormatter.dateFormat = "H:mm"
            let startTime = timeFormatter.string(from: startDate)
            
            timeFormatter.dateFormat = "h a"
            let endTime = timeFormatter.string(from: endDate).lowercased()
            
            timePart = " . \(startTime) - \(endTime)"
            
        } else if let startDate = startTimeDate {
            timeFormatter.dateFormat = "H:mm"
            let startTime = timeFormatter.string(from: startDate)
            timePart = " . \(startTime)"
            
        } else if let endDate = endTimeDate {
            timeFormatter.dateFormat = "h a"
            let endTime = timeFormatter.string(from: endDate).lowercased()
            timePart = " . \(endTime)"
            
        } else if let singleDate = callSheet.schedule.first?.time, callSheet.schedule.count == 1 {
            timeFormatter.dateFormat = "H:mm"
            let singleTime = timeFormatter.string(from: singleDate)
            timePart = " . \(singleTime)"
            
        } else {
            timePart = ""
        }
    
        return datePart + timePart
    }
    
    var body: some View {
        NavigationLink(destination: SceneInfoView(callSheet: callSheet)){
            ZStack {
                HStack(spacing: -340){
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundStyle(callSheet.callSheetColor.swiftUIColor)
                        .shadow(radius: 8, x: 0, y: 4)
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundStyle(Color.white)
                }
                VStack(alignment:.leading, spacing: 8){
                    HStack{
                        Text(callSheet.sheetName)
                            .font(.title)
                            .fontWeight(.semibold)
                        Spacer()
                    }
                    
                    HStack{
                        Text(getDate())
                            .font(.subheadline)
                            .fontWeight(.light)
                        Spacer()
                    }
                    HStack{
                        Image(systemName: "mappin")
                        Text(callSheet.getLocation()?.address ?? "")
                            .font(.subheadline)
                            .fontWeight(.regular)
                        Spacer()
                    }
                    Spacer()
                }
                .foregroundStyle(.black)
                .padding(.vertical, 16)
                .padding(.horizontal, 32)
                .multilineTextAlignment(.leading)
            }
            .frame(height: 128)
        }

        }
}

#Preview {
    RentalDisplay(callSheet: DeveloperHelper.project.callSheet[0], index: 0, onSelect: ({ _ in }))
        .padding(.horizontal, 16)
}
