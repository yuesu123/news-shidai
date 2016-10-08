//
//  WSNewsController.m
//  网易新闻
//
//  Created by WackoSix on 15/12/27.
//  Copyright © 2015年 WackoSix. All rights reserved.
//

#import "WSNewsContainerController.h"
#import "UIView+Frame.h"
#import "WSContainerController.h"
#import "WSNewsController.h"
#import "WSChannel.h"
#import "WSSearchController.h"
#import "WSDayNewsController.h"
#import "WSMenuInstance.h"
#import "WSOneMenuModel.h"
#import "NSMutableArray+safeMedthod.h"
#import "NSArray+safeMethod.h"

@interface WSNewsContainerController ()

@property (strong, nonatomic) NSArray *news;

@end

@implementation WSNewsContainerController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    NSMutableArray *vcs = [NSMutableArray arrayWithCapacity:self.news.count];
    
    
    for (WSChannel *ch in self.news) {
        
        WSNewsController *newVC = [WSNewsController newsController];
        newVC.channelUrl = ch.channelURL;
        newVC.title = ch.tname;
        newVC.channelID = ch.tid;
        [vcs addObject:newVC];
    }
    
    WSContainerController *containVC = [WSContainerController containerControllerWithSubControlers:vcs parentController:self];
    containVC.navigationBarBackgrourdColor = [UIColor whiteColor];
    
    [self loadInterface];
}


- (void)loadInterface {
    
    //titleView
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:nil]];
//    self.navigationItem.titleView = imageView;
    NSInteger index =  self.tabBarController.selectedIndex;
    if (index>0) {
        NSMutableArray *tabbarArr = [WSMenuInstance sharedWSMenuInstance].tabbarArr;
        
        WSOneMenuModel *model = [tabbarArr objectAtIndexSafe:index-1];
      self.navigationItem.title = model.Classname;
        
    }   
    
//    self.navigationItem.title = @"11";

    if (self.tabBarController.selectedIndex == 0) {
        self.navigationItem.title = @"";

        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
        [button setImage:[UIImage imageNamed:@"nav_home_logo"] forState:UIControlStateNormal];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        button.userInteractionEnabled = NO;
        UIBarButtonItem*leftItem = [[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = leftItem;
        
        UIButton *buttonright = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 135, 26)];
        [buttonright setBackgroundImage:[UIImage imageNamed:@"nav_home_search"] forState:UIControlStateNormal];
        [buttonright addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:buttonright];
        self.navigationItem.rightBarButtonItem = rightItem;
        
        
    }
   
    
    
}

- (void)leftItemClick {
    //不允许点击
    return;
    WSDayNewsController *dayNews = [WSDayNewsController dayNews];
    //hideBottomBar

    [self.navigationController pushViewController:dayNews animated:YES];
}

- (void)rightItemClick {
    
    WSSearchController *searchVC = [[WSSearchController alloc] init];
    //hideBottomBar

    [self.navigationController pushViewController:searchVC animated:YES];
    
}

#pragma mark - lazy loading

//此处逻辑需要重新写
- (NSArray *)news{
    
        NSMutableArray *arrM = [NSMutableArray array];
        NSMutableArray* arrModelAll;
        if (self.tabBarController.selectedIndex == 0&&([WSMenuInstance  sharedWSMenuInstance].tabbarArr.count == 1)) {
            arrModelAll  = [WSMenuInstance sharedWSMenuInstance].menuOneArr;
        }else if(self.tabBarController.selectedIndex == 0&&([WSMenuInstance  sharedWSMenuInstance].tabbarArr.count == 2)) {
            arrModelAll  = [WSMenuInstance sharedWSMenuInstance].menuOneArr;
        }else if(self.tabBarController.selectedIndex == 0&&([WSMenuInstance  sharedWSMenuInstance].tabbarArr.count == 3)) {
            arrModelAll  = [WSMenuInstance sharedWSMenuInstance].menuOneArr;
      //  ---- 下面的是显示专题的
        }else if([self isShowZt]&&self.tabBarController.selectedIndex == 1&&([WSMenuInstance  sharedWSMenuInstance].tabbarArr.count > 1)) {
            arrModelAll  = [WSMenuInstance sharedWSMenuInstance].menuTwoArr;
            
        }else if([self isShowZt]&&self.tabBarController.selectedIndex == 2&&([WSMenuInstance  sharedWSMenuInstance].tabbarArr.count == 2)) {
            arrModelAll  = [WSMenuInstance sharedWSMenuInstance].menuTwoArr;
        }else if([self isShowZt]&&self.tabBarController.selectedIndex == 2&&([WSMenuInstance  sharedWSMenuInstance].tabbarArr.count == 3)) {//分专题隐藏和不隐藏
            arrModelAll  = [WSMenuInstance sharedWSMenuInstance].menuTwoArr;
        }else if([self isShowZt]&&self.tabBarController.selectedIndex == 3&&([WSMenuInstance  sharedWSMenuInstance].tabbarArr.count == 3)) {
            arrModelAll  = [WSMenuInstance sharedWSMenuInstance].menuThreeArr;
        //---下面是不显示专题
        }else if((![self isShowZt])&&self.tabBarController.selectedIndex == 1&&([WSMenuInstance  sharedWSMenuInstance].tabbarArr.count > 1)) {
            arrModelAll  = [WSMenuInstance sharedWSMenuInstance].menuTwoArr;
            
        }else if((![self isShowZt])&&self.tabBarController.selectedIndex == 2&&([WSMenuInstance  sharedWSMenuInstance].tabbarArr.count == 2)) {
            arrModelAll  = [WSMenuInstance sharedWSMenuInstance].menuThreeArr;
        }else if((![self isShowZt])&&self.tabBarController.selectedIndex == 2&&([WSMenuInstance  sharedWSMenuInstance].tabbarArr.count == 3)) {//分专题隐藏和不隐藏
            arrModelAll  = [WSMenuInstance sharedWSMenuInstance].menuThreeArr;
        }else if((![self isShowZt])&&self.tabBarController.selectedIndex == 3&&([WSMenuInstance  sharedWSMenuInstance].tabbarArr.count == 3)) {
            arrModelAll  = [WSMenuInstance sharedWSMenuInstance].menuFourArr;
        }


        
        for (WSOneMenuModel *model in arrModelAll) {
            /**频道的标识*/
            WSChannel *ch = [[WSChannel alloc] init];
            ch.tid = [NSString convertIntgerToString:model.Id];
            ch.tname= model.Classname;
            ch.channelURL = [NSString convertIntgerToString:model.Id];
            
            [arrM addObject:ch];
        }
        
        _news = arrM.copy;
        
    return _news;
}

- (BOOL)isShowZt{
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



@end
