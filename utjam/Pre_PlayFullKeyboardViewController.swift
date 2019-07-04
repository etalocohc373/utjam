//
//  ViewController.swift
//  utjam
//
//  Created by 加納大地 on 2019/06/13.
//  Copyright © 2019 加納大地. All rights reserved.
//

import UIKit
import AVFoundation
import MultipeerConnectivity

class Pre_PlayFullKeyboardViewController: UIViewController, MCBrowserViewControllerDelegate, MCSessionDelegate{
    
    
    var audioPlayers:[AVAudioPlayer] = []
    var bgmPlayer: AVAudioPlayer! = nil
    var bgmTag:String? //passed by MusicSelectView.
    var bluetoothTag:String? //passed by MusicSelectView.
    var bpm:Float = 0.0
    var beat:Float = 0.0
    var numberOfBar:Int = 0
    var barNow:Int = 0
    var pathUtilityPlist:Optional<Any> = nil
    var bgmNSDictPre:NSDictionary = [:]
    var bgmNSDict:NSDictionary = [:]
    var scalesNSDict:NSDictionary = [:]
    var pianoKeysNSArray:NSArray = []
    var uiParametersNSDict:NSDictionary = [:]
    var keyboardButtonList:[UIButton] = []
    
    let serviceType = "UTJAM"
    var browser : MCBrowserViewController!
    var assistant : MCAdvertiserAssistant!
    var session : MCSession!
    var peerID: MCPeerID!
    
    var p1num : Int = 0
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var C0: UIButton!
    @IBOutlet weak var D0: UIButton!
    @IBOutlet weak var E0: UIButton!
    @IBOutlet weak var F0: UIButton!
    @IBOutlet weak var G0: UIButton!
    @IBOutlet weak var A1: UIButton!
    @IBOutlet weak var B1: UIButton!
    @IBOutlet weak var Cs0: UIButton!
    @IBOutlet weak var Ds0: UIButton!
    @IBOutlet weak var Fs0: UIButton!
    @IBOutlet weak var Gs0: UIButton!
    @IBOutlet weak var As1: UIButton!
    @IBOutlet weak var C1: UIButton!
    @IBOutlet weak var Cs1: UIButton!
    @IBOutlet weak var D1: UIButton!
    @IBOutlet weak var Ds1: UIButton!
    @IBOutlet weak var E1: UIButton!
    @IBOutlet weak var F1: UIButton!
    @IBOutlet weak var Fs1: UIButton!
    @IBOutlet weak var Gs1: UIButton!
    @IBOutlet weak var G1: UIButton!
    @IBOutlet weak var A2: UIButton!
    @IBOutlet weak var As2: UIButton!
    @IBOutlet weak var B2: UIButton!
    @IBOutlet weak var C2: UIButton!
    @IBOutlet weak var Cs2: UIButton!
    @IBOutlet weak var D2: UIButton!
    @IBOutlet weak var Ds2: UIButton!
    @IBOutlet weak var E2: UIButton!
    @IBOutlet weak var F2: UIButton!
    @IBOutlet weak var Fs2: UIButton!
    @IBOutlet weak var G2: UIButton!
    @IBOutlet weak var Gs2: UIButton!
    @IBOutlet weak var A3: UIButton!
    @IBOutlet weak var As3: UIButton!
    @IBOutlet weak var B3: UIButton!
    @IBOutlet weak var C3: UIButton!
    @IBOutlet weak var Cs3: UIButton!
    @IBOutlet weak var D3: UIButton!
    @IBOutlet weak var Ds3: UIButton!
    @IBOutlet weak var E3: UIButton!
    @IBOutlet weak var F3: UIButton!
    @IBOutlet weak var Fs3: UIButton!
    @IBOutlet weak var G3: UIButton!
    @IBOutlet weak var Gs3: UIButton!
    @IBOutlet weak var A4: UIButton!
    @IBOutlet weak var As4: UIButton!
    @IBOutlet weak var B4: UIButton!
    @IBOutlet weak var C4: UIButton!
    @IBOutlet weak var Cs4: UIButton!
    @IBOutlet weak var D4: UIButton!
    @IBOutlet weak var Ds4: UIButton!
    @IBOutlet weak var E4: UIButton!
    @IBOutlet weak var F4: UIButton!
    @IBOutlet weak var Fs4: UIButton!
    @IBOutlet weak var G4: UIButton!
    @IBOutlet weak var Gs4: UIButton!
    @IBOutlet weak var A5: UIButton!
    @IBOutlet weak var As5: UIButton!
    @IBOutlet weak var B5: UIButton!
    @IBOutlet weak var C5: UIButton!
    @IBOutlet weak var Cs5: UIButton!
    @IBOutlet weak var D5: UIButton!
    @IBOutlet weak var Ds5: UIButton!
    @IBOutlet weak var E5: UIButton!
    @IBOutlet weak var F5: UIButton!
    @IBOutlet weak var Fs5: UIButton!
    @IBOutlet weak var G5: UIButton!
    @IBOutlet weak var Gs5: UIButton!
    @IBOutlet weak var A6: UIButton!
    @IBOutlet weak var As6: UIButton!
    @IBOutlet weak var B6: UIButton!
    @IBOutlet weak var C6: UIButton!
    @IBOutlet weak var Cs6: UIButton!
    @IBOutlet weak var D6: UIButton!
    @IBOutlet weak var Ds6: UIButton!
    @IBOutlet weak var E6: UIButton!
    @IBOutlet weak var F6: UIButton!
    @IBOutlet weak var Fs6: UIButton!
    @IBOutlet weak var G6: UIButton!
    @IBOutlet weak var Gs6: UIButton!
    @IBOutlet weak var A7: UIButton!
    @IBOutlet weak var As7: UIButton!
    @IBOutlet weak var B7: UIButton!
    
    
    @IBAction func buttonTouchDown(_ sender: UIButton) {
        touchDown(senderTag: sender.tag)
        
        if bluetoothTag == "1"{
            let data = NSData(bytes: [0, sender.tag], length: MemoryLayout<NSInteger>.size)
            do {
                try self.session.send(data as Data, toPeers: self.session.connectedPeers, with: MCSessionSendDataMode.unreliable)
            } catch {
                print(error)
            }
        }
    }
    
