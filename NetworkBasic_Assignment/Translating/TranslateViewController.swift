//
//  TranslateViewController.swift
//  NetworkBasic_Assignment
//
//  Created by Mac Pro 15 on 2022/09/12.
//

import UIKit

class TranslateViewController: UIViewController {
    @IBOutlet weak var userInputTextView: UITextView!
    
    let textViewPlaceholder = "번역할 내용을 입력하세요."
    
    //UITextField, UIButton : 액션 연결 가능(control 상속받았기 때문)
    //UITextView, UISearchBar, UIPickerView : 액션 연결 불가(control 상속받았지 않았기 때문)
    override func viewDidLoad() {
        super.viewDidLoad()

        userInputTextView.text = textViewPlaceholder
        userInputTextView.textColor = .red
        userInputTextView.delegate = self
        
        //userInputTextView.resignFirstResponder()
        //userInputTextView.becomeFirstResponder()
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
