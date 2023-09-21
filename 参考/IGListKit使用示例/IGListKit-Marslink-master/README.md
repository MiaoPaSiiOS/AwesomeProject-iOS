项目介绍：https://blog.csdn.net/kmyhy/article/details/54846390


比 UICollectionView更好用的IGListKit教程
翻译 颐和园 最后发布于2017-02-03 13:17:42 阅读数 14012 收藏
展开

    原文：IGListKit Tutorial: Better UICollectionViews
    作者：Ryan Nystrom
    译者：kmyhy

每个 app 都以同样的方式开始：几个界面，几颗按钮，一两个 list。但随着进度的进行以及 app 膨胀，功能开始发生变化。你简单的数据源开始在工期和产品经理的压力下变得支离破碎。再过一久，你留下一堆庞大得难以维护的 view controller。今天，IGListKit 来拯救你了！

IGListKit 专门用于解决在使用 UICollectionView 时出现的功能蔓延（需求蔓延）和 view controller 膨胀的问题。用 IGListKit 创建列表，你可以使用非耦合组件来构建 app，飞快的刷新，支持任何类型的数据。

本教程中，你将重构一个 UICollectionView 成 IGListKit，然后扩展 app，让它超凡脱俗！
开始

如果你是 NASA 的顶尖软件工程师，正在从事最新的火星载人飞行任务。开发团队已经做好了第一版的 MarsLink app，你可以在[这里](https://koenig-media.raywenderlich.com/uploads/2016/12/Marslink_Starter.zip）下载。下载完这个项目，打开 Marslink.xcworkspace 并运行 app。

这个 app 简单地列出了宇航员的飞行日志。
你的任务是当团队需要新功能时，添加新功能给这个 app。打开 Marslink\ViewControllers\ClassicFeedViewController.swift 随便看看，熟悉一下项目。如果你用过 UICollectionView，你会发现它非常普通：

    ClassicFeedViewController 继承了 UIViewController ，并用一个扩展实现 了 UICollectionViewDataSource 协议。
    viewDidLoad() 中创建了一个 UICollectionView, 注册了 cell，设置了数据源，然后将它添加到视图树中。
    loader.entries 数组保存了几个 section，每个 section 中有两个 cell（一个日期，一个文字）。
    日期 cell 显示阳历的日期，文本 cell 显示日志内容。
    collectionView(_:layout:sizeForItemAt:) 方法返回一个固定的大小用于日期 cell，以及一个根据字符串大小计算出来的 size 给文本 cell。

每件事情都很完美，但是项目 leader 带来了一个紧急的产品升级需求：

在火星上，一名宇航员搁浅了。我们需要添加一个天气预报模块和实时聊天。你只有48小时的时间。

    1

JPL(喷气推进实验室，Jet Propulsion Laboratory) 的工程师要用到这些功能，但需要你将他们放到这个 app 中来。

如果把一名宇航员带回家的压力还不够大的话，NASA 的首席设计师还有一个需求，app 中每个子系统的升级必须是的平滑的，也就是不能 reloadData()。

你怎么会以为将这些模块集成到一个伟大的 app 中并创建所有的转换动画？这名宇航员已经没有多少土豆了！
IGListKit 介绍

UICollectionView 是一个极其强大的工具，与其强大一起的是负有同样大的责任。保持你的数据源和视图同步是极其重要的，通常崩溃就是因为这里没搞好。

IGListKit 是一个数据驱动的 UICollectionView 框架，有 Instagram 团队编写。使用这个框架，你提供一个对象数组用于显示到 UICollectionView 中。对于每种类型的对象，需要创建一个 adapter，也叫做 section controller，里面包含了所有创建 cell 所需要的细节。

IGListKit 自动识别你的对象并在任何东西发生变化时在 UICollectonView 上执行批量动画刷新。这样，你就永远不需要编写 batch update 语句，避免这里列出的警告。
将 UICollectionView 换成 IGListKit

IGListKit 负责所有识别 collection 中发生变化，并以动画方式刷新对应的行。它还能够轻易处理针对不同的 section 使用不同的 data 和 UI 的情况。考虑到这一点，它能够完美解决当前需求——让我们开始吧！

在 Marslink.xcworkspace 打开的情况下，右击 ViewControllers 文件夹并选择 New File…。新建一个 Cocoa Touch Class 继承于 UIViewController 并命名为 FeedViewController。
打开 AppDelegate.swift 找到 application(_:didFinishLaunchingWithOptions:) 方法。找到将ClassicFeedViewController() push 到 navigation controller 的行，将它换成：

nav.pushViewController(FeedViewController(), animated: false)

    1

FeedViewController 现在成为了 root view controller。你可以保留 ClassicFeedViewController.swift 作为参考，但 FeedViewController 将作为你使用 IGListKit 实现一个 collection view 的地方。

运行程序，确保你能看到一个崭新的、空白的 view controller shows。

添加 Journal loader

打开 FeedViewController.swift 在 FeedViewController 顶部添加属性:

let loader = JournalEntryLoader()

    1

JournalEntryLoader 是一个类，用于加载一个硬编码的日志记录到一个数组中。

在 viewDidLoad() 最后一行添加:

loader.loadLatest()

    1

loadLatest() 是 JournalEntryLoader 中的方法，加载最新的日志记录。
加入 collection view

现在来添加某些 IGListKit 的特殊控件到 view controller 中了。在这样做之前，你需要引入这个框架。在 FeedViewController.swift 顶部加入 import 语句:

import IGListKit

    1

    注意：本示例项目使用 CocoaPods 管理依赖。IGListKit 是 Objective-C 些的，因此需要在桥接头文件中用 #import 手动添加到你的项目。

在 FeedViewController 顶部添加一个 collectionView 常量:

// 1
let collectionView: IGListCollectionView = {
  // 2
  let view = IGListCollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
  // 3
  view.backgroundColor = UIColor.black
  return view
}()

    1
    2
    3
    4
    5
    6
    7
    8

    IGListKit 使用了 IGListCollectionView, 这是一个 UICollectionView 的子类，添加了某些功能并修复了某些缺陷。
    一开始用一个大小为 0 的 frame，因为 view 都还没创建。它也使用了 UICollectionViewFlowLayout ，就像 ClassicFeedViewController 一样。
    背景色设为 NASA-认可的黑色。

在 viewDidLoad() 方法最后一句加入:

view.addSubview(collectionView)

    1

这将新的 collectionView 添加到 controller 的 view。
在 viewDidLoad() 下面加入：

override func viewDidLayoutSubviews() {
  super.viewDidLayoutSubviews()
  collectionView.frame = view.bounds
}

    1
    2
    3
    4

viewDidLayoutSubviews() 是一个覆盖方法，将 collectionView的 frame 设为view 的 bounds。
IGListAdapter 和数据源

使用 UICollectionView，你需要某个数据源实现 UICollectionViewDataSource 协议。它的作用是返回 section 和 row 的数目以及每个 cell。
在 IGListKit 中，你使用一个 GListAdapter 来控制 collection view。你仍然需要一个数据源来实现 IGListAdapterDataSource 协议，但不是返回数字或 cell，你需要提供数组和 controllers(后面会细讲)。

首先，在 FeedViewController.swift 在头部加入：

lazy var adapter: IGListAdapter = {
  return IGListAdapter(updater: IGListAdapterUpdater(), viewController: self, workingRangeSize: 0)
}()

    1
    2
    3

这创建了一个延迟加载的 IGListAdapter 变量。这个初始化方法有 3 个参数：

    updater 是一个实现了 IGListUpdatingDelegate 协议的对象, 它负责处理 row 和 section 的刷新。IGListAdapterUpdater 有一个默认实现，刚好给我们用。
    viewController 是一个 UIViewController ，它拥有这个 adapter。 这个 view controller 后面会用于导航到别的 view controllers。
    workingRangeSize 是 warking range 的大小。允许你为那些不在可见范围内的 section 准备内容。

    注意：working range 是另一个高级主题，本教程不会涉及。但是在 IGListKit 的代码库中有它丰富的文档甚至一个示例 app。

在 viewDidLoad() 方法最后一行添加：

adapter.collectionView = collectionView
adapter.dataSource = self

    1
    2

这会将 collectionView 和 adapter 联系在一起。还将 self 设置为 adapter 的数据源——这会报一个错误，因为你还没有实现 IGListAdapterDataSource 协议。

要解决这个错误，声明一个 FeedViewController 扩展以实现 IGListAdapterDataSource 协议。在文件最后添加：

extension FeedViewController: IGListAdapterDataSource {
  // 1
  func objects(for listAdapter: IGListAdapter) -> [IGListDiffable] {
    return loader.entries
  }

  // 2
  func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
    return IGListSectionController()
  }

  // 3
  func emptyView(for listAdapter: IGListAdapter) -> UIView? { return nil }
}

    1
    2
    3
    4
    5
    6
    7
    8
    9
    10
    11
    12
    13
    14

