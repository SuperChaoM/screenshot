//
//  ScreenUtil.m
//  LUAScriptElf
//
//  Created by LuoBin on 14-10-9.
//
//

#import "ScreenUtil.h"
#import <UIKit/UIKit.h>
#import <mach/mach.h>
#include <sys/time.h>
#include <dlfcn.h>






#include "IOMobileFramebuffer.h"
#import "IOKitLib.h"
#import "IOSurface.h"
#import <QuartzCore/QuartzCore.h>
#import "CoreSurface.h"
#include "IOSurfaceAccelerator.h"


//void CARenderServerRenderDisplay(kern_return_t a, CFStringRef b, IOSurfaceRef surface, int x, int y);
//
//static IOSurfaceRef surface;


@implementation ScreenUtil
static int i = 0;
-(void)start
{
    i++;
    NSLog(@"Daemon test %d",i);
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(screenshot) userInfo:nil repeats:YES];
        [timer fire];
}

//+(IOSurfaceRef) createScreenSurface
//{
//    CGSize screenSize = [UIScreen mainScreen].bounds.size;
//    float scale = [UIScreen mainScreen].scale;
//
//    NSInteger width, height;
//    // setup the width and height of the framebuffer for the device
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
//        // iPhone frame buffer is Portrait
//        width = screenSize.width * scale;
//        height = screenSize.height * scale;
//    } else {
//        // iPad frame buffer is Landscape
//        width = screenSize.height * scale;
//        height = screenSize.width * scale;
//    }
//
//
//    // Pixel format for Alpha Red Green Blue
//    unsigned pixelFormat = 0x42475241;//'ARGB';
//
//    // 4 Bytes per pixel
//    int bytesPerElement = 4;
//
//    // Bytes per row
//    int bytesPerRow = (bytesPerElement * width);
//
//    // Properties include: SurfaceIsGlobal, BytesPerElement, BytesPerRow, SurfaceWidth, SurfaceHeight, PixelFormat, SurfaceAllocSize (space for the entire surface)
//    NSDictionary *properties = [NSDictionary dictionaryWithObjectsAndKeys:
//                                [NSNumber numberWithBool:YES], kIOSurfaceIsGlobal,
//                                [NSNumber numberWithInt:bytesPerElement], kIOSurfaceBytesPerElement,
//                                [NSNumber numberWithInt:bytesPerRow], kIOSurfaceBytesPerRow,
//                                [NSNumber numberWithInt:width], kIOSurfaceWidth,
//                                [NSNumber numberWithInt:height], kIOSurfaceHeight,
//                                [NSNumber numberWithUnsignedInt:pixelFormat], kIOSurfacePixelFormat,
//                                [NSNumber numberWithInt:bytesPerRow * height], kIOSurfaceAllocSize,
//                                nil];
//
//    // This is the current surface
//    return IOSurfaceCreate((__bridge CFDictionaryRef)properties);
//
//}
//
//+ (void) getColorAtLocation:(CGPoint)point color:(TKColor *)color {
//    CGSize screenSize = [UIScreen mainScreen].bounds.size;
//    float scale = [UIScreen mainScreen].scale;
//
//    NSInteger width, height;
//    // setup the width and height of the framebuffer for the device
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
//        // iPhone frame buffer is Portrait
//        width = screenSize.width * scale;
//        height = screenSize.height * scale;
//    } else {
//        // iPad frame buffer is Landscape
//        width = screenSize.height * scale;
//        height = screenSize.width * scale;
//    }
//
//    NSInteger bytesPerElement = 4;
//    NSInteger bytesPerRow = bytesPerElement * width;
//
//    if (!surface) {
//        surface = [self createScreenSurface];
//        NSLog(@"开始一次");
//    }
//    void *handle = dlopen(0, 9);
//    *(void**)(&CARenderServerRenderDisplay) = dlsym(handle,"CARenderServerRenderDisplay");
//
//    IOSurfaceLock(surface, 1, nil);
//    CARenderServerRenderDisplay(0, CFSTR("LCD"), surface, 0, 0);
//    // Make a raw memory copy of the surface
//    unsigned char *data = IOSurfaceGetBaseAddress(surface);
//    NSLog(@"2016 data = %s",data);
//
//    IOSurfaceUnlock(surface, 0, 0);
//
//    int totalBytes = bytesPerRow * height;
//
//    if (data != NULL) {
//        //offset locates the pixel in the data from x,y.
//        //4 for 4 bytes of data per pixel, w is width of one row of data.
//        int offset = 4*((width*round(point.y))+round(point.x));
//
//        if (offset < totalBytes) {
//            unsigned char blue =  data[offset];
//            unsigned char green = data[offset+1];
//            unsigned char red = data[offset+2];
//            NSLog(@"color = %d,%d,%d",blue,green,red);
//            if (color) {
//                color->red = red;
//                color->green = green;
//                color->blue = blue;
//            }
//        }
//    }
//}
//
//+ (CGPoint)findColor:(TKColor)color {
//    return [self findColor:color fuzzyOffset:0];
//}
//
//+ (CGPoint)findColor:(TKColor)color fuzzyOffset:(CGFloat)fuzzyOffset {
//    CGSize screenSize = [UIScreen mainScreen].bounds.size;
//    float scale = [UIScreen mainScreen].scale;
//
//    NSInteger width, height;
//    // setup the width and height of the framebuffer for the device
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
//        // iPhone frame buffer is Portrait
//        width = screenSize.width * scale;
//        height = screenSize.height * scale;
//    } else {
//        // iPad frame buffer is Landscape
//        width = screenSize.height * scale;
//        height = screenSize.width * scale;
//    }
//
////    NSInteger bytesPerElement = 4;
////    NSInteger bytesPerRow = bytesPerElement * width;
//
//    if (!surface) {
//        surface = [self createScreenSurface];
//    }
//    CARenderServerRenderDisplay(0, CFSTR("LCD"), surface, 0, 0);
//
//    // Make a raw memory copy of the surface
//    unsigned char *data = IOSurfaceGetBaseAddress(surface);
////    int totalBytes = bytesPerRow * height;
//
//    if (data != NULL) {
//        for (int i = 0; i < width; i++) {
//            for (int j = 0; j < height; j++) {
//                int offset = 4*((width*round(j))+round(i));
//                unsigned char blue =  data[offset];
//                unsigned char green = data[offset+1];
//                unsigned char red = data[offset+2];
//
//                if (round(fabs(red - color.red)) <= ceil(fuzzyOffset)
//                    &&round(fabs(green - color.green)) <= ceil(fuzzyOffset)
//                    &&round(fabs(blue - color.blue)) <= ceil(fuzzyOffset)) {
//                    return CGPointMake(i, j);
//                }
//            }
//        }
//    }
//    return CGPointMake(NSNotFound, NSNotFound);
//}
//
//+ (CGPoint)findColor:(TKColor)color inRegion:(CGRect)region accuracy:(CGFloat)accuracy {
//    CGSize screenSize = [UIScreen mainScreen].bounds.size;
//    CGFloat scale = [UIScreen mainScreen].scale;
//
//
//    NSInteger width, height;
//    // setup the width and height of the framebuffer for the device
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
//        // iPhone frame buffer is Portrait
//        width = screenSize.width * scale;
//        height = screenSize.height * scale;
//    } else {
//        // iPad frame buffer is Landscape
//        width = screenSize.height * scale;
//        height = screenSize.width * scale;
//    }
//
//    region = CGRectIntersection(CGRectMake(0, 0, width, height), region);
//    if (CGRectIsNull(region)) {
//        return CGPointMake(NSNotFound, NSNotFound);
//    }
//
//    //    NSInteger bytesPerElement = 4;
//    //    NSInteger bytesPerRow = bytesPerElement * width;
//
//    if (!surface) {
//        surface = [self createScreenSurface];
//    }
//    CARenderServerRenderDisplay(0, CFSTR("LCD"), surface, 0, 0);
//
//    // Make a raw memory copy of the surface
//    unsigned char *data = IOSurfaceGetBaseAddress(surface);
//    //    int totalBytes = bytesPerRow * height;
//
//    if (accuracy < 0 || accuracy > 100) {
//        accuracy = 100;
//    }
//    accuracy = 100 - accuracy;
//
//    double redAccuracy = 1.0*color.red*accuracy/100;
//    double greenAccuracy = 1.0*color.green*accuracy/100;
//    double blueAccuracy = 1.0*color.blue*accuracy/100;
//
//    if (data != NULL) {
//        for (int i = region.origin.x; i <= CGRectGetMaxX(region); i++) {
//            for (int j = region.origin.y; j < CGRectGetMaxY(region); j++) {
//                int offset = 4*((width*round(j))+round(i));
//                unsigned char blue =  data[offset];
//                unsigned char green = data[offset+1];
//                unsigned char red = data[offset+2];
//
//                if (round(fabs(red - color.red)) <= ceil(redAccuracy)
//                    &&round(fabs(green - color.green)) <= ceil(greenAccuracy)
//                    &&round(fabs(blue - color.blue)) <= ceil(blueAccuracy)) {
//                    return CGPointMake(i, j);
//                }
//            }
//        }
//    }
//    return CGPointMake(NSNotFound, NSNotFound);
//}
////