    @IBAction func buttonTouchUpInside(_ sender: UIButton) {
        //audioPlayers[sender.tag].stop()
        sender.layer.borderWidth  = 1
        /*
        if bluetoothTag == "1"{
            let data = NSData(bytes: [1, sender.tag], length: MemoryLayout<NSInteger>.size)
            do {
                try self.session.send(data as Data, toPeers: self.session.connectedPeers, with: MCSessionSendDataMode.unreliable)
            } catch {
                print(error)
            }
        }*/
        
    }
    
    func touchDown(senderTag:Int){
        print(senderTag)
        audioPlayers[senderTag].currentTime = 0
        audioPlayers[senderTag].play()
        keyboardButtonList[senderTag].layer.borderWidth  = 3
    }
    
    func touchUpInside(senderTag:Int){
        print(senderTag)
        //audioPlayers[senderTag].stop()
        keyboardButtonList[senderTag].layer.borderWidth  = 1
    }
    
    func browserViewControllerDidFinish(
        _ browserViewController: MCBrowserViewController)  {
        // Called when the browser view controller is dismissed (ie the Done
        // button was tapped)
        
        self.dismiss(animated: true, completion: nil)
    }
 
    func browserViewControllerWasCancelled(
        _ browserViewController: MCBrowserViewController)  {
        // Called when the browser view controller is cancelled
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: scrollView.contentSize.width/(-2), bottom: 0, right: 0)
        setVariables()
        
