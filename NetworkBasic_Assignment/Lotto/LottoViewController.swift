//
//  LottoViewController.swift
//  NetworkBasic_Assignment
//
//  Created by Mac Pro 15 on 2022/09/12.
//

import UIKit

import Alamofire
import SwiftyJSON


/*질문
 -. didSelectRow에서 눌렀을때 회차가 나와야 하는게 아닌지? (numberTextField.text =  "\(lottoList[row])회차")
 -. 빈배열에 기존 검색회차 목록을 만들었을때 처음누른것과 아닌 것을 어떻게 구분하는지? 미검색회차 눌렀다 기존검색회차 눌렀을때 배열처리 어려움.
 */

/*참고
 -. 타입추론이 타입어노테이션보다 빠르다고 봐도 됨
 -. 네트워크 통신에러 대한 대응 필요(서버점검 시 통신에러 등)
 -. 네트워크 느린 환경으로 테스트 가능: 디바이스 빌드 시 통신 컨디션 조정 가능(시뮬레이터에서도 추가설치하면 가능)
 */

class LottoViewController: UIViewController {
    //ReuseableViewProtocol, describing 을 사용하여 identifier 등록
    //static var identifier: String = String(describing: LottoViewController.self)

    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var lottoNumber1: UILabel!
    @IBOutlet weak var lottoNumber2: UILabel!
    @IBOutlet weak var lottoNumber3: UILabel!
    @IBOutlet weak var lottoNumber4: UILabel!
    @IBOutlet weak var lottoNumber5: UILabel!
    @IBOutlet weak var lottoNumber6: UILabel!
    @IBOutlet weak var BonusNumber: UILabel!
    
    var lottoPickerView = UIPickerView() //코드로 UIPickerView구현
    
    var lottoList: [Int] = Array(0...1025).reversed()
    var lottoRoundSearchedList = [Int]()
    var lottoNumberSearchedList = [Int]()
    var zeroList = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberTextField.tintColor = .clear //프롬프터 색상 제거
        numberTextField.inputView = lottoPickerView
        lottoPickerView.delegate = self
        lottoPickerView.dataSource = self
    
        requestLotto(number: lottoList.count - 1)
        
        //timeIntervalSinceNow, Calendar 사용하여 당일 기준 하루전 데이터 로드
        let format = DateFormatter()
        format.dateFormat = "yyyyMMdd" // yyyyMMdd와 YYYYMMdd 차이 체크
        //let dateResult = Date(timeIntervalSinceNow: -86400) //timeIntervalSinceNow
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) //Calendar
        let dateResult = format.string(from: yesterday!)
        
    }
    
    func lottoLabelAttribute() {
 
    }
    
    func requestLotto(number: Int) { //로또 회차를 매개변수로 넣어 회차별 데이터 받기
        //AF에서 success status code: 200~299
        
        let url = "\(EndPoint.lottoURL)&drwNo=\(number)"
        AF.request(url, method: .get).validate(statusCode: 200..<400).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let date = json["drwNoDate"].stringValue
                print(date)
                
                let drwtNo1 = json["drwtNo1"].intValue
                let drwtNo2 = json["drwtNo2"].intValue
                let drwtNo3 = json["drwtNo3"].intValue
                let drwtNo4 = json["drwtNo4"].intValue
                let drwtNo5 = json["drwtNo5"].intValue
                let drwtNo6 = json["drwtNo6"].intValue
                let bnusNo = json["bnusNo"].intValue
                
                print("=======1=======")
                self.numberTextField.text = date
                self.lottoNumber1.text = "\(drwtNo1)"
                self.lottoNumber2.text = "\(drwtNo2)"
                self.lottoNumber3.text = "\(drwtNo3)"
                self.lottoNumber4.text = "\(drwtNo4)"
                self.lottoNumber5.text = "\(drwtNo5)"
                self.lottoNumber6.text = "\(drwtNo6)"
                self.BonusNumber.text = "\(bnusNo)"
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension LottoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return lottoList.count
        //return component == 0 ? 10 : 20 //component에 따라 row다르게 적용
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        UserDefaults.standard.set(lottoList[row], forKey: "lottoRoundSearchedList") //검색된 로또회차 정보 저장
        let lottoRoundSearched = UserDefaults.standard.integer(forKey: "lottoRoundSearchedList")
        lottoRoundSearchedList.append(lottoRoundSearched)
        
        requestLotto(number: lottoList[row])
//        if lottoRoundSearchedList.contains(lottoList[row]) == true {
//            //requestLotto(number: lottoList[row])
//            print(true)
//        } else if lottoRoundSearchedList.contains(lottoList[row]) == false {
//            requestLotto(number: lottoList[row])
//            print(false)
//        } else {
//
//        }
        
        print("=======2=======")
        numberTextField.text =  "\(lottoList[row])회차"
        //print(component, row)
        print(lottoRoundSearchedList)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(lottoList[row])회차"
    }
}