FeedViewController 现在采用了 IGListAdapterDataSource 协议并实现了 3 个必须的方法：

    objects(for:) 返回一个数据对象组成的数组，这些对象将显示在 collection view。这里返回了loader.entries，因为它包含了日志记录。
    对于每个数据对象，listAdapter(_:sectionControllerFor:) 方法必须返回一个新的 section conroller 实例。现在，你返回了一个空的 IGListSectionController以解除编译器的抱怨——等会，你会修改这里，返回一个自定义的日志的 section controller。
    emptyView(for:) 返回一个 view，它将在 List 为空时显示。NASA 给的时间比较仓促，他们没有为这个功能做预算。

创建第一个 Section Controller

一个 section controller 是一个抽象的对象，指定一个数据对象，它负责配置和管理 CollectionView 中的一个 section 中的 cell。这个概念类似于一个用于配置一个 view 的 view-model：数据对象就是 view-model，而 cell 则是 view，section controller 则是二者之间的粘合剂。

在 IGListKit 中，你根据不同类型的数据的类型和特性创建不同的 section controller。JPL 的工程师已经放入了一个 JournalEntry model，你只需要创建能够处理这个 Model 的 section controller 就行了。

在 SectionController 文件夹上右击，选择 New File…，创建一个 Cocoa Touch Class 名为 JournalSectionController ，继承 IGListSectionController。

