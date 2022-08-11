//
//  MainViewController.swift
//  SeSACWeek6th
//
//  Created by 권민서 on 2022/08/09.
//

import UIKit

import Kingfisher

/*
 tableView -> collectionView protocol
 tag
 awakeFromnib
 -> 셀 ui 초기화 재사용 메커니즘에 의해 일정 횟수 이쌍 호출되지 않음
 cellforitemat
 -> 재사용 될 때마다 사용자에게 보일 때 마다 항상 실행됨
 -> 화면과 데이터는 별개 모든 indexPath.item에 대한 조건이 없다면 재사용 시 오류가 발생할 수 있다
 awakeFromNib
 -  셀 인스턴스가 새로 만들어질 때 호출된다
 -  셀이 눈에 보일때마다 호출됨
 prepareForReuse
  - 셀이 재사용 될 때 초기화 하ㅏ고자 하는 값을 넣으면 오류를 해결할 수 있음 즉 cellForRowAt에서 모든 indexPath.item에 대한 조건을 작성하지 않아도 된다
  - nil값 줘도 된다
 CollectionView in TableView
  - 하나의 컬렉션뷰나 테이블뷰라면 문제 X
  - 복합적인 구조라면, 테이블뷰도 재사용 되어야 하고 컬렉션셀도 재사용이 되어야한다
 IndexPath Out Of Range
 -> reloadData
 
 print와 debug 습관화
 */


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
    
    //
    var episodeList: [[String]] = []
    
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
        
        TMDBAPIManager.shared.requestImage { posterList in
            dump(posterList)
            //1. 네트워크 통신  2. 배열 생성 3. 배열 담기 4. 뷰 등에 표현 ex. 테이블 뷰 섹션, 컬랙션뷰 셀 5.테이블 뷰 갱신!
            self.episodeList = posterList
            self.mainTableView.reloadData()
        }

    }
}

//하나의 프로토콜, 메서드에서 여러 컬랙션뷰의 delegate, datasource 구현해야 함
//UICollectionViewDelegateFlowLayout 역동적인 셀 => sizeForItemAt
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return collectionView == bannerCollectionView ? color.count : episodeList[collectionView.tag].count
    }
    
    //bannerCollectionView or 테이블뷰 안에 들어있는 컬렉션 뷰가 매개변수로 들어올 수 있음
    //스크롤시 사이즈가 변화하는 에러 -> 내부 매개변수가 아닌 명확한 아웃렛을 사용할 경우 셀이 재사용 되면 특정 collectionView 셀을 재사용해서 발생하는 오류
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionViewCell.identifier, for: indexPath) as? CardCollectionViewCell else {return UICollectionViewCell()}
        
        print("MainViewController", #function, indexPath)

        if collectionView == bannerCollectionView {
            cell.cardView.posterImage.backgroundColor = color[indexPath.item]
        } else {
            cell.cardView.contentLabel.textColor = .white
            cell.cardView.posterImage.backgroundColor = .black
            let url = URL(string: "\(TMDBAPIManager.shared.imageURL)\(episodeList[collectionView.tag][indexPath.item])")
            cell.cardView.posterImage.kf.setImage(with: url)
            cell.cardView.contentLabel.text = ""
            
            //화면과 데이터는 별개 모든 IndexPath,item에 대한 조건이 없다면 재사용 시 오류 발생 가능
//            if indexPath.item < 2 {
                //cell.cardView.contentLabel.text = "\(numberList[collectionView.tag][indexPath.item])"
            //}
//            else {
//                cell.cardView.contentLabel.text = "Happy"
//            }
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
        return episodeList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    //내부 매개변수 tableView를 통해 테이블뷰를 특정
    //테이블뷰 객체가 하나 일 경우에는 내부 매개변수를 활용하지 않아도 문제가 생기지 않는다
    //내부매개변수는 변경해도 상관 없음 / 외부는 바꾸지 말자
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? MainTableViewCell else { return UITableViewCell()}
        
        print("MainViewController", #function, indexPath)
        
        cell.backgroundColor = .yellow
        cell.titleLabel.text = "\(TMDBAPIManager.shared.tvList[indexPath.section].0) 드라마 다시 보기"
        cell.contentCollectionView.backgroundColor = .lightGray
        cell.contentCollectionView.delegate = self
        cell.contentCollectionView.dataSource = self
        cell.contentCollectionView.register(UINib(nibName: CardCollectionViewCell.identifier, bundle: nil),  forCellWithReuseIdentifier: CardCollectionViewCell.identifier)
        cell.contentCollectionView.tag = indexPath.section // 각 셀 구분 짓기! tag UIView
        cell.contentCollectionView.reloadData() //index out of range 해결 포함하고 있는 애한테 갱신코드 넣어야함 먼저 호출되므로, 셀의 갯수가 재사용이 안될 정도로 적을 경우 문제 발생 안됨
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240 * 3
    }
    
}
