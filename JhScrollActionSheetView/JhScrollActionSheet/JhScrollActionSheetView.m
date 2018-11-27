//
//  JhScrollActionSheetView.m
//  JhScrollActionSheetView
//
//  Created by Jh on 2018/11/26.
//  Copyright © 2018 Jh. All rights reserved.
//

#import "JhScrollActionSheetView.h"
#import "JhPageItemCell.h"


#define Kwidth  [UIScreen mainScreen].bounds.size.width
#define Kheight  [UIScreen mainScreen].bounds.size.height

#define JhColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define JhRandomColor JhColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))

#define kBottomSafeHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?34:0)


/** title视图的总高度 */
#define kTitleViewFrameH (self.isHiddenTitleLabel == YES ? 0 : 50)
/** 两个滚动视图的总高度 */
#define kScrollViewFrameH (self.isHiddenOtherCollectionView == YES ? 100 : 200)
/** 整个视图的总高度 */
#define kViewFrameH  (kTitleViewFrameH + kScrollViewFrameH + 50 + kBottomSafeHeight)

#define itemHorizontalMargin 0
#define kTopBottomMargin 0


static const NSTimeInterval kAnimateDuration = 0.5f;


@interface JhScrollActionSheetView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *shareArray;
@property (nonatomic, strong) NSArray *otherArray;

/** 弹出视图 */
@property (strong, nonatomic) UIView *actionSheetView;
@property (nonatomic, strong) UICollectionView *shareCollectionView;
@property (nonatomic, strong) UICollectionView *otherCollectionView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UILabel  *titleLabel;

@property (nonatomic, strong) NSString *titleStr;

/** collectionView 高度  */
@property (nonatomic, assign) CGFloat collectionViewH;
/** title传nil时,为YES */
@property (assign, nonatomic) BOOL isHiddenTitleLabel;
/** 当设置为YES时, kScrollViewFrameH 高度为一半 */
@property (assign, nonatomic) BOOL isHiddenOtherCollectionView;


/**
 * 收起视图
 */
- (void)dismiss;


@end

@implementation JhScrollActionSheetView

static NSString * const reuseIdentifier = @"Cell";



- (instancetype)initWithTitle:(NSString *)title
               shareDataArray:(NSArray *)shareDataArray
               otherDataArray:(NSArray *)otherDataArray{
    
    self = [super initWithFrame:CGRectZero];
    if (self)
    {
        _titleStr = title;
        _shareArray = shareDataArray;
        _otherArray = otherDataArray;

        
            
        [self setUpSubviews];
        
        
//        [self show];
        
    }
    
    return self;
    
}


-(void)setUpSubviews{
    

    self.backgroundColor  = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3f];
    self.frame = CGRectMake(0, 0, Kwidth, Kheight);
    self.userInteractionEnabled = YES;
    
    //title不传时,隐藏title
    if (!_titleStr.length) {
        _isHiddenTitleLabel = YES;
    }else{
        _isHiddenTitleLabel =NO;
    }
    
    //当otherArray为空时,隐藏otherCollectionView
    if (!_otherArray.count) {
        
        _isHiddenOtherCollectionView = YES;
        _collectionViewH =  kScrollViewFrameH + kTopBottomMargin*2;
        
        [self actionSheetView];
        [self titleLabel];
        [self shareCollectionView];
        [self cancelBtn];
        self.cancelBtn.frame = CGRectMake(0, CGRectGetMaxY(self.shareCollectionView.frame), Kwidth, 50);
 
    }else{
        
        //全部显示
        _isHiddenOtherCollectionView = NO;
        _collectionViewH =  kScrollViewFrameH/2  + kTopBottomMargin*2;

        [self actionSheetView];
        [self titleLabel];
        [self shareCollectionView];
        [self otherCollectionView];
        [self cancelBtn];
        self.cancelBtn.frame = CGRectMake(0, CGRectGetMaxY(self.otherCollectionView.frame), Kwidth, 50);
        
    }
    
    
    _shareCollectionView.backgroundColor = [UIColor clearColor];
    _otherCollectionView.backgroundColor = [UIColor clearColor];
    _actionSheetView.backgroundColor =  JhColor(240, 240, 240);
    _cancelBtn.backgroundColor = [UIColor whiteColor];
    
    
