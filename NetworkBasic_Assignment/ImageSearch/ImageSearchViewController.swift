//
//  ImageSearchViewController.swift
//  NetworkBasic_Assignment
//
//  Created by Mac Pro 15 on 2022/09/14.
//

import UIKit

import Alamofire
import Kingfisher
import SwiftyJSON

/*질문
 -. 네트워크 통신에서 반복문 사용하여 값을 bookImageArray를 배열형태로 저장하려는데 json에서 접근하는 방법을 모르겠음(딕셔너리랑 뭐가 다른건지?) -> 해결: insomenia에서 json구조 잘확인해서 반복문처리
 -. bookImageArray에 데이터를 저장했다 치고 저장된 데이터를 킹피셔로 콜렉션뷰셀마다 보여주는 방법을 모르겠음(indexpath를 사용해서 셀마다 데이터를 보여주려면 cellForItemAt에서 처리해야 되는데 배열안에 있는 이미지주소 string을 어떻게 넣어줘야하는지?) -> 해결: cell마다 indexPath에 맞는 데이터 받을 수 있도록 url변수 선언 + 킹피셔 사용법 숙지
 -. for indexPath in indexPaths의 의미? bookImageArray 배열을 반복문 돌리겠다는 뜻?

 */

class ImageSearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var imageSearchCollectionView: UICollectionView!
    var bookImageArray : [String] = []
    
    //페이지네이션UIScrollViewDelegateProtocol 시작페이지 설정
    var startPage = 1
    var totalCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let layout = UICollectionViewFlowLayout()
        let spacing : CGFloat = 8
        let width = UIScreen.main.bounds.width - (spacing * 4)
        layout.itemSize = CGSize(width: width / 3, height: 150)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        imageSearchCollectionView.collectionViewLayout = layout
        
        print("========fetch========")
        searchBar.delegate = self
        imageSearchCollectionView.delegate = self
        imageSearchCollectionView.dataSource = self
        imageSearchCollectionView.prefetchDataSource = self
        imageSearchCollectionView.register(UINib(nibName: "ImageSearchCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: ImageSearchCollectionViewCell.identifier)
    }
    
    //fetchImage, requestImage, callRequestImage 등 서버의 response에 따라 함수명을 정해주는 편임.
    func fetchImage(query: String) {
        
        //쿼리값 타입이 한글은 안되는 이유? : 요청변수를 UTF-8로 인코딩한 값인데 한글은 인코딩을 따로 해줘야함
        //한글을 UTF-8로 인코딩 해줌(url내에 있는 한글을 인식해서 인코딩해준다고 생각하면 됨)
        let text = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! //텍스트는 String?타입이므로 언래핑해줌
        let url = EndPoint.ImageSearchURL + "query=\(text)&display=30&start=1"
        let header : HTTPHeaders = ["X-Naver-Client-Id": APIKey.NAVER_ID, "X-Naver-Client-Secret": APIKey.NAVER_SECRET]
        AF.request(url, method: .get, headers: header).validate(statusCode: 200..<400).responseJSON { [self] response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                self.totalCount = json["total"].intValue
                
                for book in json["items"].arrayValue { //["items"] 안에 있는 배열count만큼(book) 반복문 실행
                    let image = book["image"].stringValue
                    self.bookImageArray.append(image)
                }
                print(self.bookImageArray)
                print("========reload========")
                imageSearchCollectionView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension ImageSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookImageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageSearchCollectionViewCell.identifier, for: indexPath) as? ImageSearchCollectionViewCell else { return UICollectionViewCell() }
        print("========cellForItemAt========")
        let url = URL(string: bookImageArray[indexPath.item]) //indexPath에 해당하는 이미지url을 URL타입처리해서 킹피셔로 이미지 로드
        cell.bookImageView.kf.setImage(with: url)
        
        return cell
    }
    
    //페이지네이션 방법1. 콜렉션뷰가 특정 셀을 그리려는 시점에 호출되는 메서드
    //특징: 마지막셀에 사용자가 위치했는지 여부 파악하기 어려움
    //    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    //        <#code#>
    //    }
    
    //페이지네이션 방법2. UIScrollViewDelegateProtocol
    //특징: 테이블뷰,콜렉션뷰가 스크롤뷰를 상속받고 있기 때문에 프로토콜 사용가능
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset) //contentOffset으로 사용자가 얼마나 스크롤했는지 알 수 있음
    }
}

//페이지네이션 방법3. UIScrollViewDelegateProtocol
//특징: 용량 큰 데이터를 셀에 표시할 때 셀이 화면에 보이기 전에 미리 필요한 리소스를 다운받거나, 데이터 필요없으면 안받을 수 있음
//iOS10+ 스크롤 성능 향상
extension ImageSearchViewController: UICollectionViewDataSourcePrefetching {
    
    //셀이 화면에 보이기 전에 미리 필요한 리소스를 다운받는 기능
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            //반복이미지가 총 이미지 갯수보다 많아져서 이미지반복되는 문제 처리
            if bookImageArray.count - 1 == indexPath.item && bookImageArray.count < totalCount {
                startPage += 30 //데이터가 배열에 계속 추가 되기 때문에 bookImageArray.count을 더할 수는 없음
                fetchImage(query: searchBar.text!)
            }
        }
        print("=======\(indexPaths)======")
    }
    //네트워크 통신 취소: 직접 메서드 구현해줘야 함
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        print("===취소====\(indexPaths)======")
    }
}

extension ImageSearchViewController: UISearchBarDelegate {
    
    //검색버튼 클릭시 실행
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text { //서치바에 작성된 내용을 매개변수로 네트워크 통신 실행
            
            bookImageArray.removeAll() //이전 검색결과 표시할 때 사용했던 데이터 삭제
            startPage = 1 //이전 검색결과 표시할 때 사용했던 시작페이지 데이터 삭제
            
            //새로운 단어 검색했을 때 스크롤 위치 변경 가능
            //collectionView.scrollToItem(at: <#T##IndexPath#>, at: <#T##UICollectionView.ScrollPosition#>, animated: <#T##Bool#>)
            
            fetchImage(query: text)
        }
    }
    
    //취소버튼 눌렀을 때 실행되는 메서드
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) { //취소버튼 누르면 데이터 리셋 갱신
        bookImageArray.removeAll()
        imageSearchCollectionView.reloadData()
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    //서치바에 커서 깜박일 때 실행되는 메서드
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true) //true면 취소버튼 보여줌
    }
}
