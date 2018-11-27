//
//  ViewController.m
//  JhScrollActionSheetView
//
//  Created by Jh on 2018/11/26.
//  Copyright © 2018 Jh. All rights reserved.
//

#import "ViewController.h"
#import "MJExtension.h"
#import "JhPageItemModel.h"

#import "JhScrollActionSheetView.h"


@interface ViewController ()

/** item数组 */
@property (nonatomic, strong) NSMutableArray *shareArray;
@property (nonatomic, strong) NSMutableArray *otherArray;

@end

@implementation ViewController


-(NSMutableArray *)shareArray{
    if (!_shareArray) {
        _shareArray = [NSMutableArray new];
        
            NSArray *data = @[
                              @{
                                  @"text" : @"微信",
                                  @"img" : @"weixing",
                                  },
                              @{
                                  @"text" : @"朋友圈",
                                  @"img" : @"friends",
                                  },
                              @{
                                  @"text" : @"微博",
                                  @"img" : @"sina",
                                  },
                              @{
                                  @"text" : @"QQ",
                                  @"img" : @"qq",
                                  },
                              @{
                                  @"text" : @"QQ空间",
                                  @"img" : @"kongjian",
                                  },
                              
                              
                              
                              
                              @{
                                  @"text" : @"微信",
                                  @"img" : @"weixing",
                                  },
                              @{
                                  @"text" : @"朋友圈",
                                  @"img" : @"friends",
                                  },
                              @{
                                  @"text" : @"微博",
                                  @"img" : @"sina",
                                  },
                              @{
                                  @"text" : @"QQ",
                                  @"img" : @"qq",
                                  },
                              @{
                                  @"text" : @"QQ空间",
                                  @"img" : @"kongjian",
                                  },
                              
                              
                              ];
    
         self.shareArray = [JhPageItemModel mj_objectArrayWithKeyValuesArray:data];

        
    }
    return _shareArray;
}



-(NSMutableArray *)otherArray{
    if (!_otherArray) {
        _otherArray = [NSMutableArray new];
        
        NSArray *data = @[
                          @{
                              @"text" : @"字体设置",
                              @"img" : @"fontsize",
                              },
                          @{
                              @"text" : @"复制链接",
                              @"img" : @"copylink",
                              },
                          @{
                              @"text" : @"字体设置",
                              @"img" : @"fontsize",
                              },
                          @{
                              @"text" : @"复制链接",
                              @"img" : @"copylink",
                              },
                          
                          @{
                              @"text" : @"字体设置",
                              @"img" : @"fontsize",
                              },
                          @{
                              @"text" : @"复制链接",
                              @"img" : @"copylink",
                              },
                          
                          @{
                              @"text" : @"字体设置",
                              @"img" : @"fontsize",
                              },
                       
                          
                          
                          ];
        
        self.otherArray = [JhPageItemModel mj_objectArrayWithKeyValuesArray:data];
        
        
    }
    return _otherArray;
}






- (void)viewDidLoad {
    [super viewDidLoad];

    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(100, 100, 50, 50);
    shareBtn.backgroundColor = [UIColor orangeColor];
    [shareBtn setTitle:@"样式1" forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    shareBtn.tag = 11;
    [self.view addSubview:shareBtn];
    
    
    UIButton *shareBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn2.frame = CGRectMake(100, 200, 50, 50);
    shareBtn2.backgroundColor = [UIColor orangeColor];
    [shareBtn2 setTitle:@"样式2" forState:UIControlStateNormal];
    [shareBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shareBtn2 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    shareBtn2.tag = 12;
    [self.view addSubview:shareBtn2];
    
    
    UIButton *shareBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn3.frame = CGRectMake(100, 500, 50, 50);
    shareBtn3.backgroundColor = [UIColor orangeColor];
    [shareBtn3 setTitle:@"样式3" forState:UIControlStateNormal];
    [shareBtn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shareBtn3 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    shareBtn3.tag = 13;
    [self.view addSubview:shareBtn3];
    
    
    
    
    
}



-(void)click:(UIButton *)btn{


    switch (btn.tag) {
        case 11:
        {
            
                    JhScrollActionSheetView *actionSheet = [[JhScrollActionSheetView alloc]initWithTitle:@"分享到"  shareDataArray:self.shareArray otherDataArray:self.otherArray];
                    //    [self.view addSubview:actionSheetView];
                    actionSheet.clickShareBlock = ^(JhScrollActionSheetView *actionSheet, NSInteger index) {
                        NSLog(@" 点击分享 index %ld ",(long)index);
                    };
                    actionSheet.clickOtherBlock = ^(JhScrollActionSheetView *actionSheet, NSInteger index) {
                        NSLog(@" 点击其他 index %ld ",(long)index);
                    };
            
                    [actionSheet show];
            
            
        }
            break;
            
        case 12:
        {
            
                    [JhScrollActionSheetView showShareActionSheetWithTitle:@"分享" shareDataArray:self.shareArray handler:^(JhScrollActionSheetView *actionSheet, NSInteger index) {
                        NSLog(@" 点击分享 index %ld ",(long)index);
                        
                    }];
            
            
            
        }
            break;
            
            
        case 13:
        {
            
                    [JhScrollActionSheetView showShareActionSheetWithTitle:@"" shareDataArray:self.shareArray handler:^(JhScrollActionSheetView *actionSheet, NSInteger index) {
                        NSLog(@"点击分享 index %ld ",(long)index);
                        
                    }];
            
        }
            break;
            
        default:
            break;
    }
    


}



@end
