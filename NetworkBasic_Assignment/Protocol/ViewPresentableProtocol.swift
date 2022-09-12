//
//  ViewPresentableProtocol.swift
//  NetworkBasic_Assignment
//
//  Created by Mac Pro 15 on 2022/09/12.
//

import Foundation
import UIKit

/*프로토콜
 -. 프로토콜은 필요한 요소를 명세만 할뿐 실질적인 구현부는 작성하지 않는다. 내용은 프로토콜을 채택한 타입에서 구현한다.
 -. 프로토콜은 클래스, 구조체, 익스텐션, 열거형 등에서 사용할 수 있다.
 -. 클래스는 단일상속만 가능하지만 프로토콜은 채택갯수에 제한이 없다.
 -. 프로토콜은 필수요소, 선택요소를 지정할 수 있다.
 */

/*프로토콜 프로퍼티
 -. 선택요소를 지정하려면 프로토콜명에 @objc, 함수명에 @objc optional을 추가해줘야 한다. @objc optional: 선택적 요청(Optional Requirement)
 -. 무조건 var로 선언해야 한다.
 -. get을 정했으면 최소한의 기능으로 get만 구현되면 된다. 즉, 필요하다면 set도 아무때나 구현할 수 있다.
 */

protocol ViewPresentableProtocol {
    var navigationTitleString: String { get set } //프로토콜 프로퍼티를 연산,저장 프로퍼티 중 어떤 용도로 써도 상관없다.
    var backgroundColor: UIColor { get }
    func configureView()
    func configureLabel()
}

@objc
protocol JackTableViewProtocol {
    func numberOfRowsInSection() -> Int
    func cellForRowsAt(indexPath: IndexPath) -> UITableViewCell
    @objc optional func didSelectRowsAt() //프로토콜은 필수요소, 선택요소를 지정할 수 있다.
}
