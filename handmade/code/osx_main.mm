// osx_main.mm
//
// The main entry point the Handmade Hero
//
// rcanbabaoglu@gmail.com

#include <stdio.h>
#import <AppKit/AppKit.h>

#define internal static
#define local_persist static
#define global_variable static

global_variable float globalRenderWidth = 1024;
global_variable float globalRenderHeight = 768;
global_variable bool running = true;
global_variable uint8_t *buffer;


@interface HandmadeMainWindowDelegate: NSObject<NSWindowDelegate>
@end

@implementation HandmadeMainWindowDelegate

- (void)windowWillClose:(NSNotification *)notification {
    running = false;
}

@end

int main(int argc, const char * argv[]) {
    
    HandmadeMainWindowDelegate *mainWindowDelegate = [[HandmadeMainWindowDelegate alloc] init];
    
    NSRect screenRect = [[NSScreen mainScreen] frame];
    
    NSRect windowRect = NSMakeRect((screenRect.size.width - globalRenderWidth) * 0.5,
                                   (screenRect.size.height - globalRenderHeight) * 0.5,
                                   globalRenderWidth,
                                   globalRenderHeight);
    
    NSWindow *window = [[NSWindow alloc] initWithContentRect: windowRect
                                                   styleMask: NSWindowStyleMaskTitled |
                                                            NSWindowStyleMaskClosable |
                                                            NSWindowStyleMaskMiniaturizable |
                                                            NSWindowStyleMaskResizable
                                                     backing: NSBackingStoreBuffered
                                                       defer: NO];
    
    [window setBackgroundColor: NSColor.blackColor];
    [window setTitle: @"Handmade Hero"];
    [window makeKeyAndOrderFront: nil];
    [window setDelegate: mainWindowDelegate];
    
    int bitmapWidth = window.contentView.bounds.size.width;
    int bitmapHeight = window.contentView.bounds.size.height;
    int bytesPerPixel = 4; // 8 bit red + 8 bit green + 8 bit blue + 8 bit alpha = 4 Bytes
    
    // the size of a row
    int pitch = bitmapWidth * bytesPerPixel;
    // Buffer size
    int bufferSize = pitch * bitmapHeight;
    
    buffer = (uint8_t *)malloc(bufferSize);
    
    while(running) {
        
        @autoreleasepool {
            NSBitmapImageRep *rep = [[[NSBitmapImageRep alloc]
                                        initWithBitmapDataPlanes: &buffer
                                        pixelsWide: bitmapWidth
                                        pixelsHigh: bitmapHeight
                                        bitsPerSample: 8
                                        samplesPerPixel: 4
                                        hasAlpha: YES
                                        isPlanar: NO
                                        colorSpaceName: NSDeviceRGBColorSpace
                                        bytesPerRow: pitch
                                        bitsPerPixel: bytesPerPixel * 8] autorelease];
            
            NSSize imageSize = NSMakeSize(bitmapWidth, bitmapHeight);
            NSImage *image = [[[NSImage alloc] initWithSize: imageSize] autorelease];
            [image addRepresentation: rep];
            window.contentView.layer.contents = image;
        }
        
        NSEvent* event;
        do {
            event = [NSApp nextEventMatchingMask: NSEventMaskAny
                                       untilDate: nil
                                          inMode: NSDefaultRunLoopMode
                                         dequeue: YES];
            switch ([event type]) {
                default:
                    [NSApp sendEvent: event];
            }
        } while (event != nil);
    }
    
    printf("Handmade Hero Finished Running");
}
