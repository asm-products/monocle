#import "MCLScreenRecorder.h"

@implementation MCLScreenRecorder
{
    CGDirectDisplayID displayID;
    AVCaptureMovieFileOutput *captureMovieFileOutput;
}

- (id)init
{
    self.captureSession = [AVCaptureSession new];

    if (![self.captureSession canSetSessionPreset:AVCaptureSessionPresetHigh]) {
        NSLog(@"Could not set session preset to 'AVCaptureSessionPresetHigh'");
        return nil;
    }

    [self.captureSession setSessionPreset:AVCaptureSessionPresetHigh];

    displayID = CGMainDisplayID();
    self.captureScreenInput = [[AVCaptureScreenInput alloc] initWithDisplayID:displayID];

    if (![self.captureSession canAddInput:self.captureScreenInput]) {
        NSLog(@"Could not add input 'AVCaptureScreenInput'");
        return nil;
    }

    [self.captureSession addInput:self.captureScreenInput];

    captureMovieFileOutput = [AVCaptureMovieFileOutput new];
    [captureMovieFileOutput setDelegate:self];

    if (![self.captureSession canAddOutput:captureMovieFileOutput]) {
        NSLog(@"Could not add output 'AVCaptureMovieFileOutput'");
        return nil;
    }

    [self.captureSession addOutput:captureMovieFileOutput];

    [self.captureSession startRunning];

    return self;
}

- (IBAction)startRecording:(id)sender
{
    NSLog(@"Starting recording");

    char *recordingPathBytes = tempnam([[@"~/Desktop/" stringByStandardizingPath] fileSystemRepresentation], "Monocle");
	NSString *recordingPath = [[NSString alloc] initWithBytesNoCopy:recordingPathBytes length:strlen(recordingPathBytes) encoding:NSUTF8StringEncoding freeWhenDone:YES];
    recordingPath = [recordingPath stringByAppendingPathExtension:@"mov"];
    NSURL *recordingURL = [NSURL fileURLWithPath:recordingPath];
    [captureMovieFileOutput startRecordingToOutputFileURL:recordingURL recordingDelegate:self];
}

- (IBAction)stopRecording:(id)sender
{
    NSLog(@"Stopping recording");
    [self.captureSession stopRunning];
}

#pragma mark AVCaptureFileOutputDelegate

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    return;
}

- (BOOL)captureOutputShouldProvideSampleAccurateRecordingStart:(AVCaptureOutput *)captureOutput
{
    return NO;
}

#pragma mark AVCaptureFileOutputRecordingDelegate

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    NSLog(@"Finished recording");
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didPauseRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections
{
    NSLog(@"Paused recording");
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didResumeRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections
{
    NSLog(@"Resumed recording");
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections
{
    NSLog(@"Started recording");
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput willFinishRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    NSLog(@"About to finish recording");
}

@end
