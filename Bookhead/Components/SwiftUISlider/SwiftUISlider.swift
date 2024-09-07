//
//  SwiftUISlider.swift
//  Bookhead
//
//  Created by Danylo Litvinchuk on 07.09.2024.
//

import SwiftUI

struct SwiftUISlider: UIViewRepresentable {
    
    final class Coordinator: NSObject {
        @Binding var value: Double
        var range: Range<Double>
        
        init(value: Binding<Double>, range: Range<Double>) {
            self._value = value
            self.range = range
        }
        
        @objc func valueChanged(_ sender: UISlider) {
            let normalizedValue = mapValue(Double(sender.value), from: 0.0..<1.0, to: range)
            self.value = normalizedValue
        }
        
        private func mapValue(_ value: Double, from: Range<Double>, to: Range<Double>) -> Double {
            return ((value - from.lowerBound) / (from.upperBound - from.lowerBound)) * (to.upperBound - to.lowerBound) + to.lowerBound
        }
    }
    
    var thumbColor: UIColor = .white
    var tintColor: UIColor = .systemBlue
    var range: Range<Double> = 0.0..<1.0
    @Binding var value: Double
    
    init(
        thumbColor: Color,
        range: Range<Double>,
        value: Binding<Double>
    ) {
        self.thumbColor = UIColor(thumbColor)
        self.range = range
        self._value = value
    }
    
    func makeUIView(context: Context) -> UISlider {
        let slider = UISlider(frame: .zero)
        slider.isContinuous = false
        slider.thumbTintColor = thumbColor
        slider.minimumTrackTintColor = tintColor
        
        let normalizedInitialValue = mapValue(value, from: range, to: 0.0..<1.0)
        slider.value = Float(normalizedInitialValue)
        
        slider.addTarget(
            context.coordinator,
            action: #selector(Coordinator.valueChanged(_:)),
            for: .valueChanged
        )
        
        return slider
    }
    
    func updateUIView(_ uiView: UISlider, context: Context) {
        let normalizedValue = mapValue(value, from: range, to: 0.0..<1.0)
        uiView.value = Float(normalizedValue)
        context.coordinator.range = range
    }
    
    func makeCoordinator() -> SwiftUISlider.Coordinator {
        Coordinator(value: $value, range: range)
    }
    
    private func mapValue(_ value: Double, from: Range<Double>, to: Range<Double>) -> Double {
        return ((value - from.lowerBound) / (from.upperBound - from.lowerBound)) * (to.upperBound - to.lowerBound) + to.lowerBound
    }
}
