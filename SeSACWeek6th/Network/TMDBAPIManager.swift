//
//  TMDBAPIManager.swift
//  SeSACWeek6th
//
//  Created by 권민서 on 2022/08/10.
//

import Foundation

import Alamofire
import SwiftyJSON
import Kingfisher

class TMDBAPIManager {
    
    
    static let shared = TMDBAPIManager()
    private init() {}
    
    let tvList = [
        ("환혼", 135157),
        ("이상한 변호사 우영우", 197067),
        ("인사이더", 135655),
        ("미스터 션사인", 75820),
        ("스카이 캐슬", 84327),
        ("사랑의 불시착", 94796),
        ("이태원 클라스", 96162),
        ("호텔 델루나", 90447)
    ]
    
    let imageURL = "https://image.tmdb.org/t/p/w500"
    let seasonURL = "https://api.themoviedb.org/3/tv/135157/season/1?api_key=\(APIKey.tmdb)&language=ko-KR"
    
    func callRequest(query: Int, completionHandler: @escaping ([String]) -> ()) {
        print(#function)
        let url = "https://api.themoviedb.org/3/tv/\(query)/season/1?api_key=\(APIKey.tmdb)&language=ko-KR"
        
        //접두어 -> AF 알라모파이어에서 url주소로 들어가고 get 방식 유효성 검사(상태코드) 실행 ex) 200 = 성공 response 데이터 가져오겠다
        //Alamofire -> URLSession Framework -> 비동기로 request
        //almofire가 자동으로 메인스레드로 바꿔줌
        //뜨기전에 네트워크 요청 -> Response -> request시점에 Urlsession에 비동기가 처리되도록 백그라운드에서 비동기 처리 -> 메인 Ui처리
        
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                
                //var stillPathlist: [String] = []

//                for i in json["episodes"].arrayValue {
//                    let stillPath = i["still_path"].stringValue
//                    stillPathlist.append(stillPath)
//                }
//
                let value = json["episodes"].arrayValue.map { $0["still_path"].stringValue }
                
                //dump(stillPathlist) //print vs dump 계층구조가 명확하게 나옴 배열의 갯수 종류 element
                
                completionHandler(value)
                
            case .failure(let error):
                print(error)
                
                
            }
        }
        
    }
    
    func requestImage(completionHandler: @escaping ([[String]]) -> ()) {
        
        var posterList: [[String]] = []
        
        //나중에 배울 것: async/awit(iOS13 이상)
        TMDBAPIManager.shared.callRequest(query: tvList[0].1) { value in
            posterList.append(value)

            TMDBAPIManager.shared.callRequest(query: self.tvList[1].1) { value in
                posterList.append(value)

                TMDBAPIManager.shared.callRequest(query: self.tvList[2].1) { value in
                    posterList.append(value)
                   
                    TMDBAPIManager.shared.callRequest(query: self.tvList[3].1) { value in
                        posterList.append(value)
                     
                        TMDBAPIManager.shared.callRequest(query: self.tvList[4].1) { value in
                            posterList.append(value)
                           
                            TMDBAPIManager.shared.callRequest(query: self.tvList[5].1) { value in
                                posterList.append(value)
                                
                                TMDBAPIManager.shared.callRequest(query: self.tvList[6].1) { value in
                                    posterList.append(value)
                                    
                                    TMDBAPIManager.shared.callRequest(query: self.tvList[7].1) { value in
                                        posterList.append(value)
                                        completionHandler(posterList)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    
    //func requestEpisodeImage() {
        
        //1. 순서 보장 X 2. 언제 끝날 지 모름 3. Limit(ex. 1초 5번 block)
//        for item in tvList {
//            TMDBAPIManager.shared.callRequest(query: item.1) { stilPath in
//                print(stilPath)
//            }
//        }
        
       // let id = tvList[7].1
        //TMDBAPIManager.shared.callRequest(query: id) { stillPath in
            //print(stillPath)
            //TMDBAPIManager.shared.callRequest(query: tvList[5].1) {stillPath in
                
               // print(stillPath)
            //}
            
            
        //}
        
    //}
    
    
}
