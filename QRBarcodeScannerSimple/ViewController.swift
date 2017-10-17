//
//  ViewController.swift
//  QRBarcodeScannerSimple
//
//  Created by Renato on 10/17/17.
//  Copyright © 2017 Renato. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    func show(){
        
        // Creating the capture device
        let device = AVCaptureDevice.default(for: AVMediaType.video)
        if device == nil {
            print("Error getting capture device");
            return
        }
        
        // Creating the input
        guard let input = try? AVCaptureDeviceInput(device: device!) else { return }
        
        // Creating an output of Metadata type
        let output = AVCaptureMetadataOutput();
        
        
        // Creating the session (which is responsible for managing the data flow between input/output)
        let session = AVCaptureSession()
        session.addInput(input)
        session.addOutput(output)
        
        
        // setting this own class as the Metadata Objects Delegate
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        // specifying the list of Metadatas that we want to look for
        let allowedFormats = [AVMetadataObject.ObjectType.ean13,
                              AVMetadataObject.ObjectType.qr,
                              AVMetadataObject.ObjectType.upce]

        output.metadataObjectTypes = allowedFormats
        
        
        // Line below lists available metadata for this device
        print("availableMetadataObjectTypes= \(output.availableMetadataObjectTypes)");
        
        
        // Creating the video layer with the session above
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = CGRect(x:0,y:0, width:self.view.frame.size.width,height:self.view.frame.size.height)
        
        self.view.layer.addSublayer(previewLayer)
        
        // start the capture session
        session.startRunning()
        
    } // end of show function
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        for metadata:AVMetadataObject in metadataObjects {
            
            print("Found metadata of type= \(metadata.type.rawValue)");
            
            if (metadata.type == .qr){
                print("Found a QR code!!")
            }
            
            // let's convert the AVMetadataObject to AVMetadataMachineReadableCodeObject so we can have more information about it
            if let transformedMetadata =  output.transformedMetadataObject(for: metadata, connection: connection) as? AVMetadataMachineReadableCodeObject {
                print("Found metadata of value =\(String(describing: transformedMetadata.stringValue))")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        show()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