Xcode 不会自动引入第三方框架，因此在 JournalSectionController.swift 需要添加:

import IGListKit

    1

为 JournalSectionController 添加如下属性:

var entry: JournalEntry!
let solFormatter = SolFormatter()

    1
    2

JournalEntry 是一个 model 类，在实现数据源时你会用到它。SolFormatter 类提供了将日期转换为太阳历格式的方法。很快你会用到它们。

在 JournalSectionController 中，覆盖 init() 方法：

override init() {
  super.init()
  inset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
}

    1
    2
    3
    4

如果不这样做，section 中的 cell 会一个紧挨着一个。这个方法在每个 JournalSectionController 对象的下方增加 15 个像素的间距。

你的 section controller需要实现 IGListSectionType 协议才能被 IGListKit 所用。在文件最后添加一个扩展：

extension JournalSectionController: IGListSectionType {
  func numberOfItems() -> Int {
    return 2
  }

  func sizeForItem(at index: Int) -> CGSize {
    return .zero
  }

  func cellForItem(at index: Int) -> UICollectionViewCell {
    return UICollectionViewCell()
  }

  func didUpdate(to object: Any) {
  }

  func didSelectItem(at index: Int) {}
}

    1
    2
    3
    4
    5
    6
    7
    8
    9
    10
    11
    12
    13
    14
    15
    16
    17
    18

    注意: IGListKit 非常依赖 required 协议方法。但在这些方法中你可以空实现，或者返回 nil，以免收到“缺少方法”的警告或运行时报错。这样，在使用 IGListKit 时就不容易出错。

你实现了 IGListSectionType 协议的 4 个 required 方法。

所有方法都是无存根的实现，除了 numberOfItems() 方法— 返回了一个 2 ，表示一个日期和一个文本字符串。你可以回到 ClassicFeedViewController.swift 看看，在collectionView( _:numberOfItemsInSection:) 方法中你返回的也是 2。这两个方法基本上是一样的。

在 didUpdate(to:)方法中加入：

entry = object as? JournalEntry

    1

didUpdate(to:) 用于将一个对象传给 section controller。注意在任何 cell 协议方法之前调用。这里，你把接收到的 object 参数赋给 entry。

    注意：在一个 section controller 的生命周期中，对象有可能会被改变多次。这只会在启用了 IGListKit 的更高级的特性时候发生，比如自定义模型的 Diffing 算法。在本教程中你不需要担心 Diffing。

现在你有一些数据了，你可以开始配置你的 cell 了。将 cellForItem(at:) 方法替换为：

// 1
let cellClass: AnyClass = index == 0 ? JournalEntryDateCell.self : JournalEntryCell.self
// 2
let cell = collectionContext!.dequeueReusableCell(of: cellClass, for: self, at: index)
// 3
if let cell = cell as? JournalEntryDateCell {
  cell.label.text = "SOL \(solFormatter.sols(fromDate: entry.date))"
} else if let cell = cell as? JournalEntryCell {
  cell.label.text = entry.text
}
return cell

    1
    2
    3
    4
    5
    6
    7
    8
    9
    10
    11

