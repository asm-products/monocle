#import "MCLScreenAreaSelector.h"
#import "MCLScreenAreaSelectorView.h"
#import "MCLRecordingWindowController.h"

#define MCLShadyWindowLevel (NSDockWindowLevel + 1000)

@implementation MCLScreenAreaSelector

- (void)startSelectingScreenArea
{
    [self showScreenOverlays];
	[[NSCursor crosshairCursor] push];
}

- (void)stopSelectingScreenArea
{
    if (NSEqualRects(self.selectionRect, NSZeroRect)) {
        NSLog(@"Selection Rect not set");
        return;
    }

    [self hideScreenOverlays];
	[[NSCursor arrowCursor] push];

    [self showRecordingWindowAroundSelection];
}

- (void)showScreenOverlays
{
    self.overlays = [NSMutableArray new];

	for (NSScreen* screen in [NSScreen screens])
    {
		NSRect frame = [screen frame];
		NSWindow *window = [[NSWindow alloc] initWithContentRect:frame styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
        [self.overlays addObject:window];

        [window setBackgroundColor:[NSColor clearColor]];
        [window setOpaque:NO];
        [window setIgnoresMouseEvents:NO];

		MCLScreenAreaSelectorView* screenAreaSelectorView = [[MCLScreenAreaSelectorView alloc] initWithFrame:frame];
        screenAreaSelectorView.screenAreaSelector = self;
		[window setContentView:screenAreaSelectorView];

        [window setLevel:MCLShadyWindowLevel];
		[window makeKeyAndOrderFront:self];
	}
}

- (void)hideScreenOverlays
{
    self.overlays = nil;
}

- (void)showRecordingWindowAroundSelection
{
    self.recordingWindowController = [[MCLRecordingWindowController alloc] initWithWindowNibName:@"MCLRecordingWindowController"];

    CGFloat menuBarHeight = [self.recordingWindowController.window.menu menuBarHeight];
    CGFloat padding = 5;
    CGFloat buttonHeight = 21;
    NSRect selectionWindowRect = NSMakeRect(self.selectionRect.origin.x - (padding),
                                            self.selectionRect.origin.y - (padding + buttonHeight + padding),
                                            padding + self.selectionRect.size.width + padding,
                                            menuBarHeight + padding + self.selectionRect.size.height + padding + buttonHeight + padding);

    [self.recordingWindowController.window setFrame:selectionWindowRect display:YES];
    [self.recordingWindowController.window setOpaque:NO];
    [self.recordingWindowController.window display];
}

@end