// 获取使用实例
+ (instancetype )sharedInstance
{
    static ScreenUtil *sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[super alloc] init];
    });
    
    return sharedInstance;
}




UIKIT_EXTERN CGImageRef UICreateCGImageFromIOSurface(IOSurfaceRef);

-(void)takeScreenshotAndSaveToPhotosAlbumOnce {
    
    IOSurfaceRef ioSurfaceRef = (__bridge IOSurfaceRef)([UIWindow performSelector:@selector(createScreenIOSurface)]);
    
    size_t width = IOSurfaceGetWidth(ioSurfaceRef);
    size_t height = IOSurfaceGetHeight(ioSurfaceRef);
    
    CGDataProviderRef provider =  CGDataProviderCreateWithData(NULL,  IOSurfaceGetBaseAddress(ioSurfaceRef), (width * height * 4), NULL);
    
    
    CGImageRef cgImage = CGImageCreate(width, height, 8,
                                       8*4, IOSurfaceGetBytesPerRow(ioSurfaceRef),
                                       CGColorSpaceCreateDeviceRGB(), kCGImageAlphaNoneSkipFirst |kCGBitmapByteOrder32Little, provider, NULL, YES, kCGRenderingIntentDefault);
    NSLog(@"cgImage = %@",cgImage);
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    NSData *imageViewData = UIImagePNGRepresentation(image);
    NSString *savedImagePath = [@"/private/var/mobile/Media/Slion" stringByAppendingPathComponent:@"rootRow.png"];
    [imageViewData writeToFile:savedImagePath atomically:YES];//保存照片到沙盒目录
}






