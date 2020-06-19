//
//  ShootViewController.swift
//  DouyinApp
//
//  Created by Ai on 2020/6/11.
//  Copyright © 2020 yyk. All rights reserved.
//

import UIKit
import JXSegmentedView

class ShootViewController: BaseViewController,JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self.view
    }


    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .background
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 60
        tableView.separatorStyle = .none
        tableView.register(cellType: AttentTableViewCell.self)
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(NaviBarH)
        }
        
    }
    


}

extension ShootViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: AttentTableViewCell.self)
        return cell
    }


}
