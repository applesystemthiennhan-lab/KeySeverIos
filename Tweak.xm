#import "AuthSystem.h"
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>

void RenderMainUI();

%hook MTKView
- (void)drawRect:(CGRect)rect {
    %orig;
    RenderMainUI();
}
%end

%ctor {
    NSLog(@"Key System Loaded!");
}
