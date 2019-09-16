//
//  main.c
//  SlionDaemon
//
//  Created by SuperChao on 2019/9/10.
//  Copyright (c) 2019年 ___ORGANIZATIONNAME___. All rights reserved.
//
#include <unistd.h>
#include <stdio.h>
#include <UIKit/UIKit.h>

#include "IOSurfaceAccelerator.h"
#include "IOMobileFramebuffer.h"
#import "IOKitLib.h"
#import "IOSurface.h"
#import <QuartzCore/QuartzCore.h>
#import "CoreSurface.h"
#include "IOSurfaceAccelerator.h"






UIImage * screenshot(void);
UIImage * screenshot(){
    
    IOMobileFramebufferConnection connect;
    
    kern_return_t result;
    
    CoreSurfaceBufferRef screenSurface = NULL;
    
    io_service_t framebufferService = IOServiceGetMatchingService(kIOMasterPortDefault,IOServiceMatching("AppleH1CLCD"));
    
    if(!framebufferService)
        
        framebufferService = IOServiceGetMatchingService(kIOMasterPortDefault,IOServiceMatching("AppleM2CLCD"));
    
    if(!framebufferService)
        
        framebufferService = IOServiceGetMatchingService(kIOMasterPortDefault,IOServiceMatching("AppleCLCD"));
    
    result = IOMobileFramebufferOpen(framebufferService, mach_task_self(), 0, &connect);
    
    result = IOMobileFramebufferGetLayerDefaultSurface(connect, 0, &screenSurface);
    
    uint32_t aseed;
    
    IOSurfaceLock((IOSurfaceRef)screenSurface, 0x00000001, &aseed);
    
    size_t width = IOSurfaceGetWidth((IOSurfaceRef)screenSurface);
    
    size_t height = IOSurfaceGetHeight((IOSurfaceRef)screenSurface);
    
    CFMutableDictionaryRef dict;
    
    size_t pitch = width*4, size = width*height*4;
    
    int bPE=4;
    
    char pixelFormat[4] = {'A','R','G','B'};
    
    dict = CFDictionaryCreateMutable(kCFAllocatorDefault, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    
    CFDictionarySetValue(dict, kIOSurfaceIsGlobal, kCFBooleanTrue);
    
    CFDictionarySetValue(dict, kIOSurfaceBytesPerRow, CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt32Type, &pitch));
    
    CFDictionarySetValue(dict, kIOSurfaceBytesPerElement, CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt32Type, &bPE));
    
    CFDictionarySetValue(dict, kIOSurfaceWidth, CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt32Type, &width));
    
    CFDictionarySetValue(dict, kIOSurfaceHeight, CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt32Type, &height));
    
    CFDictionarySetValue(dict, kIOSurfacePixelFormat, CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt32Type, pixelFormat));
    
    CFDictionarySetValue(dict, kIOSurfaceAllocSize, CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt32Type, &size));
    
    IOSurfaceRef destSurf = IOSurfaceCreate(dict);

    IOSurfaceAcceleratorRef outAcc;
    
    IOSurfaceAcceleratorCreate(NULL, 0, &outAcc);
    int aseed1 = IOSurfaceGetSeed((IOSurfaceRef)screenSurface);

    IOSurfaceAcceleratorTransferSurface(outAcc, (IOSurfaceRef)screenSurface, destSurf, dict,NULL);
    int aseed2 = IOSurfaceGetSeed((IOSurfaceRef)screenSurface);

    IOSurfaceUnlock((IOSurfaceRef)screenSurface, kIOSurfaceLockReadOnly, &aseed);
    
    if(aseed1 != aseed2){
        NSLog(@"aseed1 != aseed2");
    }else
    {
        NSLog(@"aseed1 == aseed2");
    }
    CFRelease(outAcc);
    
    CGDataProviderRef provider =  CGDataProviderCreateWithData(NULL,  IOSurfaceGetBaseAddress(destSurf), (width * height *4), NULL);
    
    CGImageRef cgImage = CGImageCreate(width, height, 8,
                                       
                                       8*4, IOSurfaceGetBytesPerRow(destSurf),
                                       CGColorSpaceCreateDeviceRGB(), kCGImageAlphaNoneSkipFirst |kCGBitmapByteOrder32Little,provider,NULL, YES, kCGRenderingIntentDefault);
    
    
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    NSLog(@"image = %@",image);

    NSData *imageViewData = UIImagePNGRepresentation(image);
    NSString *savedImagePath = [@"/private/var/mobile/Media/Slion" stringByAppendingPathComponent:@"root0.png"];
    [imageViewData writeToFile:savedImagePath atomically:YES];//保存照片到沙盒目录

    return image;
    
}



OBJC_EXTERN UIImage *_UICreateScreenUIImage(void);
int main (int argc, const char * argv[])
{
    NSLog(@"开始: daemond is launched!");
    screenshot();
    sleep(10);
    return 0;
}

