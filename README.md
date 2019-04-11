# JSDrawer

<p align="center">
<a href="https://github.com/apple/swift"><img src="https://img.shields.io/badge/language-swift-red.svg"></a>
<a href="https://github.com/apple/swift"><img src="https://img.shields.io/badge/swift%20version-4.2-orange.svg"></a>
<a href="https://github.com/spirit-jsb/JSDrawer/"><img src="https://img.shields.io/cocoapods/v/JSDrawer.svg?style=flat"></a>
<a href="https://github.com/spirit-jsb/JSDrawer/blob/master/LICENSE"><img src="https://img.shields.io/cocoapods/l/JSDrawer.svg?style=flat"></a>
<a href="https://cocoapods.org/pods/JSDrawer"><img src="https://img.shields.io/cocoapods/p/JSDrawer.svg?style=flat"></a>
</p>

## 示例代码

如需要运行示例项目，请 `clone` 当前 `repo` 到本地，并且从根目录下执行 `JSDrawer.xcworkspace`，打开项目后切换 `Scheme` 至 `JSDrawer-Demo` 即可。

## 基本使用
基本使用方法如下：
```swift
func js_showDrawer(_ viewController: UIViewController, animationType: AnimationType, config: JSDrawerConfig? = nil)
    
func js_pushViewController(_ viewController: UIViewController, hideAnimateDuration: TimeInterval = 0.0)

func js_presentViewController(_ viewController: UIViewController, isDrawerHide: Bool = false)

func js_dismissViewController()
```

## Swift 版本依赖
| Swift | JSDrawer |
| ------| ---------|
| 4.2   | >= 1.0.0 |

## 限制条件
* **iOS 9.0** and Up
* **Xcode 10.0** and Up
* **Swift Version = 4.2**

## 安装

`JSDrawer` 可以通过 [CocoaPods](https://cocoapods.org) 获得。安装只需要在你项目的 `Podfile` 中添加如下字段：

```ruby
pod 'JSDrawer', '~> 1.0.0'
```

## 作者

spirit-jsb, sibo_jian_29903549@163.com

## 许可文件

`JSDrawer` 可在 `MIT` 许可下使用，更多详情请参阅许可文件。