//
//  WSTabBarController.m
//  网易新闻
//
//  Created by WackoSix on 15/12/25.
//  Copyright © 2015年 WackoSix. All rights reserved.
//

#import "WSTabBarController.h"
#import "WSTabBar.h"
#import "WSNavigationController.h"
#import "SXAdManager.h"
#import "WSOneMenuModel.h"
#import "WSMenuInstance.h"
#import "QTLoginViewController.h"
#import "CheckNetWorkState.h"
#import "LargeClickBtn.h"

@interface WSTabBarController ()
@property (nonatomic ,strong) UIView *adView;
@property (nonatomic ,strong) UIButton *skipBtn;
@property (nonatomic ,strong) UIButton *btn;

@property (nonatomic, strong) UIImageView *adBottomImg1;
@end

@implementation WSTabBarController


- (void)viewDidLoad{
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    
    [self adImage];

    [self loadDataAllNewsMenu];

}


- (void)loadDataAllNewsMenu{
    [[QTUserInfo sharedQTUserInfo] loadUserInfoFromDefault];
    [HYBNetworking getWithUrl:@"api/menu"
                 refreshCache:YES
                       params:nil
                      success:^(id response) {
        if ([response isKindOfClass:[NSArray class]]){
            NSArray *deserializedArray = (NSArray *)response;
            NSMutableArray *menuAllArr = [WSOneMenuModel objectArrayWithKeyValuesArray:deserializedArray];
//            [self addTestmodel:menuAllArr];
            //获取总的数组
            [WSMenuInstance sharedWSMenuInstance].allMenuArr = menuAllArr;
            //获取导航数组
            [WSMenuInstance sharedWSMenuInstance].tabbarArr = [self getTabbarArr:[WSMenuInstance sharedWSMenuInstance].allMenuArr ];
            [self getMenuOneArr];
            [self loadMenu:YES];
            //去登录
            [self LoadDataLogin:NO];
        } else {
            [self loadMenu:NO];
            //去登录 需要延时
            [self LoadDataLogin:YES];
            NSLog(@"I can't deal with it");
        }
    } fail:^(NSError *error) {
        [self loadMenu:NO];
        //去登录 需要延时
        [self LoadDataLogin:YES];
    }];
}

- (void)LoadDataLogin:(BOOL)isDelay{
    QTLoginViewController *con =[[QTLoginViewController alloc] init];

    if (!isDelay) {
        [con loadDataLogin:NO];
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [con loadDataLogin:NO];
    });
    
    
}

//tian
- (void)addTestmodel:(NSMutableArray*)arr{

    WSOneMenuModel *mod = [[WSOneMenuModel alloc] init];
    mod.Id = 2;
    mod.Classname = @"hah2";
    mod.Classen = @"news";
    mod.Parentid = 0;//tabbar 为0
    mod.Parentpath = @"0.7.";
    mod.Sortid = 2;
    
    
    WSOneMenuModel *mod2 = [[WSOneMenuModel alloc] init];
    mod2.Id = 8;
    mod2.Classname = @"hah";
    mod2.Classen = @"news";
    mod2.Parentid = 7;
    mod2.Parentpath = @"0.7.1.";
    mod2.Sortid = 2;
    WSOneMenuModel *mod21 = [[WSOneMenuModel alloc] init];
    mod21.Id = 9;
    mod21.Classname = @"hah";
    mod21.Classen = @"news";
    mod21.Parentid = 7;
    mod21.Parentpath = @"0.7.2.";
    mod21.Sortid = 2;
    
    WSOneMenuModel *mod3 = [[WSOneMenuModel alloc] init];
    mod3.Id = 3;
    mod3.Classname = @"xingwen3";
    mod3.Classen = @"news";
    mod3.Parentid = 0;//tabbar 为0
    mod3.Parentpath = @"0.5.";
    mod3.Sortid = 3;
    
    WSOneMenuModel *mod4 = [[WSOneMenuModel alloc] init];
    mod4.Id = 2;
    mod4.Classname = @"xingwen4";
    mod4.Classen = @"news";
    mod4.Parentid = 5;
    mod4.Parentpath = @"0.5.1.";
    mod4.Sortid = 2;

    [arr addObject:mod];
    [arr addObject:mod2];
    [arr addObject:mod21];

//    [arr addObject:mod3];
//    [arr addObject:mod4];

    
}


- (void)loadMenu:(BOOL)success{
    [_adBottomImg1 removeFromSuperview];
    [self loadViewControllers:success];
    [self loadTabBarItems:success];
}


