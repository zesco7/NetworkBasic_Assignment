//
//  SearchViewController.swift
//  NetworkBasic_Assignment
//
//  Created by Mac Pro 15 on 2022/09/12.
//

import UIKit

import Alamofire
import JGProgressHUD
import SwiftyJSON
import RealmSwift

/*포인트
 -. superview가 UIViewController이므로 UITableViewDelegate, UITableViewDataSource에 더해 UIViewController extension도 사용할 수 있음.
 -. delegate, datasource 연결, XIB등록
 
 */

/*JGProgressHUD
 -. 네트워크 통신 시작할 때 로딩바 표시
 -. 네트워크 통신 종료, 데이터 리로드 후 dismiss처리
 -. dismiss는 네트워크 통신 과정에서 해야함
 */

/*질문
 -.검색기록 여부를 어떻게 구분하는지? 빈배열 만들어서 append해도 검색때마다 append되어서 분기처리 안됨
 -.검색기록있어서 네트워크통신안할때 어떻게 Realm테이블 값에 접근하는지? row가 여러개인경우 재사용셀 데이터 표시때문에 인덱싱까지해야하는데 searchBarSearchButtonClicked에서 접근할 수 있나?
 
 */

class SearchViewController: UIViewController, ViewPresentableProtocol, UITableViewDelegate, UITableViewDataSource {
    var navigationTitleString: String = ""
    
    var backgroundColor: UIColor = .clear
    var tag : Int!
    var searchBarTextArray = Array<String>()
    
    //BoxOffice배열 생성
    var list : [BoxOfficeModel] = []
    let hud = JGProgressHUD() //JGProgressHUD 인스턴스생성
    
    //Realm1. 저장경로 생성
    let localRealm = try! Realm()
    
