//
//  CardCollectionViewCell.swift
//  SeSACWeek6th
//
//  Created by 권민서 on 2022/08/09.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cardView: CardView!
    
    static let identifier = "CardCollectionViewCell"
    
    //변경되지 않는 UI 재사용 메커니즘에서 항상 작동하게 할 필요 없다(color font 등)
    //cellForRowAt보다 먼저 동작
    override func awakeFromNib() {
        super.awakeFromNib()
        
        print("CardCollectionViewCell", #function)
        
        setupUI()
    }
    
    //override는 항상 부모 클래스가 따라 다닌다
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cardView.contentLabel.text = "A"
    }
    
    //셀이 만들어지는 순간에만 호출 재사용때는 호출X
    func setupUI() {
        cardView.backgroundColor = .clear
        cardView.posterImage.backgroundColor = .lightGray
        cardView.posterImage.layer.cornerRadius = 10
        cardView.likeButton.tintColor = .systemPink
    }

    
}
