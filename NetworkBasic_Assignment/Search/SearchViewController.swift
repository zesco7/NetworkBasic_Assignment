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

/*포인트
 -. superview가 UIViewController이므로 UITableViewDelegate, UITableViewDataSource에 더해 UIViewController extension도 사용할 수 있음.
 -. delegate, datasource 연결, XIB등록
 
 */

/*JGProgressHUD
 -. 네트워크 통신 시작할 때 로딩바 표시
 -. 네트워크 통신 종료, 데이터 리로드 후 dismiss처리
 -. dismiss는 네트워크 통신 과정에서 해야함
 */

class SearchViewController: UIViewController, ViewPresentableProtocol, UITableViewDelegate, UITableViewDataSource {
    var navigationTitleString: String = ""
    
    var backgroundColor: UIColor = .clear
    
    //BoxOffice배열 생성
    var list : [BoxOfficeModel] = []
    let hud = JGProgressHUD() //JGProgressHUD 인스턴스생성
    
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
        
        requestBoxOffice(date: "20220801")
       
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
        AF.request(url, method: .get).validate( ).responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
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
                
                self.searchTableView.reloadData() //처음에는 빈 배열이므로 배열데이터를 갱신해주어야 화면에 표시됨
                self.hud.dismiss()
                
            case .failure(let error):
                print(error)
            }
            //self.hud.dismiss() //여기에서 dismiss하면 안됨. 네트워크통신은 데이터요청 후 다음코드를 실행해버리기 때문에 영화목록 뜨기전에 로딩바 사라질것임.
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
   
        return cell
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        requestBoxOffice(date: searchBar.text!)
    }
}
