//
//  BeerViewController.swift
//  NetworkBasic_Assignment
//
//  Created by Mac Pro 15 on 2022/09/13.
//

import UIKit

import Alamofire
import Kingfisher
import SwiftyJSON

class BeerViewController: UIViewController {
    
    @IBOutlet weak var beerRecommendationTitleLabel: UILabel!
    @IBOutlet weak var beerRecommendationButton: UIButton!
    @IBOutlet weak var beerImageView: UIImageView!
    @IBOutlet weak var beerNameLabel: UILabel!
    @IBOutlet weak var beerIntroductionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestBeerInformation()
        beerInformationAttribute()
        
    }
    
    func requestBeerInformation() {
        let url = "https://api.punkapi.com/v2/beers/random"
        AF.request(url, method: .get).validate(statusCode: 200..<400).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                
                let imageURL = json[0]["image_url"].stringValue
                let name = json[0]["name"].stringValue
                let description = json[0]["description"].stringValue
                print(imageURL)
                print(name)
                print(description)
                
                let beerImageURL = URL(string: imageURL)
                self.beerImageView.kf.setImage(with: beerImageURL)
                self.beerNameLabel.text = name
                self.beerIntroductionLabel.text = description
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    func beerInformationAttribute() {
        beerNameLabel.text = ""
        beerIntroductionLabel.text = ""
        
        beerRecommendationTitleLabel.text = "세계 맥주 추천!!"
        beerRecommendationButton.setTitle("맥주추천버튼", for: .normal)
        beerRecommendationButton.backgroundColor = .systemBlue
        beerRecommendationButton.titleLabel?.tintColor = .white
        beerRecommendationTitleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        beerRecommendationTitleLabel.textAlignment = .center
        beerNameLabel.textAlignment = .center
        beerIntroductionLabel.textAlignment = .center
        beerIntroductionLabel.numberOfLines = 0
    }
    @IBAction func beerRecommendationButtonClicked(_ sender: UIButton) {
        requestBeerInformation()
    }
    
}
