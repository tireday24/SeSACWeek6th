//
//  SeSACButton.swift
//  SeSACWeek6th
//
//  Created by 권민서 on 2022/08/09.
//

import UIKit

/*
 Swift Attribute(속성)
 @IBInspectable, @IBDesignable, @objc, @escaping, @available, @discardableResult, etc.
 */

//인터페이스 빌더 컴파일 시점 실시간으로 객체 속성을 확일할 수 있음
//인스펙터에서 없는 부분 만들어 보자
@IBDesignable class SeSACButton: UIButton {
    //스토리보드 상에 inspector 영역
    //인터페이스 빌더 인스펙터 영역 Show
   @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }

}