        if bluetoothTag == "1"{
            bluetoothSetUp()
            self.present(self.browser, animated: true, completion: nil)
        }
        for button in keyboardButtonList{
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor(red:0, green: 0, blue: 0, alpha: 1).cgColor
        }
        prepareSound()
        startBGM()
        
        
        let timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(beat*(60/bpm)), repeats: true, block: { (timer) in
            if self.barNow == self.numberOfBar{
                timer.invalidate()
                print("finished!")
                Thread.sleep(forTimeInterval: 2.0)
                self.terminateViewController()
            }else{
                self.barNow += 1
                self.relodeSoundKey()
            }
        })
    }
    
    func bluetoothSetUp(){
        self.peerID = MCPeerID(displayName: UIDevice.current.name)
        self.session = MCSession(peer: peerID)
        self.session.delegate = self
        
        // create the browser viewcontroller with a unique service name
        self.browser = MCBrowserViewController(serviceType:serviceType,
                                               session:self.session)
        self.browser.delegate = self;
        self.assistant = MCAdvertiserAssistant(serviceType:serviceType,
                                               discoveryInfo:nil, session:self.session)
        
        // tell the assistant to start advertising our fabulous chat
        self.assistant.start()
    }
    
    func session(_ session: MCSession, didReceive data: Data,
                 fromPeer peerID: MCPeerID)  {
        DispatchQueue.main.async() {
            let data = NSData(data: data)
            
            // the number of elements:
            let count = data.length / MemoryLayout<NSInteger>.size
            
            // create array of appropriate length:
            //var array = [NSInteger](count: count, repeatedValue: 0)
            var array = [NSInteger](repeating: 0, count: count)
            
            // copy bytes into array
            data.getBytes(&array, length:count * MemoryLayout<NSInteger>.size)
            
            switch array[0]{
            case 0:
                self.touchDown(senderTag: array[1])
            case 1:
                self.touchUpInside(senderTag: array[1])
            default:
                break
            }
        }
            
    }
    
    func setVariables(){
        self.audioPlayers = []
        self.pathUtilityPlist = Bundle.main.path(forResource: "Utility", ofType: "plist")
        self.bgmNSDictPre = NSDictionary(contentsOfFile:self.pathUtilityPlist! as! String)!["bgmDict"] as! NSDictionary
        self.bgmNSDict = self.bgmNSDictPre.object(forKey:bgmTag!) as! NSDictionary
        self.scalesNSDict = (NSDictionary(contentsOfFile:self.pathUtilityPlist! as! String)!["scalesDict"] as! NSDictionary)["full"] as! NSDictionary
        self.pianoKeysNSArray = (NSDictionary(contentsOfFile: pathUtilityPlist! as! String)!["soundsList"] as! NSArray)
        self.uiParametersNSDict = NSDictionary(contentsOfFile:self.pathUtilityPlist! as! String)!["uiParametersDict"] as! NSDictionary
        self.bpm = bgmNSDict.object(forKey:"bpm") as! Float
        self.beat = bgmNSDict.object(forKey:"beat") as! Float
        self.numberOfBar = bgmNSDict.object(forKey:"numberOfBar") as! Int
        self.barNow = 0
        self.keyboardButtonList = [
        UIButton(), UIButton(), UIButton(), C0, Cs0, D0, Ds0, E0, F0, Fs0, G0, Gs0,
        A1, As1, B1, C1, Cs1, D1, Ds1, E1, F1, Fs1, G1, Gs1,
        A2, As2, B2, C2, Cs2, D2, Ds2, E2, F2, Fs2, G2, Gs2,
        A3, As3, B3, C3, Cs3, D3, Ds3, E3, F3, Fs3, G3, Gs3,
        A4, As4, B4, C4, Cs4, D4, Ds4, E4, F4, Fs4, G4, Gs4,
        A5, As5, B5, C5, Cs5, D5, Ds5, E5, F5, Fs5, G5, Gs5,
        A6, As6, B6, C6, Cs6, D6, Ds6, E6, F6, Fs6, G6, Gs6,
        A7, As7, B7, UIButton()]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    func prepareSound(){
        var audioPlayer: AVAudioPlayer! = nil
        
        for keyNSTaggedPointerString in pianoKeysNSArray{
            let key = keyNSTaggedPointerString as! String
            let pianoSoundsNSURL = NSURL(fileURLWithPath: Bundle.main.path(forResource: "sound/\(key)", ofType: "mp3")!)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: pianoSoundsNSURL as URL, fileTypeHint:nil)
            } catch {
                print(pianoSoundsNSURL)
                print("SoundのAVAudioPlayerインスタンス作成でエラー")
            }
            // 再生準備
            // Do any additional setup after loading the view, typically from a nib.
            audioPlayer.prepareToPlay()
            audioPlayers.append(audioPlayer)
        }
    }
    
    func startBGM(){
        let bgmFileName = bgmNSDict.object(forKey:String("title")) as! String
        let bgmNSURL = NSURL(fileURLWithPath: Bundle.main.path(forResource: "bgm/\(String(describing: bgmFileName))", ofType: "mp3")!)
        do {
            bgmPlayer = try AVAudioPlayer(contentsOf: bgmNSURL as URL, fileTypeHint:nil)
        } catch {
            print("BGMのAVAudioPlayerインスタンス作成でエラー")
        }
        bgmPlayer.currentTime = 0
        bgmPlayer.prepareToPlay()
        bgmPlayer.play()
    }
        
    func relodeSoundKey(){
        for keyboardButton in keyboardButtonList{
            switch keyboardButton.tag % 12{
            case 0,2,3,5,7,8,10:
                keyboardButton.layer.backgroundColor = UIColor(red:255, green: 255, blue: 255, alpha: 1).cgColor
            default:
                keyboardButton.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
            }
        }
        
        let scaleNow:String = (bgmNSDict.object(forKey:"scalesList") as! NSArray)[barNow-1] as! String
        // Load notes array for barNow-scale from scalesDict
        let soundNSArrayInScaleNow: NSArray = scalesNSDict.object(forKey:scaleNow) as! NSArray
        // Convert barNow-scale NSArray-to-Array(Int)
        for soundKeyNSString in soundNSArrayInScaleNow{
            keyboardButtonList[(soundKeyNSString as! Int)].layer.backgroundColor = UIColor(red:0, green: 255, blue: 255, alpha: 1).cgColor
        }
        
    }
    
    
    func terminateViewController(){
        self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    deinit{
        print("A deinit")
    }
    
    // below is required implementation for MCSessionDelegate
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
}