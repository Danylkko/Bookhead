//
//  PlaybackListView.swift
//  Bookhead
//
//  Created by Danylo Litvinchuk on 04.09.2024.
//

import SwiftUI

struct PlayerTextTab: View {
    var body: some View {
        VStack {
            Text("Hello")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            AppColor.playerBackgroundColor.color
                .ignoresSafeArea()
        }
    }
}

#Preview {
    PlayerTextTab()
}