cellForItem(at:) 方法询问到 section 的某个 cell（指定的 Index）时调用。以上代码解释如下：

    如果 index 是第一个，返回 JournalEntryDateCell 单元格，否则返回 JournalEntryCell 单元格。日志数据总是先显示日期，然后才是文本。
    从缓存中取出一个 cell，dequeue 时需要指定 cell 的类型，一个 section controller 对象，以及 index。
    根据 cell 的类型，用你先前在 didUpdate(to objectd:)方法中设置的 entry 来配置 cell。

然后，将 sizeForItem(at:) 方法替换为:

// 1
guard let context = collectionContext, let entry = entry else { return .zero }
// 2
let width = context.containerSize.width
// 3
if index == 0 {
  return CGSize(width: width, height: 30)
} else {
  return JournalEntryCell.cellSize(width: width, text: entry.text)
}

    1
    2
    3
    4
    5
    6
    7
    8
    9
    10

collectionContext 是一个弱引用，同时是 nullabel 的。虽然它永远不可能为空，但最好是做一个前置条件判断，使用 Swift 的 guard 语句就行了。

IGListCollectionContext 是一个上下文对象，保存了这个 section view 中用到的 adapter、collecton view、以及 view controller。这里我们需要获取容器 container 的宽度。

如果是第一个 index(即日期 cell)，返回一个宽度等于 container 宽度，高度等 30 像素的 size。否则，使用 cell 的助手方法根据 cell 文本计算 size。

最后一个方法是 didSelectItem(at:)，这个方法在点击某个 cell 时调用。这是一个 required 方法，你必须实现它，但如果你不想进行任何处理的话，可以空实现。

这种 dequeue 不同类型的 cell、对 cell 进行不同配置和并返回不同 size 的套路和你之前使用 UICollectionView 的套路并无不同。你可以回去 ClassicFeedViewController 看看，这些代码中有许多都很相似！

现在你拥有了一个 section controller，它接收一个 JournalEntry 对象，并返回连个 cell 和 size。接下来我们就来使用它。

打开 FeedViewController.swift, 将 listAdapter(_:sectionControllerFor:) 方法替换为:

return JournalSectionController()

    1

现在，这个方法返回了新的 Journal Section Controller 对象。

运行程序，你将看到一个航空日志的列表！

添加消息

JPL 工程师很高兴你能这么快就完成了修改，但他们还需要和那个倒霉的宇航员建立联系。他们要你尽快将消息模块也集成进去。

在添加任何视图之前，首先的一件事情就是数据。
打开 FeedViewController.swift 添加一个属性：

let pathfinder = Pathfinder()

    1

PathFinder() 扮演了消息系统，并代表了火星上宇航员的探路车。

在 IGListAdapterDataSource 扩展中找到 objects(for:) ，将内容修改为：

var items: [IGListDiffable] = pathfinder.messages
items += loader.entries as [IGListDiffable]
return items

    1
    2
    3

你可能想起来了，这个方法负责将数据源对象提供给 IGListAdapter。这里进行了一些修改，将 pathfinder.messages 添加到 items 中，以便为新的 section controller 提供消息数据。

    注意：你必须转换消息数组以免编译器报错。这些对象已经实现了 IGListDiffable 协议。

在 SectionControllers 文件夹上右击，创建一个新的 IGListSectionController 子类名为 MessageSectionController。在文件头部引入 IGListKit:

import IGListKit

    1

让编译器不报错之后，保持剩下的内容不变。
回到 FeedViewController.swift 修改 IGListAdapterDataSource 扩展中的 listAdapter(_:sectionControllerFor:) 方法为：

if object is Message {
  return MessageSectionController()
} else {
  return JournalSectionController()
}

    1
    2
    3
    4
    5

现在，如果数据对象的类型是 Message,，我们会返回一个新的 Message Secdtion Controller。

JPL 团队需要你在创建 MessageSectionController 时满足下列需求:

    接收 Message 消息
    底部间距 15 像素
    通过 MessageCell.cellSize(width:text:) 函数返回一个 cell 的 size
    dequeue 并配置一个 MessageCell，并用 Message 对象的 text 和 user.name 属性填充 Label。

试试看！如果你需要帮助，JPL 团队也在下面的提供了参考答案：

答案: MessageSectionController

import IGListKit

class MessageSectionController: IGListSectionController {

  var message: Message!

