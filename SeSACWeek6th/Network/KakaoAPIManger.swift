//
//  KakaoAPIManger.swift
//  SeSACWeek6th
//
//  Created by 권민서 on 2022/08/08.
//

import Foundation

import Alamofire
import SwiftyJSON

struct User {
    fileprivate let name = "고래밥" //같은 스위프트 파일에서 다른 클래스 구조체 사용 가능 다른 스위프트 파일은 X
    private let age = 11 //같은 스위프트 파일 내에서 같은 타입 대해서만 접근 가능
}
extension User {
    func example() {
        print(self.name, self.age)
    }
}

struct Person {
    
    func example() {
        let user = User()
        user.name
        //user.age X
    }
    
}

class KakaoAPIManager {
    
    static let shared = KakaoAPIManager()
    private init() {}
    
    private let header: HTTPHeaders = ["Authorization": "KakaoAK \(APIKey.kakao)"]
    
    func callRequest(type: Endpoint, query: String, completionHandler: @escaping (JSON) -> ()) {
        print(#function)
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let url = type.requestURL + query
        
        //접두어 -> AF 알라모파이어에서 url주소로 들어가고 get 방식 유효성 검사(상태코드) 실행 ex) 200 = 성공 response 데이터 가져오겠다
        //Alamofire -> URLSession Framework -> 비동기로 request
        //almofire가 자동으로 메인스레드로 바꿔줌
        //뜨기전에 네트워크 요청 -> Response -> request시점에 Urlsession에 비동기가 처리되도록 백그라운드에서 비동기 처리 -> 메인 Ui처리
        
        AF.request(url, method: .get, headers: header).validate().responseData { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                completionHandler(json)
                
            case .failure(let error):
                print(error)
                
                
            }
        }
        
    }
}
