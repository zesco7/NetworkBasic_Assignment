//
//  RealmModel.swift
//  NetworkBasic_Assignment
//
//  Created by Mac Pro 15 on 2022/10/02.
//

import Foundation
import RealmSwift

class DailyBoxOffice: Object {
    //Realm1. 테이블 생성
    @Persisted var movieName: String
    @Persisted var openDate: String
    @Persisted var audienceAcc: String
    @Persisted var searchingDate: String
    
    //Realm2. PK등록
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    //Realm3. 초기화
    convenience init(movieName: String, openDate: String, audienceAcc: String, searchingDate: String) {
        self.init()
        self.movieName = movieName
        self.openDate = openDate
        self.audienceAcc = audienceAcc
        self.searchingDate = searchingDate
    }
}
