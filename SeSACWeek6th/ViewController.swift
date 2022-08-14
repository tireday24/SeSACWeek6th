//
//  ViewController.swift
//  SeSACWeek6th
//
//  Created by 권민서 on 2022/08/08.
//

import UIKit

import Alamofire
import SwiftyJSON
import Kingfisher

/*
 1. html tag <> </> 기능 활용
 2. 문자열 대체 매서드
 
 위치 데이터 받기 전 or 데이터 받은 후
 카페 Or 테이블 뷰 셀 받을 때
 
 *response에서 처리하는 것과 보여지는 셀 등에서 처리하는 것의 차이는?
 다른 화면에서 필요할 수 있고 필요 없을수도 있음
 */

/*
 TableView automaticDimension
 - 컨텐츠 양에 따라서 셀 높이가 자유롭게
 - 조건: 레이블 NumberOfLines 0
 - 조건: tableView Height automaticDimension
 - 조건: 레이아웃 4가지에 대한 여백을 조정해줘야한다
 */

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var blogList: [String] = []
    var cafeList: [String] = []
    
    var isExpanded = false //false 2줄, true 0으로
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //실행 순서 start => end -> json
        //viewdidload에서 보여줘야 하는 의무가 있음 네트워크 통신을 하는 동안 화면띄움 까만화면 보여주면 안돼서 그 후에 response 띄움
        //세가지 동시 호출시 언제 올지 모름 -> 한번에 동시 통신 지양 순서 보장 없기 떄문에
        print(#function, "START")
        //requestBlog(query: "고래밥") // -> 카페 API -> 순서가 보장이 안되어있는데 순서를 보장하려면 어떻게 해야할까?
        print(#function, "END")
        //뷰디드로드 -> 테이블뷰 그리고 -> 갱신 -> 테이블뷰에 데이터 넣음
        //Numberofrowinsection 테이블 뷰 주문 받음
        searchBlog()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension // 모든 섹션과 셀에 대해서 유동적으로 잡겠다를 의미
        
    
    }
    
    func searchBlog() {
        KakaoAPIManager.shared.callRequest(type: .blog, query: "고래밥") { json in
            
            print(json)
            
//            for item in json["documents"].arrayValue {
//                self.blogList.append(item["contents"].stringValue)
//            }
            let item = json["documents"].arrayValue.map{ $0["contents"].stringValue}
            self.blogList.append(contentsOf: item)
            
            self.searchCafe()
        }
    }
    
    func searchCafe() {
        KakaoAPIManager.shared.callRequest(type: .cafe, query: "고래밥") { json in
            
            print(json)
            
//            for item in json["documents"].arrayValue {
//
//                let value = item["contents"].stringValue.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")
//
//
//                self.cafeList.append(value)
//            }
            let item = json["documents"].arrayValue.map{$0["contents"].stringValue.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")}
            self.cafeList.append(contentsOf: item)
            
            print(self.blogList)
            print(self.cafeList)
            
            self.tableView.reloadData()
            
        }
    }
    
    
    @IBAction func expandCell(_ sender: UIBarButtonItem) {
        
        isExpanded = !isExpanded
        tableView.reloadData()
        
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 {
//            return blogList.count
//        } else {
//            return cafeList.count
//        }
        return section == 0 ? blogList.count : cafeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: kakaoCell.identifier) as? kakaoCell else { return UITableViewCell()}
        
        cell.testLable.numberOfLines = isExpanded ? 0 : 2 // 0이 아니면 2줄 제한
        cell.testLable.text = indexPath.section == 0 ? blogList[indexPath.row] : cafeList[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "블로그 검색결과" : "카페 검색결과"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension // 특정 셀에 대해서만 설정 가능
    }

  
}

class kakaoCell: UITableViewCell {
    
    static let identifier = "kakaoCell"
    
    @IBOutlet weak var testLable: UILabel!
    
}
