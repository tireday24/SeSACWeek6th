//
//  Endpoint.swift
//  SeSACWeek6th
//
//  Created by 권민서 on 2022/08/08.
//

import Foundation

//enum에서 저장 프로퍼티는 못 쓰고 연산 프로퍼티는 쓸 수 있는 이유?
// 메서드 처럼 작동해서
enum Endpoint {
    case blog
    case cafe
    // 저장 프로퍼티를 못 쓰는 이유?
    var requestURL: String {
        switch self {
        case .blog:
            return URL.makeEndPointString("blog?query=")
        case .cafe:
            return URL.makeEndPointString("cafe?query=")
        }
    }
}

