//
//  LocationViewController.swift
//  NetworkBasic_Assignment
//
//  Created by Mac Pro 15 on 2022/09/13.
//

import UIKit

/*알림설정 포인트
 -. 권한허용해야 알림이 온다.
 -. 권한허용문구는 시스템적으로 최초 한번만 뜬다. 그러므로 허용 안 된 경우 애플설정으로 직접유도하는 코드를 구성해야 한다.
 -. 기본적으로 알림은 포그라운드에 수신되지 않는다. 그러므로 AppDelegate에 따로 코드 구성해야 한다.
 -. 로컬알림에서 60초 이상 반복 가능하지만 갯수제한 64개다.
 
 +@
 -. 노티는 앱실행이 기본인데 특정 노티를 클릭할때 특정화면으로 가고 싶다면?(ex. 신발광고 누르면 신발구매페이지 이동)
 -. 포그라운드 수신, 특정화면에서는 안받고 특정조건에서만 포그라운드 수신을 하고 싶다면?(개인톡하는 중에 개인톡상대방에게 카톡왔을때 노티 안뜨게)
 -. iOS15+ 집중모드에서 우선순위 적용 가능
 -. 텍스트필드에서 .textContentType = .oneTimeCode하면 인증번호 자동입력 구현가능
 */

class LocationViewController: UIViewController {
    
    //Notification1. 노티센터 등록: 노티 담당 클래스 가져오기(노티센터 있어야 권한요청 가능)
    let notificationCenter = UNUserNotificationCenter.current()
    override func viewDidLoad() {
        super.viewDidLoad()

        requestAuthorization()
        
        //Custom Font
        for family in UIFont.familyNames {
            print("==========\(family)==========")
            for name in UIFont.fontNames(forFamilyName: family) {
            print(name)
            }
        }
        
    }
    
    @IBAction func notificationButtonClicked(_ sender: UIButton) {
        sendNotification()
    }
    
    
    //Notification2. 권한 요청
    func requestAuthorization() {
        let authorizationOptions = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound) //권한요청 내용을 배열로 선언
        notificationCenter.requestAuthorization(options: authorizationOptions) { success, error in //권한요청 성공, 실패에 대한 조건 추가
            if success { //권한요청 성공했을 때 알림발송 기능 실행
                self.sendNotification()
            }
        }
    }
    //Notification3. 권한 허용한 사용자에게 알림 요청
    //알림요청 후 화면에 표시하기 위해서는 알림을 담당하는 iOS시스템에 알림 등록을 해줘야 한다.(iOS시스템에서 알림 등록을 담당하기 때문)
    
    /*Notification 추가기능
     1. 뱃지 제거: SceneDelegate에서 UIApplication.shared.applicationIconBadgeNumber = 0
     2. 노티 제거: AppDelegate에서 UNUserNotificationCenter.current()
     3. 포그라운드 상태에서 노티 수신: AppDelegate에서 UNUserNotificationCenterDelegate(willPresent) 등록
     */
    
    func sendNotification() {
        //1. 어떤 컨텐츠를 보낼지 내용 작성
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "다마고치를 키워보세요"
        notificationContent.subtitle = "오늘의 행운 숫자 \(Int.random(in: 1...50))!!"
        notificationContent.body = "저는 따끔따끔 다마고치입니다"
        notificationContent.badge = 40
        
        //2. 언제 알림을 보낼 것인지 결정(3가지): 1) 시간간격 2) 캘린더(지정시간) 3) 위치기반
        //1) 시간간격: timeInterval 60이상이어야 반복가능 60미만인데 repeats: true이면 앱 꺼짐
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        //2) 캘린더(지정시간)
        var dateComponent = DateComponents()
        dateComponent.minute = 15
        //let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        
        
        //알림을 요청한다.
        let request = UNNotificationRequest(identifier: "\(Date())", content: notificationContent, trigger: trigger)
        //알림 관리가 필요없을 때: 알림 클릭시 단순 앱실행 기능 등
        //알림 관리가 필요할 때: 알림 클릭시 해당 채팅창 실행 기능 등
        
        /*identifier
         -. identifier는 알림창개수라고 생각하면 됨. identifier이 하나면 계속 발송되는 알림을 하나의 창으로 표시한다는 의미이므로 내용이 계속 바뀔 것임.
         -. identifier는 경우에 따라 관리 방식이 다름.
         */
        
        //핸들러 사용하면 알림 전송 실패 경우 조건 추가도 가능함.
        //앱종료해도 iOS알림센터에서 알아서 시간카운트해서 노티보냄.
        notificationCenter.add(request)
        
    }
    
}
