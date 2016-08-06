//
//  WSAdModel.m
//  NetEaseNews
//
//  Created by  汪刚 on 16/6/18.
//  Copyright © 2016年 WackoSix. All rights reserved.
//

#import "WSAdModel.h"
#import "WSNewsAllModel.h"
static NSString *kremoveTag = @"yu&&**^^";

@implementation WSAdModel
+ (void)inserAdArr:(NSMutableArray*)adArr toArr:(NSMutableArray*)allArr path:(NSInteger)path{
    for (int i = 0 ; i <allArr.count; i++) {
        Newslist *model = [allArr objectAtIndex:i];
        if ([model isKindOfClass:[Newslist class]]) {
            if ([model.tag isEqualToString:kremoveTag]) {
                [allArr removeObjectAtIndex:i];
            }
        }
      
    }
    //每组插入广告
        for (int i = 0; i < adArr.count; i++) {
            WSAdModel *ad = [adArr objectAtIndex:i];
            if ([self getIndex:i]>=allArr.count) {
                return;
            }
            [allArr insertObject:[self convertAdtoNewlist:ad] atIndex:[self getIndex:i]];
        }
}

+ (NSInteger)getIndex:(NSInteger)i {
    return (i+1)*4+i;
}
//   "Showtype": ,  — 0为左图右标题样式 1 为直栏模式(通栏单图仅一张图片无文字) 2为三图模式 3 为通栏(单图+标题+时间)  这个定义确保无误
+ (Newslist*)convertAdtoNewlist:(WSAdModel*)adModel{
    Newslist *news = [[Newslist alloc] init];
    news.Id = adModel.Id;
    news.Title = adModel.Adtitle;
    news.Descriptions = adModel.Addes;
    news.Picsmall = adModel.Adfile;
    news.Newslink = adModel.Adlink;
    news.Edittime = adModel.Addtime;
    news.Showtype = 1;
    news.tag = kremoveTag;
    news.isAdd = YES;
    return news;
}




@end
