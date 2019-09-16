//
//  ScreenUtil.h
//  LUAScriptElf
//
//  Created by LuoBin on 14-10-9.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



typedef struct {
    unsigned char red;
    unsigned char green;
    unsigned char blue;
} TKColor;

@interface ScreenUtil : NSObject
//
+ (void) getColorAtLocation:(CGPoint)point color:(TKColor *)color;

+ (CGPoint)findColor:(TKColor)color;

+ (CGPoint)findColor:(TKColor)color fuzzyOffset:(CGFloat)fuzzyOffset;

+ (CGPoint)findColor:(TKColor)color inRegion:(CGRect)region accuracy:(CGFloat)accuracy;

// 获取使用实例
+ (instancetype )sharedInstance;

-(void)start;


-(void)takeScreenshotAndSaveToPhotosAlbumOnce;

-(void)KeepScreen;

-(void)getColorAtLocation;

- (UIImage *)screenshot;

- (UIImage *)XXscreenshot;

- (void)screenshot0:(NSString *)savePath;

- (void)screenshot1:(NSString *)savePath;

@end