- (UIImage *)screenshot{
    IOMobileFramebufferConnection connect;
    kern_return_t result;
    CoreSurfaceBufferRef screenSurface = NULL;
    io_service_t framebufferService = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("AppleH1CLCD"));
    if(!framebufferService)
        framebufferService = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("AppleM2CLCD"));
    if(!framebufferService)
        framebufferService = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("AppleCLCD"));
    
    result = IOMobileFramebufferOpen(framebufferService, mach_task_self(), 0, &connect);
    result = IOMobileFramebufferGetLayerDefaultSurface(connect, 0, &screenSurface);
    
    uint32_t aseed;
    IOSurfaceLock((IOSurfaceRef)screenSurface, 0x00000001, &aseed);
    size_t width = IOSurfaceGetWidth((IOSurfaceRef)screenSurface);
    IOSurfaceUnlock((IOSurfaceRef)screenSurface, kIOSurfaceLockReadOnly, &aseed);

    
    size_t height = IOSurfaceGetHeight((IOSurfaceRef)screenSurface);
    CFMutableDictionaryRef dict;
    size_t pitch = width*4, size = width*height*4;
    
    int bPE=4;
    
    char pixelFormat[4] = {'A','R','G','B'};
    dict = CFDictionaryCreateMutable(kCFAllocatorDefault, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CFDictionarySetValue(dict, kIOSurfaceIsGlobal, kCFBooleanTrue);
    CFDictionarySetValue(dict, kIOSurfaceBytesPerRow, CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &pitch));
    CFDictionarySetValue(dict, kIOSurfaceBytesPerElement, CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &bPE));
    CFDictionarySetValue(dict, kIOSurfaceWidth, CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &width));
    CFDictionarySetValue(dict, kIOSurfaceHeight, CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &height));
    CFDictionarySetValue(dict, kIOSurfacePixelFormat, CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, pixelFormat));
    CFDictionarySetValue(dict, kIOSurfaceAllocSize, CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &size));
    
    IOSurfaceRef destSurf = IOSurfaceCreate(dict);
    IOSurfaceAcceleratorRef outAcc;
    IOSurfaceAcceleratorCreate(NULL, 0, &outAcc);
    
    IOSurfaceLock((IOSurfaceRef)screenSurface, 0x00000001, &aseed);
    IOSurfaceAcceleratorTransferSurface(outAcc, (IOSurfaceRef)screenSurface, destSurf, dict, NULL);
    IOSurfaceUnlock((IOSurfaceRef)screenSurface, kIOSurfaceLockReadOnly, &aseed);
    CFRelease(outAcc);
    
    CGDataProviderRef provider =  CGDataProviderCreateWithData(NULL,  IOSurfaceGetBaseAddress(destSurf), (width * height * 4), NULL);
    
    CGImageRef cgImage = CGImageCreate(width, height, 8,
                                       8*4, IOSurfaceGetBytesPerRow(destSurf),
                                       CGColorSpaceCreateDeviceRGB(), kCGImageAlphaNoneSkipFirst |kCGBitmapByteOrder32Little, provider, NULL, YES, kCGRenderingIntentDefault);
    

    UIImage *image = [UIImage imageWithCGImage:cgImage];
    NSData *imageViewData = UIImagePNGRepresentation(image);
    NSString *savedImagePath = [@"/private/var/mobile/Media/Slion" stringByAppendingPathComponent:@"root0.png"];
    [imageViewData writeToFile:savedImagePath atomically:YES];//保存照片到沙盒目录
    return image;
}