    //Realm2. Realm테이블 저장용 프로퍼티 생성
    var dailyBoxOfficeArray : Results<DailyBoxOffice>! {
        didSet {
            searchTableView.reloadData()
            print("Data Changed")
        }
    }
    
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //연결고리 작업: 테이블뷰가 해야할 역할을 뷰컨트롤러에게 요청
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
        //테이블뷰가 사용할 테이블뷰 셀(XIB) 등록: 테이블뷰가 여러개일 수 있으므로 어떤 테이블뷰를 사용할 것인지 연결해줘야함
        searchTableView.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: ListTableViewCell.identifier)
        
        searchBar.delegate = self //서치바 delegate 연결
        
        //requestBoxOffice(date: searchBar.text!)
        
        print("Realm is located at:", localRealm.configuration.fileURL!)
        //localRealm.objects(DailyBoxOffice.self).sorted(by: <#T##(DailyBoxOffice, DailyBoxOffice) throws -> Bool#>)
       
    }
    
    func configureView() {
        searchTableView.backgroundColor = .clear
        searchTableView.separatorColor = .clear
        searchTableView.rowHeight = 60
    }
    
    func configureLabel() {
        print("")
    }
    
    func requestBoxOffice(date: String) {
        
        hud.show(in: view) //네트워크 통신 시작할 때 로딩바 표시
        
        //list.removeAll() //배열데이터삭제 가능시점1
        let url = "\(EndPoint.boxOfficeURL)key=\(APIKey.BOXOFFICE)&targetDt=\(date)"
        //responseJSON -> responseData
        AF.request(url, method: .get).validate( ).responseData { [self] response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                //print("JSON: \(json)")
                
                //BoxOffice배열 개별추가
                /*
                let movieNm1 = json["boxOfficeResult"]["dailyBoxOfficeList"][0]["movieNm"].stringValue
                let movieNm2 = json["boxOfficeResult"]["dailyBoxOfficeList"][1]["movieNm"].stringValue
                let movieNm3 = json["boxOfficeResult"]["dailyBoxOfficeList"][2]["movieNm"].stringValue
        
                self.list.append(movieNm1)
                self.list.append(movieNm2)
                self.list.append(movieNm3)
                print(self.list)
                 */
                self.list.removeAll() //배열데이터삭제 가능시점2
                
                //BoxOffice배열 반복문 추가
                for movie in json["boxOfficeResult"]["dailyBoxOfficeList"].arrayValue {
                    let movieNm = movie["movieNm"].stringValue
                    let openDt = movie["openDt"].stringValue
                    let audiAcc = movie["audiAcc"].stringValue
                    self.list.append(BoxOfficeModel(movieTitle: movieNm, releaseDate: openDt, totalCount: audiAcc))
                }
                print(self.list)
                
                realmDataSetup()
                self.searchTableView.reloadData() //처음에는 빈 배열이므로 배열데이터를 갱신해주어야 화면에 표시됨
                self.hud.dismiss()
                
            case .failure(let error):
                print(error)
            }
            //self.hud.dismiss() //여기에서 dismiss하면 안됨. 네트워크통신은 데이터요청 후 다음코드를 실행해버리기 때문에 영화목록 뜨기전에 로딩바 사라질것임.
        }
    }
    
    func realmDataSetup() {
        //Realm2. 레코드 생성, 추가
        let data = DailyBoxOffice(movieName: list[0].movieTitle, openDate: list[0].releaseDate, audienceAcc: list[0].totalCount, searchingDate: searchBar.text!)
        let data2 = DailyBoxOffice(movieName: list[1].movieTitle, openDate: list[1].releaseDate, audienceAcc: list[1].totalCount, searchingDate: searchBar.text!)
        let data3 = DailyBoxOffice(movieName: list[2].movieTitle, openDate: list[2].releaseDate, audienceAcc: list[2].totalCount, searchingDate: searchBar.text!)
        let data4 = DailyBoxOffice(movieName: list[3].movieTitle, openDate: list[3].releaseDate, audienceAcc: list[3].totalCount, searchingDate: searchBar.text!)
        let data5 = DailyBoxOffice(movieName: list[4].movieTitle, openDate: list[4].releaseDate, audienceAcc: list[4].totalCount, searchingDate: searchBar.text!)
        let data6 = DailyBoxOffice(movieName: list[5].movieTitle, openDate: list[5].releaseDate, audienceAcc: list[5].totalCount, searchingDate: searchBar.text!)
        let data7 = DailyBoxOffice(movieName: list[6].movieTitle, openDate: list[6].releaseDate, audienceAcc: list[6].totalCount, searchingDate: searchBar.text!)
        let data8 = DailyBoxOffice(movieName: list[7].movieTitle, openDate: list[7].releaseDate, audienceAcc: list[7].totalCount, searchingDate: searchBar.text!)
        let data9 = DailyBoxOffice(movieName: list[8].movieTitle, openDate: list[8].releaseDate, audienceAcc: list[8].totalCount, searchingDate: searchBar.text!)
        let data10 = DailyBoxOffice(movieName: list[9].movieTitle, openDate: list[9].releaseDate, audienceAcc: list[9].totalCount, searchingDate: searchBar.text!)

        try! localRealm.write {
            localRealm.add(data)
            localRealm.add(data2)
            localRealm.add(data3)
            localRealm.add(data4)
            localRealm.add(data5)
            localRealm.add(data6)
            localRealm.add(data7)
            localRealm.add(data8)
            localRealm.add(data9)
            localRealm.add(data10)
            print("Realm Succeess")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath)
                as? ListTableViewCell else { return UITableViewCell() }

        cell.backgroundColor = .clear
        cell.titleLabel.text = "\(list[indexPath.row].movieTitle)(\(list[indexPath.row].releaseDate)): 총 \(list[indexPath.row].totalCount)명"
        cell.titleLabel.font = .systemFont(ofSize: 22)
        self.tag = indexPath.row
        
        return cell
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dailyBoxOfficeArray = localRealm.objects(DailyBoxOffice.self).sorted(byKeyPath: "searchingDate", ascending: false)
        
        let tvcell = ListTableViewCell()

        /*
        if 검색기록X {
         requestBoxOffice(date: searchBar.text!) //네트워크 통신으로 받은 데이터 표시
         } 검색기록O {
         //Realm에 저장된 데이터 표시
         }
         */
        
        
//        if searchBarTextArray.contains(searchBar.text!) {
//            tvcell.titleLabel.text = "\(dailyBoxOfficeArray[indexPath.row].movieName)(\(dailyBoxOfficeArray[indexPath.row].openDate)): 총 \(dailyBoxOfficeArray[indexPath.row].audienceAcc)명"
//        } else {
//            requestBoxOffice(date: searchBar.text!)
//        }
    }
}
