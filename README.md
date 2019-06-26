# 你刚好需要，我刚好出现，请赏一颗小星星.
        
<p align="center" >
<p align="center" >
效果展示
</p>
</p>
<img src="https://github.com/wufuzeng/FZToastExtention/blob/master/Screenshots/781561540706_.pic.png" title="" float=left width = '200px' />
<img src="https://github.com/wufuzeng/FZToastExtention/blob/master/Screenshots/781561540707_.pic.jpg" title="" float=left width = '200px' />
<img src="https://github.com/wufuzeng/FZToastExtention/blob/master/Screenshots/781561540708_.pic.jpg" title="" float=left width = '200px' />
<img src="https://github.com/wufuzeng/FZToastExtention/blob/master/Screenshots/781561540709_.pic.jpg" title="" float=left width = '200px' />
<img src="https://github.com/wufuzeng/FZToastExtention/blob/master/Screenshots/781561540710_.pic.jpg" title="" float=left width = '200px' />

# FZToastExtention

##  特征
- [x]  1.提供文本提示。  
- [x]  2.提供标题和内容提示。
- [x]  3.提供loading提示。
- [x]  4.提供重载按钮事件。
- [x]  5.提供取消按钮事件。
- [x]  6.可同时提供以上所有功能。
- [x]  7.提供提示视图自定义。

[![CI Status](https://img.shields.io/travis/wufuzeng/FZToastExtention.svg?style=flat)](https://travis-ci.org/wufuzeng/FZToastExtention)
[![Version](https://img.shields.io/cocoapods/v/FZToastExtention.svg?style=flat)](https://cocoapods.org/pods/FZToastExtention)
[![License](https://img.shields.io/cocoapods/l/FZToastExtention.svg?style=flat)](https://cocoapods.org/pods/FZToastExtention)
[![Platform](https://img.shields.io/cocoapods/p/FZToastExtention.svg?style=flat)](https://cocoapods.org/pods/FZToastExtention)

## 例

要运行示例项目，请克隆repo，然后从Example目录运行 ”pod install“。

## 要求


## 安装

FZToastExtention 可通过[CocoaPods](https://cocoapods.org)获得. 要安装它，只需将以下行添加到Podfile文件

```ruby
pod 'FZToastExtention'
```

## 怎样使用

* Objective-C

```objective-c

#import <FZToastExtention/FZToastExtention.h>

[self.view fz_showLoading];

[self.view fz_showMsg:@"holle world !"];

[self.view fz_showWithIcon:[UIImage imageNamed:@"submitSucceed"] title:@"title" msg:@"message" reload:^{

} cancel:^{

}];

[self.view fz_showWithIcon:[UIImage imageNamed:@"submitSucceed"] msg:@"success !"];

[self.view fz_showLoadingWithMsg:@"纵有疾风起,\n人生不言弃!" cancel:^{

}];

```
 

## 作者

wufuzeng, wufuzeng_lucky@sina.com
### 纵有疾风起，人生不言弃

## 许可证

FZToastExtention is available under the MIT license. See the LICENSE file for more info.
