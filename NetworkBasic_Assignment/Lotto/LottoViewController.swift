//
//  LottoViewController.swift
//  NetworkBasic_Assignment
//
//  Created by Mac Pro 15 on 2022/09/12.
//

import UIKit

class LottoViewController: UIViewController {


    @IBOutlet weak var numberTextField: UITextField!

    
    var lottoPickerView = UIPickerView() //코드로 UIPickerView구현
    
    var lottoList: [Int] = Array(0...1025).reversed()
    override func viewDidLoad() {
        super.viewDidLoad()
        numberTextField.tintColor = .clear //프롬프터 색상 제거
        numberTextField.inputView = lottoPickerView
        lottoPickerView.delegate = self
        lottoPickerView.dataSource = self

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
        numberTextField.text =  "\(lottoList[row])회차"
        print(component, row)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(lottoList[row])회차"
    }
}
