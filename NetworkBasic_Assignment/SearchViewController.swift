//
//  SearchViewController.swift
//  NetworkBasic_Assignment
//
//  Created by Mac Pro 15 on 2022/09/12.
//

import UIKit

/*포인트
 -. superview가 UIViewController이므로 UITableViewDelegate, UITableViewDataSource에 더해 UIViewController extension도 사용할 수 있음.
 -. delegate, datasource 연결, XIB등록
 
 */

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //연결고리 작업: 테이블뷰가 해야할 역할을 뷰컨트롤러에게 요청
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
        //테이블뷰가 사용할 테이블뷰 셀(XIB) 등록: 테이블뷰가 여러개일 수 있으므로 어떤 테이블뷰를 사용할 것인지 연결해줘야함
        searchTableView.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: ListTableViewCell.identifier)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath)
                as? ListTableViewCell else { return UITableViewCell() }
        
        cell.backgroundColor = .clear
        cell.titleLabel.text = "HELLO"
        cell.titleLabel.font = .systemFont(ofSize: 22)
        return cell
    }
    
}
