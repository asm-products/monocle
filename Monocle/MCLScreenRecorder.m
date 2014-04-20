#import "MCLScreenRecorder.h"
#import "MCLCaptureAnimatedGifOutput.h"

@implementation MCLScreenRecorder

- (id)init
{
    self.captureSession = [self createCaptureSession];
    self.captureInput = [self createCaptureInput];
    self.captureOutput = [self createCaptureOutput];

    if (![self.captureSession canAddInput:self.captureInput]) {
        NSLog(@"Could not add AVCaptureInput to AVCaptureSession");
        return nil;
    }

    [self.captureSession addInput:self.captureInput];

    if (![self.captureSession canAddOutput:self.captureOutput]) {
        NSLog(@"Could not add AVCaptureOutput to AVCaptureSession");
        return nil;
    }

    [self.captureSession addOutput:self.captureOutput];

    return self;
}

- (AVCaptureSession *)createCaptureSession
{
    AVCaptureSession *captureSession = [AVCaptureSession new];

    if (![captureSession canSetSessionPreset:AVCaptureSessionPresetHigh]) {
        NSLog(@"Could not set session preset to 'AVCaptureSessionPresetHigh'");
        return nil;
    }

    [captureSession setSessionPreset:AVCaptureSessionPresetHigh];

    return captureSession;
}

- (AVCaptureScreenInput *)createCaptureInput
{
    AVCaptureScreenInput *captureInput = [[AVCaptureScreenInput alloc] initWithDisplayID:CGMainDisplayID()];

    return captureInput;
}

- (MCLCaptureAnimatedGifOutput *)createCaptureOutput
{
    NSURL *destinationURL = [NSURL fileURLWithPath:@"/Users/vanstee/Desktop/screen.gif"];
    MCLCaptureAnimatedGifOutput *captureOutput = [[MCLCaptureAnimatedGifOutput alloc] initWithDestinationURL:destinationURL];

    return captureOutput;
}

- (void)startRecording
{
    NSLog(@"Starting recording");
    [self.captureSession startRunning];
}

- (void)stopRecording
{
    NSLog(@"Stopping recording");
    [self.captureSession stopRunning];
    [self.captureOutput compileFramesIntoImageDestinationAsync];
}


#pragma mark AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didDropSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    NSLog(@"Dropped frame!");
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    [self.captureOutput addSampleBufferAsNextFrame:sampleBuffer];
}

@end
