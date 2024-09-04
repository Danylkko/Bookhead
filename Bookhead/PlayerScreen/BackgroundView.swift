//
//  BackgroundView.swift
//  Bookhead
//
//  Created by Danylo Litvinchuk on 07.09.2024.
//

import SwiftUI

struct BackgroundView<T: View>: View {
    
    var backgroundColor: AppColor
    var content: () -> T
    
    var body: some View {
        ZStack {
            backgroundColor.color.ignoresSafeArea()
            content()
        }
    }
}
