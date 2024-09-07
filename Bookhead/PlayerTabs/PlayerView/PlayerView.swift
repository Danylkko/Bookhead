//
//  PlayerView.swift
//  Bookhead
//
//  Created by Danylo Litvinchuk on 04.09.2024.
//

import SwiftUI
import ComposableArchitecture

struct PlayerView: View {
    
    @Bindable var albumStore: StoreOf<PlayerFeature>
    @Bindable var songStore: StoreOf<PlaybackFeature>
    
    enum Constants {
        static var coverWidth: CGFloat {
            return coverHeight / 1.59 // the golden ratio
        }
        
        static var coverHeight: CGFloat {
            return GlobalConstants.screenHeight / 2.6
        }
        static let coverCornerRadius: CGFloat = 25
        static let textStackSpacing: CGFloat = 12
        static let mainStackSpacing: CGFloat = 30
        static let mainStackPadding: CGFloat = 16
        static let controlPadStackSpacing: CGFloat = 30
        static let controlPadHeight: CGFloat = 40
        static let speedButtonCornerRadius: CGFloat = 8
        static let sliderViewHorizontalSpacing: CGFloat = 4
        static let textHorizontalPadding: CGFloat = 20
    }
    
    let controls: [PlaybackControlItem] = [.backwards, .goBackwards5, .play, .goForwards10, .forwards]
    
    var body: some View {
        VStack(spacing: Constants.mainStackSpacing) {
            artworkImage(for: albumStore.artwork)
                .clipShape(RoundedRectangle(cornerRadius: Constants.coverCornerRadius))
                .frame(
                    width: Constants.coverWidth,
                    height: Constants.coverHeight
                )
            
            VStack(spacing: Constants.textStackSpacing) {
                Text("KEY POINT \(albumStore.currentIndex + 1) OF \(albumStore.totalNumber)")
                    .font(.bold15)
                    .foregroundStyle(AppColor.grayTextColor.color)
                Text("Written by \(albumStore.artist ?? "NOT_FOUND")")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Constants.textHorizontalPadding)
            }
            .foregroundStyle(AppColor.blackTextColor.color)
            sliderView
            speedButton
            controlPad
            Spacer()
        }
        .padding(.horizontal, Constants.mainStackPadding)
        .padding(.top, Constants.mainStackPadding)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            AppColor.playerBackgroundColor.color
                .ignoresSafeArea()
        }
    }
    
    @ViewBuilder
    private func artworkImage(for data: Data?) -> some View {
        if let data = albumStore.artwork,
           let artwork = UIImage(data: data)
        {
            Image(uiImage: artwork)
                .resizable()
        } else {
            Color.red
        }
    }
    
    private var sliderView: some View {
        HStack(spacing: Constants.sliderViewHorizontalSpacing) {
            Text("\(songStore.timeInMinutes)")
                .font(.medium14)
                .foregroundStyle(AppColor.grayTextColor.color)
            SwiftUISlider(
                thumbColor: AppColor.playbackSliderTintColor.color,
                range: 0..<songStore.totalTime,
                value: Binding(
                    get: { songStore.currentTime },
                    set: { newValue in songStore.send(.startFrom(time: newValue))}
                )
            )
            .tintColor(AppColor.playbackSliderTintColor.color)
            .gesture(DragGesture().onChanged{ _ in
                songStore.send(.releaseSlider)
            })
            Text("\(songStore.totalTimeInMinutes)")
                .font(.medium14)
                .foregroundStyle(AppColor.grayTextColor.color)
        }
    }
    
    private var speedButton: some View {
        Menu {
            ForEach(PlaybackSpeed.allCases, id: \.rawValue) { item in
                Button {
                    songStore.send(.changeSpeed(item))
                } label: {
                    Text("x\(item.displayValue)")
                }
            }
        } label: {
            Text("Speed x\(songStore.playbackSpeed.displayValue)")
                .font(.semibold14)
                .frame(width: 80, height: 35)
                .foregroundStyle(AppColor.blackTextColor.color)
                .background(AppColor.grayButtonBackgroundColor.color)
                .clipShape(RoundedRectangle(cornerRadius: Constants.speedButtonCornerRadius))
        }
        .disabled(!songStore.isChangingSpeedEnabled)
    }
    
    private var controlPad: some View {
        LazyHStack(spacing: Constants.controlPadStackSpacing) {
            ForEach(Array(controls.enumerated()), id: \.offset) { index, item in
                VStack {
                    switch item {
                    case .play, .pause:
                        PlaybackControlView(item: songStore.isPlaying ? .pause : .play) {
                            if songStore.isPlaying {
                                songStore.send(.pause)
                            } else {
                                songStore.send(.resume)
                            }
                        }
                    default:
                        PlaybackControlView(item: item) {
                            switch item {
                            case .backwards:
                                songStore.send(.changeTrack(next: false))
                            case .goBackwards5:
                                songStore.send(.rewind(seconds: -5))
                            case .goForwards10:
                                songStore.send(.rewind(seconds: 10))
                            case .forwards:
                                songStore.send(.changeTrack(next: true))
                            default:
                                return
                            }
                        }
                    }
                }
                .scaleEffect(calculateScale(for: index, total: controls.count))
            }
        }
        .frame(height: Constants.controlPadHeight)
    }
    
    /**
     Example: [0.7, 0.85, 1.0, 0.85, 0.7]
     */
    func calculateScale(for index: Int, total: Int) -> CGFloat {
        let middleIndex = total / 2
        let baseScale: CGFloat = 0.7
        let maxScale: CGFloat = 1.0
        let step: CGFloat = (maxScale - baseScale) / CGFloat(middleIndex)
        let distanceFromMiddle = abs(index - middleIndex)
        
        return baseScale + (step * CGFloat(middleIndex - distanceFromMiddle))
    }
    
}

#Preview {
    PlayerTabsView(
        store: .init(
            initialState: .initial,
            reducer: { AppFeature() }
        )
    )
}
