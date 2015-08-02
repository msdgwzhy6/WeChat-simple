# WeChat-simple
模仿类似WeChat的朋友界面和聊天界面，简单版本，纯练习学习用
***
接下来介绍下实现的功能：<br>
![](https://github.com/nongchaozhe/WeChat-simple/raw/master/screenshots/exercise1.png)  <br>
点击可展开朋友列表<br>
代码利用刷新某一组而不是全部刷新数据来实现列表展开
``` 
    //指定刷新某一组，效率高
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:index];
    [_tableViewFriends reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
```
***
点击Friend0进入聊天界面<br>
![](https://github.com/nongchaozhe/WeChat-simple/raw/master/screenshots/exercise2.png) <br>
利用此函数实现了聊天框的背景图片部分拉伸
```
chatImage = [chatImage stretchableImageWithLeftCapWidth:chatImage.size.width*0.5 topCapHeight:chatImage.size.height*0.7];
```
同时实现了聊天框的高度和长度随内容变化
***
点击输入框，弹出键盘<br>
![](https://github.com/nongchaozhe/WeChat-simple/raw/master/screenshots/exercise3.png) <br>
同时可以输入文字，send发送 <br>
![](https://github.com/nongchaozhe/WeChat-simple/raw/master/screenshots/exercise4.png) <br>
***
代码中实现了对Keyboard、In-Call Status Bar的监听及bottomView的视图位置改变<br>
![](https://github.com/nongchaozhe/WeChat-simple/raw/master/screenshots/exercise5.png) <br>
具体实现参见代码 <br>
***
这是挺早前学习tableView的时候的联系项目的，纯学习模仿，简单的应用~ <br>



