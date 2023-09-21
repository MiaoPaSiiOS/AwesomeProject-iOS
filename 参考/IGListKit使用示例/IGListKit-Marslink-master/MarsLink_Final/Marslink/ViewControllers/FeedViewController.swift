/**
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import IGListKit

class FeedViewController: UIViewController {
    //JournalEntryLoader 是一个类，用于加载一个硬编码的日志记录到一个数组中。
    let loader = JournalEntryLoader()
    let collectionView: IGListCollectionView = {
    let view = IGListCollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    view.backgroundColor = UIColor.black
    return view
    }()

    /*
     updater 是一个实现了 IGListUpdatingDelegate 协议的对象, 它负责处理 row 和 section 的刷新。IGListAdapterUpdater 有一个默认实现，刚好给我们用。
     viewController 是一个 UIViewController ，它拥有这个 adapter。 这个 view controller 后面会用于导航到别的 view controllers。
     workingRangeSize 是 warking range 的大小。允许你为那些不在可见范围内的 section 准备内容。
     */
    lazy var adapter: IGListAdapter = {
    return IGListAdapter(updater: IGListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()
    let pathfinder = Pathfinder()
    let wxScanner = WxScanner()

  override func viewDidLoad() {
    super.viewDidLoad()
    //加载最新的日志记录。
    loader.loadLatest()
    view.addSubview(collectionView)
    adapter.collectionView = collectionView
    adapter.dataSource = self
    pathfinder.delegate = self
    pathfinder.connect()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    collectionView.frame = view.bounds
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

// MARK: - IGListAdapterDataSource
extension FeedViewController: IGListAdapterDataSource {
    //objects(for:) 返回一个数据对象组成的数组，这些对象将显示在 collection view。这里返回了loader.entries，因为它包含了日志记录。
    func objects(for listAdapter: IGListAdapter) -> [IGListDiffable] {
    var items: [IGListDiffable] = [wxScanner.currentWeather]
    items += loader.entries as [IGListDiffable]
    items += pathfinder.messages as [IGListDiffable]

    return items.sorted(by: { (left: Any, right: Any) -> Bool in
      if let left = left as? DateSortable, let right = right as? DateSortable {
        return left.date > right.date
      }
      return false
    })
    }
    
    //对于每个数据对象，listAdapter(_:sectionControllerFor:) 方法必须返回一个新的 section conroller 实例。现在，你返回了一个空的 IGListSectionController以解除编译器的抱怨——等会，你会修改这里，返回一个自定义的日志的 section controller。
    func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController & IGListSectionType  {
    if object is Message {
      return MessageSectionController()
    } else if object is Weather {
      return WeatherSectionController()
    } else {
      return JournalSectionController()
    }
    }
    
    //emptyView(for:) 返回一个 view，它将在 List 为空时显示。NASA 给的时间比较仓促，他们没有为这个功能做预算。
    func emptyView(for listAdapter: IGListAdapter) -> UIView? { return nil }
}

// MARK: - PathfinderDelegate
extension FeedViewController: PathfinderDelegate {
  func pathfinderDidUpdateMessages(pathfinder: Pathfinder) {
    adapter.performUpdates(animated: true)
  }
}
