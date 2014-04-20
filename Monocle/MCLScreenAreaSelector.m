#import "MCLScreenAreaSelector.h"
#import "MCLScreenAreaSelectorView.h"

#define MCLShadyWindowLevel (NSDockWindowLevel + 1000)

@implementation MCLScreenAreaSelector

- (void)startSelectingScreenArea
{
    [self overlayScreens];
	[[NSCursor crosshairCursor] push];
}

- (void)overlayScreens
{
    self.windows = [NSMutableArray new];

	for (NSScreen* screen in [NSScreen screens])
    {
		NSRect frame = [screen frame];
		NSWindow *window = [[NSWindow alloc] initWithContentRect:frame styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
        [self.windows addObject:window];

        [window setBackgroundColor:[NSColor clearColor]];
        [window setOpaque:NO];
        [window setIgnoresMouseEvents:NO];

		MCLScreenAreaSelectorView* screenAreaSelectorView = [[MCLScreenAreaSelectorView alloc] initWithFrame:frame];
		[window setContentView:screenAreaSelectorView];

        [window setLevel:MCLShadyWindowLevel];
		[window makeKeyAndOrderFront:self];
	}
}

- (void)stopSelectingScreenArea
{
    
}

@end