- (UIImage *)XXscreenshot{
    IOMobileFramebufferConnection connect;
    kern_return_t result;
    CoreSurfaceBufferRef screenSurface = NULL;
    io_service_t framebufferService = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("AppleH1CLCD"));
    if(!framebufferService)
        framebufferService = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("AppleM2CLCD"));
    if(!framebufferService)
        framebufferService = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("AppleCLCD"));
    
    result = IOMobileFramebufferOpen(framebufferService, mach_task_self(), 0, &connect);
    result = IOMobileFramebufferGetLayerDefaultSurface(connect, 0, &screenSurface);
    
    uint32_t aseed;
    IOSurfaceLock((IOSurfaceRef)screenSurface, 0x00000001, &aseed);
    size_t width = IOSurfaceGetWidth((IOSurfaceRef)screenSurface);
    IOSurfaceUnlock((IOSurfaceRef)screenSurface, kIOSurfaceLockReadOnly, &aseed);

    
    size_t height = IOSurfaceGetHeight((IOSurfaceRef)screenSurface);
    CFMutableDictionaryRef dict;
    size_t pitch = width*4, size = width*height*4;
    
    int bPE=4;
    
    char pixelFormat[4] = {'A','R','G','B'};
    dict = CFDictionaryCreateMutable(kCFAllocatorDefault, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CFDictionarySetValue(dict, kIOSurfaceIsGlobal, kCFBooleanTrue);
    CFDictionarySetValue(dict, kIOSurfaceBytesPerRow, CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &pitch));
    CFDictionarySetValue(dict, kIOSurfaceBytesPerElement, CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &bPE));
    CFDictionarySetValue(dict, kIOSurfaceWidth, CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &width));
    CFDictionarySetValue(dict, kIOSurfaceHeight, CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &height));
    CFDictionarySetValue(dict, kIOSurfacePixelFormat, CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, pixelFormat));
    CFDictionarySetValue(dict, kIOSurfaceAllocSize, CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &size));
    
    IOSurfaceRef destSurf = IOSurfaceCreate(dict);
