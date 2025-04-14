//
//  DesignSystem.swift
//  DesignSystem
//
//  Created by 이정동 on 4/8/25.
//


import SwiftUI

public extension Color {
    static let sampleColor: Color = .test
}

public extension ShapeStyle where Self == Color {
    static var sampleColor: Self { .test }
}
