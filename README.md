# JhScrollActionSheetView
JhScrollActionSheetView - UIcollectionView横向滚动,类似微博新版的详情页分享界面 <br> 
可设置单排或双排显示,title不设置不显示title <br> 
如果想实现发送站内用户的功能,自己可以改一下代码


![](https://raw.githubusercontent.com/iotjin/JhScrollActionSheetView/master/JhScrollActionSheetView/screenshots/0.gif)  

![](https://raw.githubusercontent.com/iotjin/JhScrollActionSheetView/master/JhScrollActionSheetView/screenshots/1.png)  <br>

![](https://raw.githubusercontent.com/iotjin/JhScrollActionSheetView/master/JhScrollActionSheetView/screenshots/2.png)  <br> 

![](https://raw.githubusercontent.com/iotjin/JhScrollActionSheetView/master/JhScrollActionSheetView/screenshots/3.png)  <br> 

## Examples



* Demo1
```
      //带标题,双排
     JhScrollActionSheetView *actionSheet = [[JhScrollActionSheetView alloc]initWithTitle:@"分享到"  shareDataArray:self.shareArray otherDataArray:self.otherArray];
      actionSheet.clickShareBlock = ^(JhScrollActionSheetView *actionSheet, NSInteger index) {
          NSLog(@" 点击分享 index %ld ",(long)index);
      };
      actionSheet.clickOtherBlock = ^(JhScrollActionSheetView *actionSheet, NSInteger index) {
          NSLog(@" 点击其他 index %ld ",(long)index);
      };

      [actionSheet show];

```

* Demo2
```
          //带标题,单排
         [JhScrollActionSheetView showShareActionSheetWithTitle:@"分享" shareDataArray:self.shareArray handler:^(JhScrollActionSheetView *actionSheet, NSInteger index) {
          NSLog(@" 点击分享 index %ld ",(long)index);
                        
           }];    
    

```

* Demo3
```
        //不带标题,单排  
       [JhScrollActionSheetView showShareActionSheetWithTitle:@"" shareDataArray:self.shareArray handler:^(JhScrollActionSheetView *actionSheet, NSInteger index) {
                        NSLog(@"点击分享 index %ld ",(long)index);
                        
                    }];

```
