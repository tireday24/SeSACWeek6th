//
//  ClosureViewController.swift
//  SeSACWeek6th
//
//  Created by 권민서 on 2022/08/08.
//

import UIKit
import SwiftUI

class ClosureViewController: UIViewController {

    @IBOutlet weak var orangView: UIView!
    @IBOutlet var cardView: CardView!
    
    //Frame Based
    var sampleButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //위치 크기 추가
        /*
         오토리사이징을 오토레이아웃 제약조건처럼 설정해주는 기능이 내부적으로 구현되어 있음
         이 기능은 디폴트가 true 하지만 autolayout을 지정해주면 autoresizing을 안스겠다는 의미인 false로 상태가 내부적으로 변경됨 오토리사이징 + 오토레이아웃 = 충돌
         코드 기반 UI -> true
         인터페이스 빌더 기반 레이아웃 UI -> false
         autoresizing -> autolayout constraints
         */
        print(orangView.translatesAutoresizingMaskIntoConstraints)
        print(sampleButton.translatesAutoresizingMaskIntoConstraints)
        print(cardView.translatesAutoresizingMaskIntoConstraints)
        
        sampleButton.frame = CGRect(x: 100, y: 400, width: 100, height: 100)
        sampleButton.backgroundColor = .red
        view.addSubview(sampleButton)
        
        cardView.posterImage.backgroundColor = .red
        cardView.likeButton.backgroundColor = .yellow
        cardView.likeButton.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)

       
    }
    
    @objc func likeButtonClicked() {
        print("버튼 클릭")
    }
    

    @IBAction func colorPickerButtonClicked(_ sender: UIButton) {
        showAlert(title: "컬러피커", message: "띄우시겠습니까?", okTitle: "띄우기") {
            let picker = UIColorPickerViewController() // UIFontViewCOntroller
            self.present(picker, animated: true) // 클로저뷰컨의 인스턴스인것을 명확하게 해주기 위해 self
        }
    }
    
    @IBAction func backgrouundColorChanged(_ sender: UIButton) {
        showAlert(title: "배경색 변경", message: "배경색을 바꾸시겠습니까?", okTitle: "바꾸기") {
            self.view.backgroundColor = .gray
        }
    }
    
    
    
    
}

extension UIViewController {
    func showAlert(title: String, message: String?, okTitle: String, okAction: @escaping () -> ()){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancle = UIAlertAction(title: "취소", style: .cancel)
        let ok = UIAlertAction(title: okTitle, style: .default) { action in
            
            okAction()
            
        }
        
        alert.addAction(cancle)
        alert.addAction(ok)
        
        present(alert, animated: true)
    }
}
