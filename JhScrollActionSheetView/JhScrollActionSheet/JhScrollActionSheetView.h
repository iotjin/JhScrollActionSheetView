//
//  JhScrollActionSheetView.h
//  JhScrollActionSheetView
//
//  Created by Jh on 2018/11/26.
//  Copyright © 2018 Jh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JhScrollActionSheetView;

typedef void(^clickShareBlock)(JhScrollActionSheetView *actionSheet, NSInteger index);

@interface JhScrollActionSheetView : UIView

@property (nonatomic, copy) void (^clickShareBlock)(JhScrollActionSheetView *actionSheet, NSInteger index);
@property (nonatomic, copy) void (^clickOtherBlock)(JhScrollActionSheetView *actionSheet, NSInteger index);


/**
 创建JhScrollActionSheetView对象
 
 @param title 标题 (传nil时隐藏)
 @param shareDataArray 第一行的数据
 @param otherDataArray 第二行的数据 (传nil时隐藏)
 @return JhScrollActionSheetView对象
 */
- (instancetype)initWithTitle:(NSString *)title
               shareDataArray:(NSArray *)shareDataArray
               otherDataArray:(NSArray *)otherDataArray;

/**
 弹出JhScrollActionSheetView视图(只有一行数据)
 
 @param title 标题 (传nil时隐藏)
 @param shareDataArray 第一行的数据
 @param clickShareBlock block回调
 */
+ (void)showShareActionSheetWithTitle:(NSString *)title
                       shareDataArray:(NSArray *)shareDataArray
                              handler:(clickShareBlock)clickShareBlock;

/**
 * 弹出视图
 */
- (void)show;


@end


NS_ASSUME_NONNULL_END
