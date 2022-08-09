//
//  ClosureViewController.swift
//  SeSACWeek6th
//
//  Created by 권민서 on 2022/08/08.
//

import UIKit
import SwiftUI

class ClosureViewController: UIViewController {

    @IBOutlet var cardView: CardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