  override init() {
    super.init()
    inset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
  }
}

extension MessageSectionController: IGListSectionType {
  func numberOfItems() -> Int {
    return 1
  }

  func sizeForItem(at index: Int) -> CGSize {
    guard let context = collectionContext else { return .zero }
    return MessageCell.cellSize(width: context.containerSize.width, text: message.text)
  }

  func cellForItem(at index: Int) -> UICollectionViewCell {
    let cell = collectionContext?.dequeueReusableCell(of: MessageCell.self, for: self, at: index) as! MessageCell
    cell.messageLabel.text = message.text
    cell.titleLabel.text = message.user.name.uppercased()
    return cell
  }

  func didUpdate(to object: Any) {
    message = object as? Message
  }

  func didSelectItem(at index: Int) {}
}

    1
    2
    3
    4
    5
    6
    7
    8
    9
    10
    11
    12
    13
    14
    15
    16
    17
    18
    19
    20
    21
    22
    23
    24
    25
    26
    27
    28
    29
    30
    31
    32
    33
    34
    35

当你写完时，运行 app，看看将消息集成后的效果！

火星天气预报

我们的宇航员需要知道当前天气以便避开某些东西比如沙尘暴。JPL 编写了一个显示当前天气的模块。但是那个信息有点多，因此他们要求只有在用户点击之后才显示天气信息。

编写最后一个 sectioncontroller，名为 WeatherSecdtionController。现在这个类中定义一个构造函数和几个变量：

import IGListKit

class WeatherSectionController: IGListSectionController {
  // 1
  var weather: Weather!
  // 2
  var expanded = false

  override init() {
    super.init()
    // 3
    inset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
  }
}

    1
    2
    3
    4
    5
    6
    7
    8
    9
    10
    11
    12
    13
    14

这个 section controller 会从 didUpdate(to:) 方法中接收到一个 Weather 对象。
expanded 是一个布尔值，用于保存天气 section 是否被展开。默认为 false,这样它下面的 cell 一开始是折叠的。

和另外几个 section 一样，底部 inset 设置为 15 像素。

加一个 IGListSectionType 扩展，实现 3 个 required 方法:

extension WeatherSectionController: IGListSectionType {
  // 1
  func didUpdate(to object: Any) {
    weather = object as? Weather
  }

  // 2
  func numberOfItems() -> Int {
    return expanded ? 5 : 1
  }

  // 3
  func sizeForItem(at index: Int) -> CGSize {
    guard let context = collectionContext else { return .zero }
    let width = context.containerSize.width
    if index == 0 {
      return CGSize(width: width, height: 70)
    } else {
      return CGSize(width: width, height: 40)
    }
  }
}

    1
    2
    3
    4
    5
    6
    7
    8
    9
    10
    11
    12
    13
    14
    15
    16
    17
    18
    19
    20
    21
    22

    在 didUpdate(to:) 方法中，你保存了传入的 Weather 对象。
    如果天气被展开，numberOfItems() 返回 5 个 cell，这样它会包含天气数据的每个部分。如果不是展开状态，只返回一个用于显示占位内容的 cell。
    第一个 cell 会比其他 cell 大一点，因为它是一个 Header。没有必要判断展开状态，因为 Header cell 只会显示在第一个 cell。

然后你需要实现 cellForItem(at:)方法来配置 weather cell。有几个细节需要注意：

    第一个 cell 是 WeatherSummaryCell 类型，其他 cell 是 WeatherDetailCell 类型。
    通过 cell.setExpanded(_:) 方法来配置 WeatherSummaryCell。

    配置 4 个不同的 WeatherDetailCell 用下列 title 和 detail 标签：
        “Sunrise” - weather.sunrise
        “Sunset” - weather.sunset
        “High” - “(weather.high) C”
        “Low” - “(weather.low) C”

试着配置一下这个 cell! 参考答案如下。

func cellForItem(at index: Int) -> UICollectionViewCell {
  let cellClass: AnyClass = index == 0 ? WeatherSummaryCell.self : WeatherDetailCell.self
  let cell = collectionContext!.dequeueReusableCell(of: cellClass, for: self, at: index)
  if let cell = cell as? WeatherSummaryCell {
    cell.setExpanded(expanded)
  } else if let cell = cell as? WeatherDetailCell {
    let title: String, detail: String
    switch index {
    case 1:
      title = "SUNRISE"
      detail = weather.sunrise
    case 2:
      title = "SUNSET"
      detail = weather.sunset
    case 3:
      title = "HIGH"
      detail = "\(weather.high) C"
    case 4:
      title = "LOW"
      detail = "\(weather.low) C"
    default:
      title = "n/a"
      detail = "n/a"
    }
    cell.titleLabel.text = title
    cell.detailLabel.text = detail
  }
  return cell
}

    1
    2
    3
    4
    5
    6
    7
    8
    9
    10
    11
    12
    13
    14
    15
    16
    17
    18
    19
    20
    21
    22
    23
    24
    25
    26
    27
    28
    29

