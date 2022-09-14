//
//  TranslateViewController.swift
//  NetworkBasic_Assignment
//
//  Created by Mac Pro 15 on 2022/09/12.
//

import UIKit

import Alamofire
import SwiftyJSON

/*질문
 -. requestTranslatedData에서 parameter에 text없이 요청해도 왜 콘솔에 상태에러 내용 안뜨는지?
 -. validate 범위가 200...500이면 500까지 통신 성공한건데, 왜 parameter의 source가 korea라고 에러가 뜨는지?
 -. userInputTextView.text 타입이 String!인데 parameter에서 text를 왜 언래핑해줘야하는지?
 */

class TranslateViewController: UIViewController {
    @IBOutlet weak var userInputTextView: UITextView!
    @IBOutlet weak var translatedTextView: UITextView!
    @IBOutlet weak var translationButton: UIButton!
    
    let textViewPlaceholder = "번역할 내용을 입력하세요."
    //UITextField, UIButton : 액션 연결 가능(control 상속받았기 때문)
    //UITextView, UISearchBar, UIPickerView : 액션 연결 불가(control 상속받았지 않았기 때문)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userInputTextView.text = textViewPlaceholder
        userInputTextView.font = UIFont(name: "KOTRALEAP", size: 25) //Custom Font 적용
        userInputTextView.textColor = .red
        userInputTextView.delegate = self
        
        //userInputTextView.resignFirstResponder()
        //userInputTextView.becomeFirstResponder()
    }
    
    
    /*네트워크 통신 관련
     -. headers: 네트워크 통신을 요청할 때 인증키 내용을 그대로 노출하는 대신 메타정보를 포함한 헤더를 사용한다.
     -. parameters: 파라미터로 네이버가 정해놓은 값을 요청한다.(번역예정 언어코드, 번역할 내용)
     -. validate: 통신성공케이스를 코드로 구분(AF기본설정 성공코드는 200~299)
     */
    func requestTranslatedData() {
        let url = EndPoint.translatorURL
        let parameter = ["source": "ko", "target": "en", "text": userInputTextView.text!] as [String : Any]
        let header : HTTPHeaders = ["X-Naver-Client-Id": APIKey.NAVER_ID, "X-Naver-Client-Secret": APIKey.NAVER_SECRET]
        AF.request(url, method: .post, parameters: parameter, headers: header).validate(statusCode: 200..<400).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let translatedText = json["message"]["result"]["translatedText"].stringValue
                
                let statusCode = response.response?.statusCode ?? 500
                
                if statusCode == 200 {

                } else {
                    self.userInputTextView.text = json["errorMessage"].stringValue
                }
                
                self.translatedTextView.text = translatedText
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction func translationButtonClicked(_ sender: UIButton) {
        requestTranslatedData()
    }
    
}

//UIResponderChain:resignFirstResponder(), becomeFirstResponder() 관련 개념(많은 객체중에 어떤 것을 선택했는지 알려주는 기능)
extension TranslateViewController: UITextViewDelegate {
    //텍스트뷰의 글자 변할 때마다 호출(글자수 계산기에 사용 가능)
    func textViewDidChange(_ textView: UITextView) {
        print(textView.text.count)
    }
    
    //편집 시작할 때: 커서가 시작되는 순간
    //텍스트뷰 글자가 플레이스홀더 글자와 같으면 내용삭제 + 글자색 변경
    func textViewDidBeginEditing(_ textView: UITextView) {
        if userInputTextView.textColor == .red {
            userInputTextView.text = nil
            userInputTextView.textColor = .black
        }
        print("begin")
    }
    
    //편집 끝났을때: 커서가 없어지는 순간
    //사용자가 아무글자도 입력안했으면 플레이스홀더 글자 보이게 하기
    func textViewDidEndEditing(_ textView: UITextView) {
        if userInputTextView.text.isEmpty {
            userInputTextView.text = textViewPlaceholder
            userInputTextView.textColor = .red
        }
        print("end")
    }
}

