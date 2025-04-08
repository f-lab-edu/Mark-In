//
//  Font.swift
//  DesignSystem
//
//  Created by 이정동 on 4/8/25.
//

import Foundation
import CoreText
import SwiftUI

public extension Font {
    enum Pretendard: String, CaseIterable {
        case black = "Pretendard-Black"
        case extraBold = "Pretendard-ExtraBold"
        case bold = "Pretendard-Bold"
        case semiBold = "Pretendard-SemiBold"
        case medium = "Pretendard-Medium"
        case regular = "Pretendard-Regular"
        case light = "Pretendard-Light"
        case extraLight = "Pretendard-ExtraLight"
        case thin = "Pretendard-Thin"
    }
    
    static func pretendard(size: CGFloat, weight: Pretendard) -> Font {
        return .custom(weight.rawValue, size: size)
    }
}

public class FontLoader {
    
    public static func registerFont() {
        let bundleIdentifier = "kr.co.ios.swift.apple.DesignSystem"
        
        guard let bundle = Bundle(identifier: bundleIdentifier) else {
            print("Failed to find bundle with identifier: \(bundleIdentifier)")
            return
        }
        
        Font.Pretendard.allCases.forEach {
            guard let url = bundle.url(forResource: "\($0.rawValue)", withExtension: ".ttf"),
                  CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil) else {
                print("fail register font")
                return
            }
        }
        
        print("등록 성공")
    }
}