//    IOSurfaceAcceleratorRef outAcc;
//    IOSurfaceAcceleratorCreate(NULL, 0, &outAcc);
//
//    IOSurfaceLock((IOSurfaceRef)screenSurface, 0x00000001, &aseed);
//    IOSurfaceAcceleratorTransferSurface(outAcc, (IOSurfaceRef)screenSurface, destSurf, dict, NULL);
//    IOSurfaceUnlock((IOSurfaceRef)screenSurface, kIOSurfaceLockReadOnly, &aseed);
//    CFRelease(outAcc);
    
    CGDataProviderRef provider =  CGDataProviderCreateWithData(NULL,  IOSurfaceGetBaseAddress(destSurf), (width * height * 4), NULL);
    
    CGImageRef cgImage = CGImageCreate(width, height, 8,
                                       8*4, IOSurfaceGetBytesPerRow(destSurf),
                                       CGColorSpaceCreateDeviceRGB(), kCGImageAlphaNoneSkipFirst |kCGBitmapByteOrder32Little, provider, NULL, YES, kCGRenderingIntentDefault);
    
    
    NSLog(@"XXscreenshot1 screenSurface 存在%@",cgImage);

    UIImage *image = [UIImage imageWithCGImage:cgImage];
    NSData *imageViewData = UIImagePNGRepresentation(image);
    NSString *savedImagePath = [@"/private/var/mobile/Media/Slion" stringByAppendingPathComponent:@"rootXX.png"];
    [imageViewData writeToFile:savedImagePath atomically:YES];//保存照片到沙盒目录
    return image;
}


- (NSString *)getBmpSavePath:(NSString *)savePath
{
    NSString *path = nil;
    if (![[[savePath pathExtension] lowercaseString] isEqualToString:@"bmp"]) {
        path = [savePath stringByDeletingPathExtension];
        path = [path stringByAppendingPathExtension:@"bmp"];
    }
    return path;
}
- (IOSurfaceRef)getScreenSurface
{
    
    void *IOMobileFramebuffer = dlopen("/System/Library/PrivateFrameworks/IOMobileFramebuffer.framework/IOMobileFramebuffer", RTLD_LAZY);
    NSParameterAssert(IOMobileFramebuffer);
    
    IOSurfaceRef screenSurface = NULL;
    io_service_t framebufferService = NULL;
    IOMobileFramebufferConnection framebufferConnection = NULL;
    framebufferService = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("AppleH1CLCD"));
    if(!framebufferService)
        framebufferService = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("AppleM2CLCD"));
    if(!framebufferService)
        framebufferService = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("AppleCLCD"));
    if (framebufferService) {
        kern_return_t result;
        result = IOMobileFramebufferOpen(framebufferService, mach_task_self(), 0, &framebufferConnection);
        if (result == KERN_SUCCESS) {
            IOMobileFramebufferGetLayerDefaultSurface(framebufferConnection, 0, &screenSurface);
        }
    }
    return screenSurface;
}
- (void)screenshot0:(NSString *)savePath
{
    IOSurfaceRef screenSurface = [self getScreenSurface];
    if (screenSurface) {
        IOSurfaceLock(screenSurface, kIOSurfaceLockReadOnly, NULL);
        size_t width = IOSurfaceGetWidth(screenSurface);
        size_t height = IOSurfaceGetHeight(screenSurface);
        void *bytes = IOSurfaceGetBaseAddress(screenSurface);
        NSString *path = [self getBmpSavePath:savePath];
        bmp_write(bytes, width, height, [path UTF8String]);
        IOSurfaceUnlock(screenSurface, kIOSurfaceLockReadOnly, NULL);
    }
}
- (void)screenshot1:(NSString *)savePath
{
    IOSurfaceRef screenSurface = [self getScreenSurface];
    if (screenSurface) {
        NSLog(@"screenshot1 screenSurface 存在");
        IOSurfaceLock(screenSurface, kIOSurfaceLockReadOnly, NULL);
        size_t width = IOSurfaceGetWidth(screenSurface);
        size_t height = IOSurfaceGetHeight(screenSurface);
        size_t bytesPerElement = IOSurfaceGetBytesPerElement(screenSurface);
        OSType pixelFormat = IOSurfaceGetPixelFormat(screenSurface);

        size_t bytesPerRow = 4 * width;
        size_t allocSize = bytesPerRow * height;
        
        //============== Why shoud I do this step? Why can't I IOSurfaceGetBaseAddress directly from screenSurface like method screenshot0:???
        NSDictionary *properties = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithBool:YES], kIOSurfaceIsGlobal,
                                    [NSNumber numberWithUnsignedLong:bytesPerElement], kIOSurfaceBytesPerElement,
                                    [NSNumber numberWithUnsignedLong:bytesPerRow], kIOSurfaceBytesPerRow,
                                    [NSNumber numberWithUnsignedLong:width], kIOSurfaceWidth,
                                    [NSNumber numberWithUnsignedLong:height], kIOSurfaceHeight,
                                    [NSNumber numberWithUnsignedInt:pixelFormat], kIOSurfacePixelFormat,
                                    [NSNumber numberWithUnsignedLong:allocSize], kIOSurfaceAllocSize,
                                    nil];
        IOSurfaceRef destSurf = IOSurfaceCreate((__bridge CFDictionaryRef)(properties));
        
        
        IOSurfaceAcceleratorRef outAcc;
        IOSurfaceAcceleratorCreate(NULL, 0, &outAcc);
        IOSurfaceLock(screenSurface, kIOSurfaceLockReadOnly, NULL);
        IOSurfaceAcceleratorTransferSurface(outAcc, screenSurface, destSurf, (__bridge CFDictionaryRef)(properties), NULL);
        IOSurfaceUnlock(screenSurface, kIOSurfaceLockReadOnly, NULL);
        CFRelease(outAcc);
        //==============
        CGDataProviderRef provider =  CGDataProviderCreateWithData(NULL,  IOSurfaceGetBaseAddress(destSurf), (width * height * 4), NULL);
        
        CGImageRef cgImage = CGImageCreate(width, height, 8,
                                           8*4, IOSurfaceGetBytesPerRow(destSurf),
                                           CGColorSpaceCreateDeviceRGB(), kCGImageAlphaNoneSkipFirst |kCGBitmapByteOrder32Little, provider, NULL, YES, kCGRenderingIntentDefault);
        
        
        UIImage *image = [UIImage imageWithCGImage:cgImage];
        NSData *imageViewData = UIImagePNGRepresentation(image);
        [imageViewData writeToFile:savePath atomically:YES];//保存照片到沙盒目录

