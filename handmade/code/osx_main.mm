// osx_main.mm
//
// The main entry point the Handmade Hero
//
// rcanbabaoglu@gmail.com

#include <stdio.h>
#import <AppKit/AppKit.h>

static float GlobalRenderingWidth = 1024;
static float GlobalRenderingHeight = 768;

static bool Running = true;

@interface HandmadeMainWindowDelegate: NSObject<NSWindowDelegate>
@end

@implementation HandmadeMainWindowDelegate

- (void)windowWillClose:(NSNotification *)notification {
    Running = false;
}

@end

int main(int argc, const char * argv[]) {
    
    HandmadeMainWindowDelegate *mainWindowDelegate = [[HandmadeMainWindowDelegate alloc] init];
    
    NSRect screenRect = [[NSScreen mainScreen] frame];
    
    NSRect windowRect = NSMakeRect((screenRect.size.width - GlobalRenderingWidth) * 0.5,
                                   (screenRect.size.height - GlobalRenderingHeight) * 0.5,
                                   GlobalRenderingWidth,
                                   GlobalRenderingHeight);
    
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
    
    while(Running) {
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
