//
//  Constant.swift
//  NetworkBasic_Assignment
//
//  Created by Mac Pro 15 on 2022/09/13.
//

import Foundation

struct APIKey {
    static let BOXOFFICE = "847feb80cdfbe381647688f09d9e9d22"
    static let NAVER_ID = "tfYqqDDQUPRUW3CIm5x4"
    static let NAVER_SECRET = "NAoG26YRAW"
}

struct EndPoint {
    static var boxOfficeURL =  "http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?"
    static var lottoURL = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber"
    static var translatorURL = "https://openapi.naver.com/v1/papago/n2mt"
}


//열거형 내에서 타입프로퍼티를 만들 수 있다.
//열거형은 인스턴스 프로퍼티 사용 못한다. (ex. var nickname = "고래밥")
enum StoryboardName {
    case search
    case setting
}

/*
struct StoryboardName {
    static let main = "Main"
    static let search = "search"
    static let setting = "setting"
    
}
*/
