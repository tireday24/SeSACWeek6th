//
//  MainTableViewCell.swift
//  SeSACWeek6th
//
//  Created by 권민서 on 2022/08/09.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentCollectionView: UICollectionView!
    
    //awakeFromNib은 한번만 호출 그래서 폰트 유아이컬러 같은건 여기서 지정
    override func awakeFromNib() {
        super.awakeFromNib()
        print("MainTableViewCell", #function)
        setupUI()
    }
    
    private func setupUI() {
        
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.text = "넷플릭스 인기컨텐츠"
        titleLabel.backgroundColor = .clear
        
        contentCollectionView.backgroundColor = .clear
        contentCollectionView.collectionViewLayout = collectionViewLayout()
        
        
    }
    
    private func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 300, height: 180)
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        return layout
    }

}
