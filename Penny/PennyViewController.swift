//
//  ViewController.swift
//  Penny
//
//  Created by Izzy Water on 11/30/14.
//  Copyright (c) 2014 Harmonic Processes. All rights reserved.
//

import UIKit
import AVFoundation

class PennyViewController: UIViewController, RosyWriterCapturePipelineDelegate {
    
    let captureSession = AVCaptureSession()

    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var AVButton: UIButton!
    var buttonArray : [UIButton]!
    
    var _addedObservers : Bool?
    var _recording : Bool?
    var _backgroundRecordingID : UIBackgroundTaskIdentifier?
    var _allowedToUseGPU : Bool?

    // If we find a device we'll store it here for later use
    var captureDevice : AVCaptureDevice?
    var previewLayer : AVCaptureVideoPreviewLayer?
    var previewView : OpenGLPixelBufferView?
    var capturePipeline : RosyWriterCapturePipeline?

    override func viewDidLoad() {
        buttonArray = [captureButton, AVButton]
        
        /*
        checkAVCaptureDevices();
        storeCaptureDevice();
        
        if captureDevice != nil {
            beginSession()
        }
        */
        
        capturePipeline = RosyWriterCapturePipeline()
        capturePipeline?.setDelegate(self, callbackQueue:dispatch_get_main_queue());
        
        // Keep track of changes to the device orientation so we can update the capture pipeline
        UIDevice.currentDevice().beginGeneratingDeviceOrientationNotifications()
        
        _addedObservers = true
        _recording = false
        
        // the willEnterForeground and didEnterBackground notifications are subsequently used to update _allowedToUseGPU
        _allowedToUseGPU = ( UIApplication.sharedApplication().applicationState != UIApplicationState.Background )
        self.capturePipeline?.renderingEnabled = _allowedToUseGPU!
        
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated:Bool){
        
        super.viewWillAppear(animated)
    
        capturePipeline?.startRunning()
    
        //Maybe replace labelTimer with note
        //labelTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target:self, selector:updateLabels, userInfo:nil, repeats:true)
    }
    
