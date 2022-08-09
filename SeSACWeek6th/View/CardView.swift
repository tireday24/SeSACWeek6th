//
//  CardView.swift
//  SeSACWeek6th
//
//  Created by 권민서 on 2022/08/09.
//

import UIKit

/*
 Xml Interface Builder -> 재사용성 때문에 사용
 1. UIView Custom Class
 2. File's Owner => 활용도 / 여러 View 제약
 
 */

/*
 View: 인터페이스 빌더 UI 초기화 구문 <-> 코드 UI 초기화 구문
 전자 required init -> required 붙어있으면 프로토콜에서 왔다
 -> 프로토콜 초기화 구문: required -> 초기화 구문이 프로토콜로 명세되어 있음
 후자 override init
 
 */
protocol A {
    func example()
    init()
}

class CardView: UIView {

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var contentLabel: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //fatalError("init(coder:) has not been implemented")
        
        let view = UINib(nibName: "CardView", bundle: nil).instantiate(withOwner: self).first as! UIView
        view.frame = bounds
        view.backgroundColor = .lightGray
        self.addSubview(view)
    }
    
    
}