//    _shareCollectionView.backgroundColor = JhRandomColor;
//    _otherCollectionView.backgroundColor = JhRandomColor;
//    _cancelBtn.backgroundColor =JhRandomColor;
//    _actionSheetView.backgroundColor = JhRandomColor;
    
    

    
    
}



-(UIView *)actionSheetView{
    if (!_actionSheetView) {
        
        UIView *actionSheetView = [[UIView alloc] init];
        CGRect frame = CGRectMake(0, Kheight, self.frame.size.width, kViewFrameH);
        actionSheetView.frame = frame;
    
        _actionSheetView =actionSheetView;
        [self addSubview:_actionSheetView];
        
    }
    return _actionSheetView;
}


-(UILabel *)titleLabel{
    if (!_titleLabel) {
        
        
        UILabel  *titleLabel = [[UILabel alloc]init];
        titleLabel.textColor = JhColor(170, 170, 170);
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = _titleStr;
        titleLabel.frame =CGRectMake(0, 0, Kwidth, kTitleViewFrameH);
        
        _titleLabel = titleLabel;

       [self.actionSheetView addSubview:self.titleLabel];

    }
    return _titleLabel;
}



-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        
        UIButton *cancelBtn = [[UIButton alloc]init];
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [cancelBtn addTarget:self action:@selector(clickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        
        _cancelBtn = cancelBtn;
        [self.actionSheetView addSubview:self.cancelBtn];
     
        
    }
    return _cancelBtn;
}

- (UICollectionView *)shareCollectionView{
    if (!_shareCollectionView) {
  
        CGFloat viewWidth = Kwidth;
        CGFloat viewHeight = _collectionViewH;
        
        CGFloat maxColumn = 5;
        CGFloat maxRow = 1;
        CGFloat itemW = (viewWidth - (maxColumn - 1) -0.1f) / maxColumn;
        CGFloat itemH = (viewHeight - (maxRow - 1)- 0.1f) / maxRow;
        
        UICollectionViewFlowLayout *layout =[[UICollectionViewFlowLayout alloc] init];
        //设置水平滚动
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //设置每个cell的尺寸
        layout.itemSize = CGSizeMake(itemW, itemH);
        //cell之间的水平间距  行间距
        layout.minimumLineSpacing = itemHorizontalMargin;
        //cell之间的垂直间距 cell间距
        layout.minimumInteritemSpacing = 0;
        //设置四周边距
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        CGRect Collectionframe =CGRectMake(0,CGRectGetMaxY(self.titleLabel.frame), viewWidth, viewHeight);
        
        _shareCollectionView = [[UICollectionView alloc] initWithFrame:Collectionframe collectionViewLayout:layout];
        
        
        [_shareCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([JhPageItemCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:reuseIdentifier];
        
        _shareCollectionView.delegate = self;
        _shareCollectionView.dataSource = self;
        
        // 这句话的意思是为了 不管集合视图里面的值 多不多  都可以滚动 解决了值少了 集合视图不能滚动的问题
//         _shareCollectionView.alwaysBounceVertical = YES;
//        _shareCollectionView.showsHorizontalScrollIndicator = NO;
        
        [self.actionSheetView addSubview:self.shareCollectionView];
        
    
        CGFloat lineHeight = 1.0;
        UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(_shareCollectionView.frame)-lineHeight, Kwidth, lineHeight)];
        line.backgroundColor=JhColor(230, 230, 230);
        [self.actionSheetView addSubview:line];
       
    }
    return _shareCollectionView;
}

