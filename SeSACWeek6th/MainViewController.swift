//
//  MainViewController.swift
//  SeSACWeek6th
//
//  Created by 권민서 on 2022/08/09.
//

import UIKit

class MainViewController: UIViewController {
    
    //contentCollectionView도 delegate, datasource가 필요함 rootView인 mainController가 위임
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var mainTableView: UITableView!
    
    let color: [UIColor] = [.red, .systemPink, .lightGray, .yellow, .black]
    
    let numberList: [[Int]] = [
        [Int](100...110),
        [Int](55...75),
        [Int](5000...5006),
        [Int](51...60),
        [Int](71...80),
        [Int](81...90),
        [Int](51...60),
        [Int](71...80),
        [Int](81...90),
        [Int](11...20)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
        bannerCollectionView.register(UINib(nibName: CardCollectionViewCell.identifier, bundle: nil),  forCellWithReuseIdentifier: CardCollectionViewCell.identifier)
        bannerCollectionView.collectionViewLayout = collectionViewLayout()
        //착착 붙는 느낌, 단점 디바이스의 width 기준으로 항상 처리 셀이 디바이스 Width랑 다를 경우 코드가 추가적으로 필요하다
        bannerCollectionView.isPagingEnabled = true
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
                                    
    
    }
    
    
    

}

//하나의 프로토콜, 메서드에서 여러 컬랙션뷰의 delegate, datasource 구현해야 함
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return collectionView == bannerCollectionView ? color.count : numberList[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionViewCell.identifier, for: indexPath) as? CardCollectionViewCell else {return UICollectionViewCell()}
        

        if collectionView == bannerCollectionView {
            cell.cardView.posterImage.backgroundColor = color[indexPath.item]
        } else {
            cell.cardView.contentLabel.text = "\(numberList[collectionView.tag][indexPath.item])"
            cell.cardView.contentLabel.textColor = .white
            cell.cardView.posterImage.backgroundColor = .black
        }
        
        return cell
    }
    
    func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: bannerCollectionView.frame.height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return layout
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? MainTableViewCell else { return UITableViewCell()}
        
        cell.backgroundColor = .yellow
        cell.contentCollectionView.backgroundColor = .lightGray
        cell.contentCollectionView.delegate = self
        cell.contentCollectionView.dataSource = self
        cell.contentCollectionView.register(UINib(nibName: CardCollectionViewCell.identifier, bundle: nil),  forCellWithReuseIdentifier: CardCollectionViewCell.identifier)
        cell.contentCollectionView.tag = indexPath.section // 각 셀 구분 짓기!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 3 ? 350 : 190
    }
    
}
