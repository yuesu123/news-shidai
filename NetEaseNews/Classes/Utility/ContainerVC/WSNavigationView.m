//
//  WSNavigationView.m
//  网易新闻
//
//  Created by WackoSix on 15/12/27.
//  Copyright © 2015年 WackoSix. All rights reserved.
//

#import "WSNavigationView.h"
#define kViewH 35
#define kItemW 70
#define kMargin 10

@interface WSNavigationView ()

@property (strong, nonatomic) NSMutableArray *btns;
@property (strong, nonatomic) NSMutableArray *views;

@property (weak, nonatomic) UIButton *selectedItem;

@property (copy, nonatomic) itemClick itemClickBlock;

@end

@implementation WSNavigationView



#pragma mark - event

//按钮被点击
- (void)itemClick:(UIButton *)sender {
    
    if ([sender isEqual:self.selectedItem]) return;
    
    self.selectedItem.selected = NO;
    sender.selected = YES;
   
    if (self.itemClickBlock) {
        
        self.itemClickBlock(sender.tag);
    }

    //更改字体大小
    [UIView animateWithDuration:0.5 animations:^{
        for (UIButton *btn  in _btns) {
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];

        }
        
//        sender.titleLabel.font = [UIFont systemFontOfSize:17];
//        self.selectedItem.titleLabel.font = [UIFont systemFontOfSize:13];
        [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        for(UIView *view in _views){
            if(view.tag == sender.tag){
                view.backgroundColor = RGBCOLOR(220, 46, 45);
            }else{
                view.backgroundColor = whiteColorMe;
            }
        }

    }];
    
    //判断位置
    CGFloat offsetX = sender.center.x - self.center.x;
    
    if (offsetX < 0){
        
        self.contentOffset = CGPointMake(0, 0);
        
    }else if (offsetX > (self.contentSize.width - self.bounds.size.width)){
        
        self.contentOffset = CGPointMake(self.contentSize.width - self.bounds.size.width, 0);
        
    }else{
        
        self.contentOffset = CGPointMake(offsetX, 0);
    }

    
    self.selectedItem = sender;
    
 
}

//获得点击的index
- (void)setSelectedItemIndex:(NSInteger)selectedItemIndex{
    
    _selectedItemIndex = selectedItemIndex;
    
    if (self.btns.count>0) {
        ECLog(@"有大分类,而没有子分类");
        UIButton *item = self.btns[selectedItemIndex];
        [self itemClick:item];
    }
    
    
}

//设置ContentOffset
- (void)setContentOffset:(CGPoint)contentOffset{
    
    [UIView animateWithDuration:0.25 animations:^{
        
        [super setContentOffset:contentOffset];
    }];
}


#pragma mark - init

+ (instancetype)navigationViewWithItems:(NSArray<NSString *> *)items itemClick:(itemClick)itemClick{
    
    WSNavigationView *nav = [[WSNavigationView alloc] init];
    
    nav.btns = [NSMutableArray arrayWithCapacity:items.count];
    nav.views = [NSMutableArray arrayWithCapacity:items.count];
    nav.itemClickBlock = itemClick;
    
    nav.items = items;
    ////禁用滚动到最顶部的属性
    nav.scrollsToTop = NO;

    return nav;
}

//布局设置frame
- (void)layoutSubviews{
    [super layoutSubviews];
    //计算按钮的宽度
    int btnW = Main_Screen_Width/(self.btns.count+1);
    if (btnW<kItemW) {
        btnW = kItemW;
    }
    
    if (!_isHome) {
        btnW = 0;
    }
    
    int itemW = (Main_Screen_Width- btnW)/self.btns.count;
    if (itemW<kItemW) {
        itemW = kItemW;
    }
    
    
    
    for (NSInteger i=0; i<self.btns.count; i++) {
        
        UIButton *item = self.btns[i];
        CGFloat itemX = kMargin + itemW * i;
        item.frame = CGRectMake(itemX, 0, itemW, kViewH-2);
        
        UIView *view = self.views[i];
//        CGFloat viewX = itemX;
        view.frame = CGRectMake(itemX, kViewH-2, itemW, 2);
        
    }
    
    
    self.contentSize = CGSizeMake(itemW * self.btns.count + kMargin * 2, kViewH);
}

- (void)setItems:(NSArray<NSString *> *)items{
    _items = items;
    //创建按钮
    for (NSInteger i=0; i<items.count; i++) {
        UIButton *item = [[UIButton alloc] init];
        [item setTitle:items[i] forState:UIControlStateNormal];
        [item setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        item.titleLabel.font = [UIFont systemFontOfSize:16];
        item.titleLabel.textAlignment = NSTextAlignmentCenter;
        [item addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        UIView *view = [[UIView alloc] init];
//        view.backgroundColor = [UIColor redColor];
        view.tag = i ;
        [self.btns addObject:item];
        item.tag = i;
        [self.views addObject:view];
        [self addSubview:item];
        [self addSubview:view];
    }
}

- (void)setFrame:(CGRect)frame{
    frame.size.height = kViewH;
    [super setFrame:frame];
}

- (instancetype)init{
    if (self = [super init]) {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
    }
    return self;
}




@end
