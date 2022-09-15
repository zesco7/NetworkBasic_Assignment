//
//  BeerListViewController.swift
//  NetworkBasic_Assignment
//
//  Created by Mac Pro 15 on 2022/09/14.
//

import UIKit

import Alamofire
import Kingfisher
import SwiftyJSON

/*질문
 -. 중괄호로 구분하려고해도 데이터 받을때마다 순서가 달라져서 json데이터 구분이 어려움. 그리고 콘솔에 보이는 데이터랑 insomenia에서 보이는 데이터랑 순서가 달라서 헷갈림. -> 해결: ImageSearch문제와 동일
 -. 테이블뷰 높이 때문에 맥주이미지가 종종 잘리는데 어떻게 해결? 잘리는 이미지에 행높이 고정으로 적용?
 */

class BeerListViewController: UIViewController {

    @IBOutlet weak var beerListTableView: UITableView!
    
    var beerListInformationArray: [BeerList] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        beerListTableView.delegate = self
        beerListTableView.dataSource = self
        
        beerListTableView.register(UINib(nibName: "BeerListTableViewCell", bundle: nil), forCellReuseIdentifier: BeerListTableViewCell.identifier)
        
        requestBeerList()
    }
    
    func requestBeerList() {
        let url = "https://api.punkapi.com/v2/beers"
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                for beerList in json.arrayValue {
                    print(beerList)
                    
                    let name = beerList["name"].stringValue
                    let image_url = beerList["image_url"].stringValue
                    let description = beerList["description"].stringValue
                    
                    self.beerListInformationArray.append(BeerList(beerName: name, beerImage: image_url, beerIntro: description))
                }
                self.beerListTableView.reloadData()
                print(self.beerListInformationArray)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

extension BeerListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beerListInformationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BeerListTableViewCell.identifier, for: indexPath) as? BeerListTableViewCell else { return UITableViewCell() }
        cell.configureCell()
        let url = URL(string: beerListInformationArray[indexPath.row].beerImage)
        cell.beerListImageView.kf.setImage(with: url)
        cell.beerListNameLabel.text = beerListInformationArray[indexPath.row].beerName
        cell.beerListIntroLabel.text = beerListInformationArray[indexPath.row].beerIntro
        
        return cell
    }
}
