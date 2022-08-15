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
    
    [window setBackgroundColor: NSColor.redColor];
    [window setTitle: @"Handmade Hero"];
    [window makeKeyAndOrderFront: nil];
    [window setDelegate: mainWindowDelegate];
    
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
