//
//  HomeViewController.swift
//  DouyinApp
//
//  Created by Ai on 2020/6/10.
//  Copyright © 2020 yyk. All rights reserved.
//

import UIKit
import JXSegmentedView

class HomeViewController: BaseViewController {

    var segmentedDataSource: JXSegmentedTitleDataSource!
    var segmentedView: JXSegmentedView!
    var listContainerView: JXSegmentedListContainerView!

    lazy var navView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    lazy var searchBtn: UIButton = {
        let searchBtn = UIButton()
        searchBtn.setImage(UIImage(named: "nav_search"), for: .normal)
        searchBtn.sizeToFit()
        return searchBtn
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        gk_navBarAlpha = 0
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_search"), style: .plain, target: self, action: #selector(searchClick))
        // Do any additional setup after loading the view.


        self.view.addSubview(navView)
        navView.backgroundColor = .clear
        navView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(NaviBarH)
        }
        navView.addSubview(searchBtn)
        searchBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview()
            make.size.equalTo(CGSize(width: 40, height: 40))
        }


        segmentedView = JXSegmentedView()
        segmentedView.delegate = self
        segmentedView.backgroundColor = .clear
        navView.addSubview(segmentedView)
        segmentedView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.size.equalTo(CGSize(width: ScreenW * 0.6, height: NaviBarH - StatusBarH))
        }

        segmentedDataSource = JXSegmentedTitleDataSource()
        //配置数据源相关配置属性
        segmentedDataSource.titles = ["关注", "推荐"]
        segmentedDataSource.titleNormalColor = .lightGray
        segmentedDataSource.titleSelectedColor = .white
        segmentedDataSource.titleNormalFont = .boldSystemFont(ofSize: 20)
        segmentedDataSource.isTitleColorGradientEnabled = true
        //关联dataSource
        segmentedView.dataSource = self.segmentedDataSource

        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = 20
        indicator.indicatorColor = .white
        segmentedView.indicators = [indicator]

        listContainerView = JXSegmentedListContainerView(dataSource: self)
        view.addSubview(self.listContainerView)
        listContainerView.frame = CGRect(x: 0, y: 0, width: ScreenW, height: ScreenH-TabbarH)
        //关联listContainer
        segmentedView.listContainer = listContainerView
        segmentedView.defaultSelectedIndex = 1


        self.view.bringSubviewToFront(navView)
    }
    



    @objc func searchClick() {

    }


}

extension HomeViewController: UIScrollViewDelegate,JXSegmentedViewDelegate,JXSegmentedListContainerViewDataSource {

    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {

        
    }
    //返回列表的数量
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return segmentedDataSource.titles.count
    }
    //返回遵从`JXSegmentedListContainerViewListDelegate`协议的实例
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        if index == 0 {
            return ShootViewController()
        } else {
            return PlayViewController()
        }
    }
}