最后还有最后一件事情，当 cell 被点击时，切换 section 的展开状态并刷新 cell。在 IGListSectionType 扩展后实现这个 required 协议方法:

func didSelectItem(at index: Int) {
  expanded = !expanded
  collectionContext?.reload(self)
}

    1
    2
    3
    4

reload() 方法重新加载整个 section。当 section controller 中的 cell 的数目或者内容发生变化时，你可以调用这个方法。因此我们通过 numberOfItems() 方法切换 section 的展开状态，在这个方法中根据 expanded 的值来添加或减少 cell 的数目。

回到 FeedViewController.swift, 在头部加入属性:

let wxScanner = WxScanner()

    1

WxScanner 是一个用于天气情况的模型对象。
然后，修改 IGListAdapterDataSource 扩展中的 objects(for:) 方法：

// 1
var items: [IGListDiffable] = [wxScanner.currentWeather]
items += loader.entries as [IGListDiffable]
items += pathfinder.messages as [IGListDiffable]
// 2
return items.sorted(by: { (left: Any, right: Any) -> Bool in
  if let left = left as? DateSortable, let right = right as? DateSortable {
    return left.date > right.date
  }
  return false
})

    1
    2
    3
    4
    5
    6
    7
    8
    9
    10
    11

我们修改了数据源方法，让它增加 currentWeather 的数据。代码解释如下：

    将 currentWeather 添加到 items 数组。
    让所有数据实现 DataSortable 协议，以便用于排序。这样数据会按照日期前后顺序排列。

最后，修改 listAdapter(_:sectionControllerFor:) 方法:

if object is Message {
  return MessageSectionController()
} else if object is Weather {
  return WeatherSectionController()
} else {
  return JournalSectionController()
}

    1
    2
    3
    4
    5
    6
    7

现在，当 object 是 Weather 类型时，返回一个 WeatherSectionController。

运行 app。你会在顶部看到新的天气对象。点击这个 section，展开和收起它！

更新操作

JPL 对你的进度相当的满意！当你在工作时，NASA 的 director 组织了对宇航员的营救工作，要求他起飞并拦截另一艘飞船！这是一次复杂的起飞，他起飞的时间必须十分精确。

JPL 工程师扩展了消息模块，加入了实时聊天功能，要求你集成它。
打开 FeedViewController.swift 在 viewDidLoad() 方法最后一行加入:

pathfinder.delegate = self
pathfinder.connect()

    1
    2

这个 Pathfinder 模块增加了实时聊天支持。你需要做的仅仅是连接这个模块并处理委托事件。

在文件底部增加新的扩展：

extension FeedViewController: PathfinderDelegate {
  func pathfinderDidUpdateMessages(pathfinder: Pathfinder) {
    adapter.performUpdates(animated: true)
  }
}

    1
    2
    3
    4
    5

FeedViewController 现在实现了 PathfinderDelegate 协议。只有一个 performUpdates(animated:completion:) 方法，用于告诉 IGListAdapter 查询数据源中的新对象并刷新UI。这个方法用于处理对象被删除、更新、移动或插入的情况。

运行 app，你会看到标题上消息正在刷新！你只不过是为 IGListKit 添加了一个方法，用于说明数据源发生了什么变化，并在收到新数据时执行修改动画。

现在，你所需要做的仅仅是将最新版本发给宇航员，他就能回家了！干得不错!
结束

在这里下载最后完成的项目。

在帮助一位搁浅的宇航员回家的同时，你学习了 IGListKit 的基本功能：section controller、adapter、以及如何将它们组合在一起。还有其他重要的功能，比如 supplementary view 和 display 事件。

你可以阅读 Instagram 放在 Realm 上关于为什么要编写 IGListKit 的讨论。这个讨论中提到了许多在编写 app 时经常遇到在 UICollecitonView 中出现的问题。

如果你对参加 IGListKit 有兴趣，开发团队为了便于让你开始，在 Github 上创建了一个 starter-task 的tag。