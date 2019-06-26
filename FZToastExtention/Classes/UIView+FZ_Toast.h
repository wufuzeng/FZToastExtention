//
//  UIView+FZ_Toast.h
//  FZOCProject
//
//  Created by 吴福增 on 2019/1/24.
//  Copyright © 2019 wufuzeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, FZViewToastType) {
    FZViewToastTypeCustom  = 0,
    FZViewToastTypeLoading = 1 << 0,
    FZViewToastTypeIcon    = 1 << 1,
    FZViewToastTypeTitle   = 1 << 2,
    FZViewToastTypeMessage = 1 << 3,
    FZViewToastTypeReload  = 1 << 4,
    FZViewToastTypeCancel  = 1 << 5,
    FZViewToastTypeAll     = FZViewToastTypeLoading | FZViewToastTypeIcon | FZViewToastTypeTitle | FZViewToastTypeMessage | FZViewToastTypeReload | FZViewToastTypeCancel
};

@interface UIView (FZ_Toast)

@property (nonatomic,strong,nullable) UIView *fz_toastView;


#pragma mark -- Message Info -------

- (void)fz_showIcon:(UIImage * _Nullable )Icon;
- (void)fz_showMsg:(NSString * _Nullable )msg;
- (void)fz_showWithIcon:(UIImage * _Nullable )icon msg:(NSString * _Nullable )msg;
- (void)fz_showWithIcon:(UIImage * _Nullable )icon msg:(NSString * _Nullable )msg reload:(void(^ _Nullable)(void))reload cancel:(void(^ _Nullable)(void))cancel;
- (void)fz_showWithIcon:(UIImage * _Nullable )icon title:(NSString * _Nullable )title msg:(NSString * _Nullable )msg reload:(void(^ _Nullable)(void))reload cancel:(void(^ _Nullable)(void))cancel;

#pragma mark -- Loading Info -------

-(void)fz_showLoading;
-(void)fz_showLoadingWithMsg:(NSString * _Nullable)msg;
-(void)fz_showLoadingWithMsg:(NSString * _Nullable)msg cancel:(void(^ _Nullable)(void))cancelAction;
-(void)fz_showLoadingWithMsg:(NSString * _Nullable)msg reload:(void(^ _Nullable)(void))reloadAction cancel:(void(^ _Nullable)(void))cancelAction;

#pragma mark -- Custom Info -------

-(void)fz_showCustomView:(UIView * _Nullable)customView;


#pragma mark -- Common Func ----


- (void)fz_showWithType:(FZViewToastType)type icon:(UIImage  * _Nullable )icon title:(NSString  * _Nullable )title msg:(NSString  * _Nullable )msg reload:(void(^ _Nullable)(void))reload cancel:(void(^ _Nullable)(void))cancel;



#pragma mark -- Dismiss Func ----

- (void)fz_dismiss;


@end

NS_ASSUME_NONNULL_END
