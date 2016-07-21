//
//  ServiceExampleViewController.h
//  ZhuRenWong
//
//  Created by Colin on 16/2/23.
//  Copyright © 2016年 qitian. All rights reserved.
//

#import "BaseViewController2.h"
typedef enum
{
    zeroArt = 0,
    TypeKindAdd = 1 ,
}TypeKind;


typedef void (^UploadImage)();

//typedef void (^WBHttpToolSucess)(NSDictionary * json);
//typedef void (^WBHttpToolFailur)(NSError *error);

@interface ServiceExampleViewController : BaseViewController2
@property (nonatomic, copy) NSString  *urlStr;
@property (nonatomic, copy) NSString  *titleStr;

@property (nonatomic, assign) TypeKind type;
@property (nonatomic, copy  ) UploadImage uploadImage;
- (void)uploadImage:(UploadImage)uploadImage;

@end