    override func viewDidDisappear(animated:Bool) {
        super.viewDidDisappear(animated)
    
        //[self.labelTimer invalidate];
        //self.labelTimer = nil;
    
        capturePipeline?.stopRunning()
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkAVCaptureDevices() {
        captureSession.sessionPreset = AVCaptureSessionPresetLow
        
        let devices = AVCaptureDevice.devices()
        println(devices)
    }
    
    func storeCaptureDevice(){
        // Do any additional setup after loading the view, typically from a nib.
        captureSession.sessionPreset = AVCaptureSessionPresetLow
        
        let devices = AVCaptureDevice.devices()
        
        // Loop through all the capture devices on this phone
        for device in devices {
            // Make sure this particular device supports video
            if (device.hasMediaType(AVMediaTypeVideo)) {
                // Finally check the position and confirm we've got the back camera
                if(device.position == AVCaptureDevicePosition.Back) {
                    captureDevice = device as? AVCaptureDevice
                }
            }
        }
    }
   
    /*
    func beginSession(){
        var err : NSError? = nil
        captureSession.addInput(AVCaptureDeviceInput(device: captureDevice, error: &err))
        println(captureDevice?.formats)
        
        if err != nil {
            println("error: \(err?.localizedDescription)")
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        print("previewLayer preTransform ")
        println(AVLayerVideoGravityResizeAspectFill)
        
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        //AVLayerVideoGravityResizeAspectFill = true
        
        
        let screenSize = UIScreen.mainScreen().bounds
        print("screenSize ")
        println(screenSize)
        
        self.view.layer.addSublayer(previewLayer)
        previewLayer?.frame = self.view.layer.frame
        
        captureSession.startRunning()
        //captureButton.setImage(UIImage(named: "CaptureButton"), forState:UIControlState.Normal)
        popButtons()
    }
    */
    

    
    func setupPreviewView(){
        // Set up GL view
        self.previewView = OpenGLPixelBufferView(frame:CGRectZero)
        self.previewView?.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
        var currentInterfaceOrientation = UIApplication.sharedApplication().statusBarOrientation
        var newOrientation = AVCaptureVideoOrientation(ui:currentInterfaceOrientation)
        //let orientation = UIApplication.sharedApplication().statusBarOrientation()
        self.previewView?.transform = self.capturePipeline!.transformFromVideoBufferOrientationToOrientation(newOrientation, withAutoMirroring:true) // Front camera preview should be mirrored
        self.view.insertSubview(previewView!, atIndex:0)
        var bounds = CGRect.zeroRect
        bounds.size = self.view.convertRect(self.view.bounds, toView:previewView).size
        self.previewView?.bounds = bounds
        self.previewView?.center = CGPointMake(self.view.bounds.size.width/2.0, self.view.bounds.size.height/2.0)
    }
    
    func startPreview() {
        self.view.layer.addSublayer(previewLayer)
        popButtons()
        
    }
    
    func endPreivew() {
        previewLayer?.removeFromSuperlayer()
    }
    
    func recordingStopped() {
        _recording = false
        self.captureButton.enabled = true
        captureButton.setImage(UIImage(named: "CaptureButton"), forState:UIControlState.Normal)
    
        UIApplication.sharedApplication().idleTimerDisabled = false
    
        UIApplication.sharedApplication().endBackgroundTask(_backgroundRecordingID!)
        _backgroundRecordingID = UIBackgroundTaskInvalid
    }
    
    func popButtons(){
        for buttons in buttonArray {
            self.view.bringSubviewToFront(buttons)
        }
    }
    
    
    @IBAction func captureButtonPressed(sender: AnyObject) {
        if ( _recording! ) {
            capturePipeline?.stopRecording()
            captureButton.setImage(UIImage(named: "CaptureButton"), forState:UIControlState.Normal)
        } else {
            // Disable the idle timer while recording
            UIApplication.sharedApplication().idleTimerDisabled = true
            
            // Make sure we have time to finish saving the movie if the app is backgrounded during recording
            _backgroundRecordingID = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler({})
            
            captureButton.enabled = false; // re-enabled once recording has finished starting
            
            capturePipeline?.startRecording()
            captureButton.setImage(UIImage(named: "StopButton"), forState:UIControlState.Normal)
        }
    }
    
    @IBAction func AVButtonPressed(sender: AnyObject) {
        if AVButton.imageForState(UIControlState.Normal) == UIImage(named: "AVButtonVideo") {
            endPreivew()
            AVButton.setImage(UIImage(named: "AVButtonAudio"), forState:UIControlState.Normal)
            
        } else {
            startPreview()
            AVButton.setImage(UIImage(named: "AVButtonVideo"), forState:UIControlState.Normal)
            
        }
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    func showError(error: NSError) {
        let alertView = UIAlertView()
        alertView.title = error.localizedDescription
        alertView.message = error.localizedFailureReason
        //alertView.delegate = nil
        alertView.addButtonWithTitle("OK")
        //alertView.otherButtonTitles = nil
        alertView.show()
    }
    
    
    

    
    
    func capturePipeline(capturePipeline: RosyWriterCapturePipeline, didStopRunningWithError error: NSError) {
        
        showError(error)
        captureButton.enabled = false;
    }

    // Preview
    func capturePipeline(capturePipline: RosyWriterCapturePipeline, previewPixelBufferReadyForDisplay previewPixelBuffer: CVPixelBufferRef) {
    
        if (( _allowedToUseGPU ) == nil) {
            return
        }
    
        if ( previewView == nil ) {
            setupPreviewView()
        }
    
        previewView?.displayPixelBuffer(previewPixelBuffer)
    }
    

    
    func capturePipelineDidRunOutOfPreviewBuffers(capturePipeline:RosyWriterCapturePipeline) {
        if ( _allowedToUseGPU == nil ) {
            self.previewView?.flushPixelBufferCache
        }
    }
    
    // Recording
    func capturePipelineRecordingDidStart(capturePipeline:RosyWriterCapturePipeline) {
        _recording = true;
        self.captureButton.enabled = true
    }
    
    func capturePipelineRecordingWillStop(capturePipeline:RosyWriterCapturePipeline) {
        // Disable record button until we are ready to start another recording
        self.captureButton.enabled = false
        captureButton.setImage(UIImage(named: "StopButton"), forState:UIControlState.Normal)
    }
    
    func capturePipelineRecordingDidStop(capturePipeline:RosyWriterCapturePipeline) {
        self.recordingStopped()
    }
    
    func capturePipeline(capturePipeline:RosyWriterCapturePipeline, recordingDidFailWithError error:NSError)
    {
        self.recordingStopped()
        self.showError(error)
    }
    
}



extension AVCaptureVideoOrientation {
    var uiInterfaceOrientation: UIInterfaceOrientation {
        get {
            switch self {
            case .LandscapeLeft:        return .LandscapeLeft
            case .LandscapeRight:       return .LandscapeRight
            case .Portrait:             return .Portrait
            case .PortraitUpsideDown:   return .PortraitUpsideDown
            }
        }
    }
    
    init(ui:UIInterfaceOrientation) {
        switch ui {
        case .LandscapeRight:       self = .LandscapeRight
        case .LandscapeLeft:        self = .LandscapeLeft
        case .Portrait:             self = .Portrait
        case .PortraitUpsideDown:   self = .PortraitUpsideDown
        default:                    self = .Portrait
        }
    }
}

