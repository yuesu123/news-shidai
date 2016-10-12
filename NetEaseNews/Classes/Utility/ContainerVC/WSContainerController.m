//
//  WSContainerController.m
//  WSContainViewController
//
//  Created by WackoSix on 16/1/6.
//  Copyright © 2016年 WackoSix. All rights reserved.
//

#import "WSContainerController.h"
#import "WSNavigationView.h"
#import "SXAdManager.h"
#import "LargeClickBtn.h"
#import "WSMenuInstance.h"
#import "WSTabBarController.h"

#define keyWindow [UIApplication sharedApplication].keyWindow
@interface WSContainerController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) NSArray *viewControllers;

@property (assign, nonatomic) NSInteger selectedIndex;

@property (weak, nonatomic) UICollectionView *collectionView;

@property (weak, nonatomic) UICollectionViewFlowLayout *flowLayout;

@property (weak, nonatomic) WSNavigationView *navigationView;

@property (nonatomic ,strong) UIView *adView;
@property (nonatomic, strong) UIImageView *adBottomImg1;
@property (nonatomic, strong)  UIButton* skipBtn;
@property (nonatomic, strong)  UIButton* btn;

@end

static NSString *CellID = @"ControllerCell";

@implementation WSContainerController


#pragma mark - collectionView datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.viewControllers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellID forIndexPath:indexPath];
    
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIView *view = [self.viewControllers[indexPath.item] view];
    
    [cell.contentView addSubview:view];
    
    view.frame = cell.bounds;
    
    return cell;
}

#pragma mark - collectionView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger index = scrollView.contentOffset.x / self.view.bounds.size.width;
    
    self.navigationView.selectedItemIndex = index;
}

#pragma mark - setting

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    
    _selectedIndex = selectedIndex;
    
    CGFloat offsetX = self.view.bounds.size.width * selectedIndex;
    
    self.collectionView.contentOffset = CGPointMake(offsetX, 0);
}

#pragma mark - view

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //禁用滚动到最顶部的属性
    self.collectionView.scrollsToTop = NO;
   [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
}

- (void)addNavHomeBtn{
    CGFloat width = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.height;
    CGFloat topNav = 64;
    CGFloat bottomTab = 49;
    int addbtnW = 0;
    ECLog(@"选中:%ld",self.tabBarController.selectedIndex);
    if (0 == self.tabBarController.selectedIndex) {
        addbtnW = Main_Screen_Width/(self.viewControllers.count+1);
        
        self.navigationView.isHome = YES;
    }else{
        self.navigationView.isHome = NO;
        addbtnW = 0;
    }
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, topNav, addbtnW, 35)];
    [addBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    addBtn.titleLabel.textColor = [UIColor blackColor];
    [addBtn setTitle:@"首页" forState:UIControlStateNormal];
    //    addBtn.backgroundColor = [UIColor redColor];
    [addBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:addBtn];
    

    
    if (self.navigationController && self.tabBarController) {
        
        self.navigationView.frame = CGRectMake(addbtnW, topNav, width-addbtnW, 44);
        self.collectionView.frame = CGRectMake(0, topNav+self.navigationView.frame.size.height, width, height - self.navigationView.frame.size.height - bottomTab - topNav);
        
    }else{
        ECLog(@"导航栏不存在");
        //        self.navigationView.frame = CGRectMake(addbtnW, 0, width, 44);
        self.navigationView.frame = CGRectMake(addbtnW, topNav, width-addbtnW, 44);
        
    }

}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    [self addNavHomeBtnAll];

    
    
    self.flowLayout.itemSize = self.collectionView.bounds.size;
    
}

- (void)addNavHomeBtnAll{
    NSInteger count = [WSMenuInstance sharedWSMenuInstance].tabbarArr.count;
    if([WSTabBarController isShowZt]){
        count = count+1;
    }
    if (self.tabBarController.selectedIndex == 0) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self addNavHomeBtn];
        });
    }
    if (count<2) {
        return;
    }
    if (self.tabBarController.selectedIndex == 1) {
        
        if ([WSTabBarController isShowZt]) {
            return;
        }
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self addNavHomeBtn];
        });
    }
    if (count<3) {
        return;
    }
    if (self.tabBarController.selectedIndex == 2) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self addNavHomeBtn];
        });
    }
    if (count<4) {
        return;
    }
    if (self.tabBarController.selectedIndex == 3) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self addNavHomeBtn];
        });
    }
    if (count<5) {
        return;
    }
    if (self.tabBarController.selectedIndex == 4) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self addNavHomeBtn];
        });
    }
}

- (void)addBtnClicked{
    ECLog(@"首页广告点击");
    [self adImage];
}
- (void)oneFingerTwoTaps:(UIButton*)btn{
    
    //    [btn removeFromSuperview];
    [_btn removeFromSuperview];
    [self addImageFinish:YES time:0.2];
    
    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationAddTap object:nil];
        ECLog(@"抛出点击通知");
//    });
}


