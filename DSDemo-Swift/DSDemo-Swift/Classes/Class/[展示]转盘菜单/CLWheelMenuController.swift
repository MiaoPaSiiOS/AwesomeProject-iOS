//
//  CLWheelMenuController.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2020/12/1.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLWheelMenuController: CLController {
    private lazy var items: [CLWheelMenuItem] = {
        var array = [CLWheelMenuItem]()
        do {
            let item = CLWheelMenuItem(image:UIImage(named: "Hexagon-1")!, selectedImage: UIImage(named: "Hexagon-2")!)
            array.append(item)
        }
        do {
            let item = CLWheelMenuItem(image:UIImage(named: "Hexagon-1")!, selectedImage: UIImage(named: "Hexagon-2")!)
            array.append(item)
        }
        do {
            let item = CLWheelMenuItem(image:UIImage(named: "Hexagon-1")!, selectedImage: UIImage(named: "Hexagon-2")!)
            array.append(item)
        }
        do {
            let item = CLWheelMenuItem(image:UIImage(named: "Hexagon-1")!, selectedImage: UIImage(named: "Hexagon-2")!)
            array.append(item)
        }
        do {
            let item = CLWheelMenuItem(image:UIImage(named: "Hexagon-1")!, selectedImage: UIImage(named: "Hexagon-2")!)
            array.append(item)
        }
        do {
            let item = CLWheelMenuItem(image:UIImage(named: "Hexagon-1")!, selectedImage: UIImage(named: "Hexagon-2")!)
            array.append(item)
        }
        return array
    }()
    private lazy var items1: [CLWheelMenuItem] = {
        var array = [CLWheelMenuItem]()
        do {
            let item = CLWheelMenuItem(image: UIImage(named: "Hexagon-1")!, selectedImage: UIImage(named: "Hexagon-1")!, backgroundColor: UIColor.red.withAlphaComponent(0.4))
            array.append(item)
        }
        do {
            let item = CLWheelMenuItem(image: UIImage(named: "Hexagon-1")!, selectedImage: UIImage(named: "Hexagon-1")!, backgroundColor: UIColor.cyan.withAlphaComponent(0.4))
            array.append(item)
        }
        do {
            let item = CLWheelMenuItem(image: UIImage(named: "Hexagon-1")!, selectedImage: UIImage(named: "Hexagon-1")!, backgroundColor: UIColor.blue.withAlphaComponent(0.4))
            array.append(item)
        }
        do {
            let item = CLWheelMenuItem(image: UIImage(named: "Hexagon-1")!, selectedImage: UIImage(named: "Hexagon-1")!, backgroundColor: UIColor.orange.withAlphaComponent(0.4))
            array.append(item)
        }
        do {
            let item = CLWheelMenuItem(image:UIImage(named: "Hexagon-1")!, selectedImage: UIImage(named: "Hexagon-1")!, backgroundColor: UIColor.green.withAlphaComponent(0.4))
            array.append(item)
        }
        do {
            let item = CLWheelMenuItem(image: UIImage(named: "Hexagon-1")!, selectedImage: UIImage(named: "Hexagon-1")!, backgroundColor: UIColor.purple.withAlphaComponent(0.4))
            array.append(item)
        }
        return array
    }()

    private lazy var wheelMenuView: CLWheelMenuView = {
        let view = CLWheelMenuView(frame: .zero) { (configure) in
            configure.centerBackgroundColor = .white
        }
        view.delegate = self
        view.dataSource = self
        return view
    }()
    private lazy var wheelMenuView1: CLWheelMenuView = {
        let view = CLWheelMenuView(frame: .zero) { (configure) in
            configure.centerBackgroundColor = .white
        }
        view.delegate = self
        view.dataSource = self
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .init("f4ea2a")
        view.addSubview(wheelMenuView)
        view.addSubview(wheelMenuView1)
        wheelMenuView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.size.equalTo(200)
            make.top.equalTo(200)
        }
        wheelMenuView1.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.size.equalTo(200)
            make.top.equalTo(wheelMenuView.snp.bottom).offset(100)
        }
        wheelMenuView.reloadData()
        wheelMenuView1.reloadData()
    }
}
extension CLWheelMenuController: CLWheelMenuViewDataSource {
    func numberOfItems(in wheelMenuView: CLWheelMenuView) -> Int {
        if wheelMenuView == self.wheelMenuView {
            return items1.count
        }else {
            return items.count
        }
    }
    func wheelMenuView(_ wheelMenuView: CLWheelMenuView, creatMenuCell cell: CLWheelMenuCell, forRowAtIndex index: Int) {
        if wheelMenuView == self.wheelMenuView {
            cell.item = items[index]
        }else {
            cell.item = items1[index]
        }
    }
}
extension CLWheelMenuController: CLWheelMenuViewDelegate {
    func wheelMenuView(_ view: CLWheelMenuView, didSelectIndex index: Int) {
        CLLog("didSelectIndex: \(index)")
    }
}