//        void *bytes = IOSurfaceGetBaseAddress(destSurf);
//        NSString *path = [self getBmpSavePath:savePath];
//        bmp_write(bytes, width, height, [path UTF8String]);
//        IOSurfaceUnlock(screenSurface, kIOSurfaceLockReadOnly, NULL);
    }else
    {
        NSLog(@"screenshot1 screenSurface 不存在");

    }
}
int bmp_write(const void *image, size_t xsize, size_t ysize, const char *filename)
{
    unsigned char header[54] = {
        0x42, 0x4d, 0, 0, 0, 0, 0, 0, 0, 0,
        54, 0, 0, 0, 40, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 32, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0
    };
    long file_size = (long)xsize * (long)ysize * 4 + 54;
    header[2] = (unsigned char)(file_size &0x000000ff);
    header[3] = (file_size >> 8) & 0x000000ff;
    header[4] = (file_size >> 16) & 0x000000ff;
    header[5] = (file_size >> 24) & 0x000000ff;
    long width = xsize;
    header[18] = width & 0x000000ff;
    header[19] = (width >> 8) &0x000000ff;
    header[20] = (width >> 16) &0x000000ff;
    header[21] = (width >> 24) &0x000000ff;
    long height = ysize;
    header[22] = height &0x000000ff;
    header[23] = (height >> 8) &0x000000ff;
    header[24] = (height >> 16) &0x000000ff;
    header[25] = (height >> 24) &0x000000ff;
    char fname_bmp[128];
    sprintf(fname_bmp, "%s", filename);
    FILE *fp;
    if (!(fp = fopen(fname_bmp, "wb")))
        return -1;
    fwrite(header, sizeof(unsigned char), 54, fp);
    fwrite(image, sizeof(unsigned char), (size_t)(long)xsize * ysize * 4, fp);
    fclose(fp);
    return 0;
}



@end
