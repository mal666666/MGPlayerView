# MGPlayerView

[![CI Status](https://img.shields.io/travis/mal666666@163.com/MGPlayerView.svg?style=flat)](https://travis-ci.org/mal666666@163.com/MGPlayerView)
[![Version](https://img.shields.io/cocoapods/v/MGPlayerView.svg?style=flat)](https://cocoapods.org/pods/MGPlayerView)
[![License](https://img.shields.io/cocoapods/l/MGPlayerView.svg?style=flat)](https://cocoapods.org/pods/MGPlayerView)
[![Platform](https://img.shields.io/cocoapods/p/MGPlayerView.svg?style=flat)](https://cocoapods.org/pods/MGPlayerView)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

MGPlayerView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MGPlayerView'
```
## Usage
```
PlayerView *playerView =[[PlayerView alloc]initWithFrame:CGRectMake(0, 80, self.view.bounds.size.width, self.view.bounds.size.width *9/16)];
[self.view addSubview:playerView];
[playerView playWithUrl:@"http://stream1.shopch.jp/HLS/out1/prog_index.m3u8"];
[playerView supportFullScreenWithVC:self];
playerView.delegateUI =self;
```
```
-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}
```
```
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
```
## Author

mal666666@163.com, mal666666@163.com

## License

MGPlayerView is available under the MIT license. See the LICENSE file for more info.
