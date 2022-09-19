//
//  ImageSearchAPIManager.swift
//  NetworkBasic_Assignment
//
//  Created by Mac Pro 15 on 2022/09/16.
//

import Foundation

import Alamofire
import SwiftyJSON


/*
 -. totalCount, bookImageArray 등은 viewDidLoad에 있던 거라 연결을 다시 해줘야함
 */

//구조체를 싱글톤패턴으로 쓰는 건 좋지 않음


/*
 -. 클로저 사용하여 두가지 값을 매개변수로 컨트롤러에 전달
 
 
 */

class ImageSearchAPIManager {
    static var shared = ImageSearchAPIManager()
    
    func fetchImageData(query: String, startPage: Int, completionHandler: @escaping (Int, [String]) -> Void) {
        
        let text = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! //텍스트는 String?타입이므로 언래핑해줌
        let url = EndPoint.ImageSearchURL + "query=\(text)&display=30&start=1"
        let header : HTTPHeaders = ["X-Naver-Client-Id": APIKey.NAVER_ID, "X-Naver-Client-Secret": APIKey.NAVER_SECRET]
        AF.request(url, method: .get, headers: header).validate(statusCode: 200..<400).responseJSON { [self] response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let totalCount = json["total"].intValue
                
//                for book in json["items"].arrayValue { //["items"] 안에 있는 배열count만큼(book) 반복문 실행
//                    let image = book["image"].stringValue
//                    self.bookImageArray.append(image)
//                }
                
                let bookImageArray = json["items"].arrayValue.map { $0["link"].stringValue }
                
                completionHandler(totalCount, bookImageArray)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