- (UICollectionView *)otherCollectionView{
    if (!_otherCollectionView) {
        
        CGFloat viewWidth = Kwidth;
        CGFloat viewHeight = _collectionViewH;
        
        CGFloat maxColumn = 5;
        CGFloat maxRow = 1;
        CGFloat itemW = (viewWidth - (maxColumn - 1) -0.1f) / maxColumn;
        CGFloat itemH = (viewHeight - (maxRow - 1)- 0.1f) / maxRow;
        
        UICollectionViewFlowLayout *layout =[[UICollectionViewFlowLayout alloc] init];
        //设置水平滚动
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //设置每个cell的尺寸
        layout.itemSize = CGSizeMake(itemW, itemH);
        //cell之间的水平间距  行间距
        layout.minimumLineSpacing = itemHorizontalMargin;
        //cell之间的垂直间距 cell间距
        layout.minimumInteritemSpacing = 0;
        //设置四周边距
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        CGRect Collectionframe =CGRectMake(0, CGRectGetMaxY(self.shareCollectionView.frame), viewWidth, viewHeight);
        
        _otherCollectionView = [[UICollectionView alloc] initWithFrame:Collectionframe collectionViewLayout:layout];
        
        
        [_otherCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([JhPageItemCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:reuseIdentifier];
        
        _otherCollectionView.delegate = self;
        _otherCollectionView.dataSource = self;
        
        // 这句话的意思是为了 不管集合视图里面的值 多不多  都可以滚动 解决了值少了 集合视图不能滚动的问题
        //         _shareCollectionView.alwaysBounceVertical = YES;
        //        _shareCollectionView.showsHorizontalScrollIndicator = NO;
        
        [self.actionSheetView addSubview:self.otherCollectionView];
        
        
        
    }
    return _otherCollectionView;
}







#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == _shareCollectionView) {
        return self.shareArray.count;
    }else{
        return self.otherArray.count;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JhPageItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.data =self.shareArray[indexPath.row];

    if (collectionView == _shareCollectionView) {
        cell.data =self.shareArray[indexPath.row];
    }else{
        cell.data =self.otherArray[indexPath.row];
    }
    
    
//    cell.backgroundColor = JhRandomColor;
    
    return cell;
}


#pragma mark - 点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//     NSLog(@"点击cell --- indexPath --- %@",indexPath);
//    //获取UICollectionViewCell 的 cell的text
//    JhPageItemCell * cell2 = (JhPageItemCell *)[self collectionView:collectionView cellForItemAtIndexPath:indexPath];
//    NSString *text = cell2.customTextLabel.text;
//    NSLog(@" 点击 cell2 的text %@ ",text);
    
    
    __weak typeof(self) weakSelf = self;
    if (collectionView == _shareCollectionView) {
        
        if (weakSelf.clickShareBlock) {
            weakSelf.clickShareBlock(self, indexPath.row);
        }
        
    }else{
        
        if (weakSelf.clickOtherBlock) {
            weakSelf.clickOtherBlock(self, indexPath.row);
        }
        
    }
    
    [self dismiss];
    
    
}



/**
 弹出JhScrollActionSheetView视图(只有一行数据)
 
 @param title 标题 (传nil时隐藏)
 @param shareDataArray 第一行的数据
 @param clickShareBlock block回调
 */
+ (void)showShareActionSheetWithTitle:(NSString *)title
                       shareDataArray:(NSArray *)shareDataArray
                              handler:(clickShareBlock)clickShareBlock{
    
    JhScrollActionSheetView *actionSheetView = [[JhScrollActionSheetView alloc]initWithTitle:title shareDataArray:shareDataArray otherDataArray:nil];
    actionSheetView.clickShareBlock = clickShareBlock;
    [actionSheetView show];
    
}





- (void)show
{
    // 在主线程中处理,否则在viewDidLoad方法中直接调用,会先加本视图,后加控制器的视图到UIWindow上,导致本视图无法显示出来,这样处理后便会优先加控制器的视图到UIWindow上
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
        for (UIWindow *window in frontToBackWindows)
        {
            BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
            BOOL windowIsVisible = !window.hidden && window.alpha > 0;
            BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
            
            if(windowOnMainScreen && windowIsVisible && windowLevelNormal)
            {
                [window addSubview:self];
                break;
            }
        }
        
        
        [UIView animateWithDuration:kAnimateDuration delay:0.2 usingSpringWithDamping:0.7f initialSpringVelocity:0.7f options:UIViewAnimationOptionCurveEaseInOut animations:^{

                CGRect frame = CGRectMake(0, Kheight-kViewFrameH, Kwidth,kViewFrameH);
                self.actionSheetView.frame = frame;

        } completion:nil];
        
        
        
    }];
    
    
    
}


- (void)dismiss
{
    
    [UIView animateWithDuration:kAnimateDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];

    
}

#pragma mark - 点击取消按钮
-(void)clickCancelBtn{
    [self dismiss];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
}



- (void)dealloc
{
#ifdef DEBUG
    NSLog(@"JhScrollActionSheetView dealloc");
#endif
}







@end
