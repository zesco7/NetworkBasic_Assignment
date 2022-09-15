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
 */

class ImageSearchViewController: UIViewController {

    @IBOutlet weak var imageSearchCollectionView: UICollectionView!
    var bookImageArray : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let layout = UICollectionViewFlowLayout()
        let spacing : CGFloat = 8
        let width = UIScreen.main.bounds.width
        layout.itemSize = CGSize(width: width, height: 150)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        imageSearchCollectionView.collectionViewLayout = layout
    
        fetchImage()
        print("========fetch========")
        imageSearchCollectionView.delegate = self
        imageSearchCollectionView.dataSource = self
        imageSearchCollectionView.register(UINib(nibName: "ImageSearchCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: ImageSearchCollectionViewCell.identifier)
    }

    //fetchImage, requestImage, callRequestImage 등 서버의 response에 따라 함수명을 정해주는 편임.
    func fetchImage() {
        
        //쿼리값 타입이 한글은 안되는 이유? : 요청변수를 UTF-8로 인코딩한 값인데 한글은 인코딩을 따로 해줘야함
        //한글을 UTF-8로 인코딩 해줌(url내에 있는 한글을 인식해서 인코딩해준다고 생각하면 됨)
        let text = "과자".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! //텍스트는 String?타입이므로 언래핑해줌
        let url = EndPoint.ImageSearchURL + "query=\(text)&display=30&start=1"
        let header : HTTPHeaders = ["X-Naver-Client-Id": APIKey.NAVER_ID, "X-Naver-Client-Secret": APIKey.NAVER_SECRET]
        AF.request(url, method: .get, headers: header).validate(statusCode: 200..<400).responseJSON { [self] response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
               
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
    
    
}