- (NSMutableArray *)getTabbarArr:(NSMutableArray*)arr{
    NSMutableArray *newArr = [NSMutableArray array];
    for (int i = 0; i < arr.count; i++) {
        WSOneMenuModel *model = [arr objectAtIndex:i];
        if (0 == model.Parentid) {
            [newArr addObject:model];
        }
    }
    NSRange range = NSMakeRange(0, 2);
    if(newArr.count == 3){
        range = NSMakeRange(0, 3);
    }else if(newArr.count == 2){
        range = NSMakeRange(0, 2);
    }else if(newArr.count == 1){
        range = NSMakeRange(0, 1);
    }else if(newArr.count == 0){
        range = NSMakeRange(0, 0);
    }
    NSArray *arraySort = [newArr subarrayWithRange:range];
    NSMutableArray *arraySortAfter = [arraySort sortedArrayUsingComparator:
                       ^NSComparisonResult(WSOneMenuModel *obj1, WSOneMenuModel *obj2) {
                           // 先按照姓排序
                           NSComparisonResult result = [getStrFromIntger(obj1.Parentid) compare:getStrFromIntger(obj2.Parentid)];
                           
                           return result;  
                       }];
    return arraySortAfter;
}

- (void)getMenuOneArr{
    //创建四个数组
    NSMutableArray *newArrone = [NSMutableArray array];
    NSMutableArray *newArrTwo = [NSMutableArray array];
    NSMutableArray *newArrThree = [NSMutableArray array];
    NSMutableArray *newArrFour = [NSMutableArray array];
    
    NSMutableArray *tabbarArr =[NSMutableArray arrayWithArray:[WSMenuInstance sharedWSMenuInstance].tabbarArr] ;
    NSMutableArray *allMenuArr = [WSMenuInstance sharedWSMenuInstance].allMenuArr;
    
    
    for (int i = 0; i < tabbarArr.count; i++) {
        
        //取出一个tabbar 元素
        WSOneMenuModel *modelTabar = [tabbarArr objectAtIndex:i];
        
        //遍历所有元素 和上面的tabbar 比较
        for (int j = 0 ;j < allMenuArr.count;j++) {
            WSOneMenuModel *allMenuOne = [allMenuArr objectAtIndex:j];
            //tabBar 的Parentpath
            NSString *paTabStr = modelTabar.Parentpath;
            //一个元素中串
            NSString *oneStr = allMenuOne.Parentpath;
            BOOL isOk = [oneStr hasPrefix:paTabStr]&&oneStr.length >paTabStr.length;
            if (0 == i&& isOk) {
                [newArrone addObject:allMenuOne];
            }else if(1 == i&&isOk) {
                [newArrTwo addObject:allMenuOne];
            }else if(2 == i&&isOk ) {
                [newArrThree addObject:allMenuOne];
            }else if(3 == i&&isOk ) {
                [newArrFour addObject:allMenuOne];
            }
            
        }
    }
    //获取导航数组one
    WSOneMenuModel *home = [[WSOneMenuModel alloc] init];
    home.Classname = @"新闻";
    home.Classen = @"sy";
    home.Parentid = 1;
    home.Depth = 1;
    home.Id = 0;
    home.Parentpath = @"0.1.0";
    home.Sortid = 1;
    home.Referurl = @"/sy/";
    if (newArrone.count>0) {
        [newArrone insertObject:home atIndex:0];
    }
    
    //获取导航数组防止有一级分类二级分类没有 做容错处理
    switch (tabbarArr.count) {
        case 1://导航一个 只添加一个数组
        {
            [WSMenuInstance sharedWSMenuInstance].menuOneArr = newArrone;

        }
            break;
        case 2://导航两个考虑 没有二级分类的情况
        {
            [WSMenuInstance sharedWSMenuInstance].menuOneArr = newArrone;
            if(newArrTwo.count == 0){
                [tabbarArr removeObjectAtIndex:1];
            }else {
                [WSMenuInstance sharedWSMenuInstance].menuTwoArr = newArrTwo;
            }            
        }
            break;
        case 3://导航三个 考虑 二级下只有一个 有两个 有三个的情况
        {
            
            [WSMenuInstance sharedWSMenuInstance].menuOneArr = newArrone;
            if(newArrTwo.count == 0&&newArrThree.count>0){
                //加第一个
                [tabbarArr removeObjectAtIndex:1];
                [WSMenuInstance sharedWSMenuInstance].menuTwoArr = newArrThree;
            }else if(newArrTwo.count > 0&&newArrThree.count == 0){//加第二个 第三个tabbar 包含二级分类没有数据
                [tabbarArr removeObjectAtIndex:2];
                [WSMenuInstance sharedWSMenuInstance].menuTwoArr = newArrTwo;
            }else if(newArrTwo.count == 0&&newArrThree.count == 0){//第2 ,3个二级分类都没有数据
                //两个都没有 不添加
                [tabbarArr removeObjectAtIndex:1];
                [tabbarArr removeObjectAtIndex:1];
            }else {//两个都有
                [WSMenuInstance sharedWSMenuInstance].menuTwoArr = newArrTwo;
                [WSMenuInstance sharedWSMenuInstance].menuThreeArr = newArrThree;
            }
        }
            break;
        default:{
            [WSMenuInstance sharedWSMenuInstance].menuOneArr = newArrone;
        }
            break;
    }
    //处理后重新赋值
    [WSMenuInstance sharedWSMenuInstance].tabbarArr = tabbarArr;


}



