//
//  FZToastExtentionBundle.h
//  FZToastExtention
//
//  Created by 吴福增 on 2019/7/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FZToastExtentionBundle : NSBundle

+ (UIImage *)fz_imageNamed:(NSString *)name;

+ (UIImage *)fz_imageNamed:(NSString *)name ofType:(nullable NSString *)type;

@end

NS_ASSUME_NONNULL_END