- (void)adImage{
    [SXAdManager loadLatestAdImage];
    UIView *adView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    adView.userInteractionEnabled = YES;
    _adView = adView;
    UIImageView *adBottomImg1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lauch_bottom"]];
    adBottomImg1.frame = CGRectMake(0, self.view.height - 135, self.view.width, 135);
    _adBottomImg1 = adBottomImg1;

    [keyWindow addSubview:adBottomImg1];
    
    
    
    if ([SXAdManager isShouldDisplayAd]) {
        
        
        UIImageView *adImg = [[UIImageView alloc]initWithImage:[SXAdManager getAdImage]];
        //添加网易新闻有态度的门户的图片
        UIImageView *adBottomImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lauch_bottom"]];
        adView.backgroundColor = [UIColor whiteColor];
        [adView addSubview:adBottomImg];
        [adView addSubview:adImg];
        adImg.userInteractionEnabled = YES;
        adBottomImg.frame = CGRectMake(0, self.view.height - 135, self.view.width, 135);
        adImg.frame = CGRectMake(0, 0, self.view.width, self.view.height - 135);
        //返回
        UIButton *btn = [[UIButton alloc] initWithFrame:adImg.bounds];
//        btn.backgroundColor = [UIColor redColor];
//        [btn addTarget:self action:@selector(oneFingerTwoTaps:) forControlEvents:UIControlEventTouchUpInside];
        _btn = btn;
        
        //点击广告
//        [btn addTarget:self action:@selector(oneFingerTwoTaps:) forControlEvents:UIControlEventTouchUpInside];
        adView.alpha = 0.99f;
        [keyWindow addSubview:adView];
        [keyWindow addSubview:btn];

//        [keyWindow addSubview:btn];
        
        //添加跳过按钮
        LargeClickBtn *skipBtn = [[LargeClickBtn alloc] initWithFrame:CGRectMake(Main_Screen_Width-90, 20, 50, 30)];
        skipBtn.backgroundColor = [UIColor grayColor];
        [skipBtn setTitle:@"返回" forState:UIControlStateNormal];
        [skipBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [QTCommonTools clipAllView:skipBtn Radius:skipBtn.height*0.5 borderWidth:0 borderColor:nil];
        _skipBtn = skipBtn;
        [keyWindow addSubview:skipBtn];
        [skipBtn addTarget:self action:@selector(skipBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        
        [UIView animateWithDuration:2.8 animations:^{
            adView.alpha = 1.0f;
        } completion:^(BOOL finished) {
            [self addImageFinish:finished time:1];
        }];
    }else{
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"update"];
    }
}

- (void)skipBtnClicked{
    [self addImageFinish:YES time:0.2];
}

- (void)addImageFinish:(BOOL)finished time:(CGFloat)dalaytime{
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    [UIView animateWithDuration:dalaytime animations:^{
        _adView.alpha = 0.0f;
        _adBottomImg1.alpha = 0.0f;
        _skipBtn.alpha = 0.0;
        _btn.alpha = 0.0;
    } completion:^(BOOL finished) {
        [_skipBtn removeFromSuperview];
        [_adBottomImg1 removeFromSuperview];
        [_adView removeFromSuperview];
        [_btn removeFromSuperview];
    }];
}

#pragma mark - init



- (void)setParentController:(UIViewController *)parentController{
    
    _parentController = parentController;
    
    [parentController addChildViewController:self];
    [parentController.view addSubview:self.view];
}

+ (instancetype)containerControllerWithSubControlers:(NSArray<UIViewController *> *)viewControllers parentController:(UIViewController *)vc{
    
    id container = [[self alloc] init];
    
    [container setViewControllers:viewControllers];
    [container setParentController:vc];

    __block NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:viewControllers.count];
    [viewControllers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [container addChildViewController:obj];
        [arrM addObject:obj.title ? : @""];
    }];
    
    [container navigationView].items = arrM.copy;
    [container navigationView].selectedItemIndex = 0;

    
    return container;
}

- (instancetype)init{
    
    if (self = [super init]) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout = flowLayout;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        
        //设置collectionView的属性
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        collectionView.pagingEnabled = YES;
        _collectionView = collectionView;
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CellID];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.backgroundColor = [UIColor lightGrayColor];
        collectionView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:collectionView];
        
        
        //添加导航view
        typeof(self) __weak weakObj= self;
        WSNavigationView *view = [WSNavigationView navigationViewWithItems:nil itemClick:^(NSInteger selectedIndex) {
            
            [weakObj setSelectedIndex:selectedIndex];
        }];
        view.backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:view];
        
        [self setNavigationView:view];
        
    }
    return self;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //临时改变个颜色，看好，只是临时改变的。如果要永久改变，可以先改数据源，然后在cellForItemAtIndexPath中控制。（和UITableView差不多吧！O(∩_∩)O~）
//    cell.backgroundColor = [UIColor greenColor];

}


- (void)dealloc{
    
    NSLog(@"%s",__func__);
}


@end