- (void)adImage{
    [SXAdManager loadLatestAdImage];
    UIView *adView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _adView = adView;
    UIImageView *adBottomImg1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lauch_bottom"]];
    adBottomImg1.frame = CGRectMake(0, self.view.height - 135, self.view.width, 135);
    _adBottomImg1 = adBottomImg1;
    [self.view addSubview:adBottomImg1];
    if ([SXAdManager isShouldDisplayAd]) {
 

        UIImageView *adImg = [[UIImageView alloc]initWithImage:[SXAdManager getAdImage]];
        //添加网易新闻有态度的门户的图片
        UIImageView *adBottomImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lauch_bottom"]];
        adView.backgroundColor = [UIColor whiteColor];
        [adView addSubview:adBottomImg];
        [adView addSubview:adImg];
        adBottomImg.frame = CGRectMake(0, self.view.height - 135, self.view.width, 135);
        adImg.frame = CGRectMake(0, 0, self.view.width, self.view.height - 135);
        UIButton *btn = [[UIButton alloc] initWithFrame:adImg.bounds];
        [btn addTarget:self action:@selector(oneFingerTwoTaps:) forControlEvents:UIControlEventTouchUpInside];
        _btn = btn;
        adView.alpha = 0.99f;
        [self.view addSubview:adView];
        [self.view addSubview:btn];
        
        //添加跳过按钮
        LargeClickBtn *skipBtn = [[LargeClickBtn alloc] initWithFrame:CGRectMake(Main_Screen_Width-90, 20, 50, 30)];
        skipBtn.backgroundColor = [UIColor grayColor];
        [skipBtn setTitle:@"跳过" forState:UIControlStateNormal];
        [skipBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [QTCommonTools clipAllView:skipBtn Radius:skipBtn.height*0.5 borderWidth:0 borderColor:nil];
        _skipBtn = skipBtn;
        [self.view addSubview:skipBtn];
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


- (void)oneFingerTwoTaps:(UIButton*)btn{
    
//    [btn removeFromSuperview];
    [_btn removeFromSuperview];
    [self addImageFinish:YES time:0.2];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
            [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationAddTap object:nil];
        ECLog(@"抛出点击通知");
    });
}


- (void)skipBtnClicked{
    [self addImageFinish:YES time:0.2];
}

- (void)addImageFinish:(BOOL)finished time:(CGFloat)dalaytime{
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    [UIView animateWithDuration:dalaytime animations:^{
        _adView.alpha = 0.0f;
        _skipBtn.alpha = 0.0;
        _btn.alpha = 0.0;
    } completion:^(BOOL finished) {
        [_btn removeFromSuperview];
        [_skipBtn removeFromSuperview];
        [_adView removeFromSuperview];
    }];
}


- (void)loadViewControllers:(BOOL)success{
    
    UIStoryboard *sb1 = [UIStoryboard storyboardWithName:@"News" bundle:nil];
    UIViewController *vc1 = [sb1 instantiateInitialViewController];
    UIStoryboard *sb2 = [UIStoryboard storyboardWithName:@"News" bundle:nil];
    UIViewController *vc2 = [sb1 instantiateInitialViewController];
    UIStoryboard *sb3 = [UIStoryboard storyboardWithName:@"News" bundle:nil];
    UIViewController *vc3 = [sb1 instantiateInitialViewController];
    
    UIStoryboard *sb4 = [UIStoryboard storyboardWithName:@"Topic" bundle:nil];
    UIViewController *vc4 = [sb4 instantiateInitialViewController];

    UIStoryboard *sb5 = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    UIViewController *vc5 = [sb5 instantiateInitialViewController];
    
    NSMutableArray *tabArr = [NSMutableArray array];
    [tabArr addObject:vc1];
    if ([self isShowZt]) {
        [tabArr addObject:vc4];
    }
    if ([WSMenuInstance sharedWSMenuInstance].menuTwoArr.count>0) {
        [tabArr addObject:vc2];
    }
    if ([WSMenuInstance sharedWSMenuInstance].menuThreeArr.count>0) {
        [tabArr addObject:vc3];
    }

    [tabArr addObject:vc5];
    if(success){//新闻+专题+...+我的
        self.viewControllers = tabArr;
    }else{//新闻+专题+我的
       self.viewControllers = @[vc1, vc5];
    }
}

+ (BOOL)isShowZt{
    return  [[[self alloc] init] isShowZt];
}

- (BOOL)isShowZt{
//    return YES;
    for (WSOneMenuModel*model in  [WSMenuInstance sharedWSMenuInstance].allMenuArr) {
        if (model.Parentid == -2) {
            if (model.Isad == 0) {
                return YES;
            }
            return NO;
        }
    }
    return NO;
}

- (void)loadTabBarItems:(BOOL)success{
    
    WSTabBarItem *item1 = [WSTabBarItem tabBarItemWithTitle:@"新闻" itemImage:[UIImage imageNamed:@"tabbar_icon_news_normal"] selectedImage:[UIImage imageNamed:@"tabbar_icon_news_highlight"]];
    
    WSTabBarItem *item2 = [WSTabBarItem tabBarItemWithTitle:@"资讯" itemImage:[UIImage imageNamed:@"tabbar_icon_reader_normal"] selectedImage:[UIImage imageNamed:@"tabbar_icon_reader_highlight"]];
    
    WSTabBarItem *item3 = [WSTabBarItem tabBarItemWithTitle:@"专栏" itemImage:[UIImage imageNamed:@"tabbar_icon_media_normal"] selectedImage:[UIImage imageNamed:@"tabbar_icon_media_highlight"]];
    
    WSTabBarItem *item4 = [WSTabBarItem tabBarItemWithTitle:@"专题" itemImage:[UIImage imageNamed:@"tabbar_icon_bar_normal"] selectedImage:[UIImage imageNamed:@"tabbar_icon_bar_highlight"]];
    
    WSTabBarItem *item5 = [WSTabBarItem tabBarItemWithTitle:@"我的" itemImage:[UIImage imageNamed:@"tabbar_icon_me_normal"] selectedImage:[UIImage imageNamed:@"tabbar_icon_me_highlight"]];
    
    
    //固定添加
    NSMutableArray *itemArr = [NSMutableArray array];
    NSMutableArray *itemArrSuccess = [NSMutableArray array];
    
        [itemArrSuccess addObject:item1];//新闻
   
if ([self isShowZt]) {
    [itemArrSuccess addObject:item4];//话题
}
    NSMutableArray *itemArrNotSuccess = [NSMutableArray array];
    if ([WSMenuInstance sharedWSMenuInstance].menuTwoArr.count>0) {
        
        WSOneMenuModel *oneModel = [[WSMenuInstance sharedWSMenuInstance].tabbarArr objectAtIndex:1];
        item2.itemLbl.text = oneModel.Classname;
        [itemArrSuccess addObject:item2];//资讯
    }
    if ([WSMenuInstance sharedWSMenuInstance].menuThreeArr.count>0) {
        WSOneMenuModel *oneModel = [[WSMenuInstance sharedWSMenuInstance].tabbarArr objectAtIndex:2];
        item3.itemLbl.text = oneModel.Classname;
        [itemArrSuccess addObject:item3];//专栏
    }
    //固定添加我的
    
    if(success){
        [itemArrSuccess addObject:item5];
        [itemArr addObjectsFromArray:itemArrSuccess];
    }else{
        [itemArrNotSuccess addObject:item1];//新闻

        [itemArrNotSuccess addObject:item5];//我的
        [itemArr addObjectsFromArray:itemArrNotSuccess];
    }
    WSTabBar *tabBar = [WSTabBar tabBarWithItems:itemArr itemClick:^(NSInteger index) {
        self.selectedIndex = index;
    } ];
    tabBar.frame = self.tabBar.bounds;
    [self.tabBar addSubview:tabBar];
    
}


@end
