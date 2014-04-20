#import <Cocoa/Cocoa.h>
#import <MASShortcutView.h>

#import "MCLScreenRecorder.h"
#import "MCLScreenAreaSelector.h"

@interface MCLAppDelegate : NSObject <NSApplicationDelegate>

@property (strong) MCLScreenRecorder *screenRecorder;
@property (strong) MCLScreenAreaSelector *screenAreaSelector;
@property (nonatomic, weak) IBOutlet MASShortcutView *shortcutView;

- (IBAction)startRecording:(id)sender;
- (IBAction)stopRecording:(id)sender;

@end
