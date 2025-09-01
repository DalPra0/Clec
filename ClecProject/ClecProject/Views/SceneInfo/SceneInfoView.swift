//
//  SceneInfoView.swift
//  ClecProject
//
//  Created by Giovanni Galarda Strasser on 01/09/25.
//

import SwiftUI

struct SceneInfoView: View {
    let callSheet: CallSheetModel
    var body: some View {
        VStack{
            CustomReturn(text: "Diária 01")
            SceneInfoCard(
                sceneInfo: callSheet.sceneTable[0],
                shootingDate: callSheet.day,
                startTime: callSheet.getStartTime()
            )
            SceneInfoCard(
                sceneInfo: callSheet.sceneTable[0],
                shootingDate: callSheet.day,
                startTime: callSheet.getStartTime()
            )
            SceneInfoCard(
                sceneInfo: callSheet.sceneTable[0],
                shootingDate: callSheet.day,
                startTime: callSheet.getStartTime()
            )
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    SceneInfoView(callSheet: DeveloperHelper.project.callSheet[0])
}
