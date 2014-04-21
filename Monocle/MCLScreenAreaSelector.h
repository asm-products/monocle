#import <Foundation/Foundation.h>

#import "MCLRecordingWindowController.h"

@interface MCLScreenAreaSelector : NSObject

@property (strong) NSMutableArray *overlays;
@property (strong) MCLRecordingWindowController *recordingWindowController;
@property NSRect selectionRect;

- (void)startSelectingScreenArea;
- (void)stopSelectingScreenArea;

@end
