//
//  ViewController.swift
//  utjam
//
//  Created by 加納大地 on 2019/06/13.
//  Copyright © 2019 加納大地. All rights reserved.
//

import UIKit
import AVFoundation

class PlayFullKeyboardViewController: UIViewController {
    var audioPlayers:[AVAudioPlayer] = []
    var bgmPlayer: AVAudioPlayer! = nil
    var bgmTag:String? //passed by MusicSelectView.
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
    let keyboardScrollView = UIScrollView()
    let whiteStackView = UIStackView()
    let blackStackView = UIStackView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setVariables()
        keyboardSet()
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
    
    func setVariables(){
        self.audioPlayers = []
        self.pathUtilityPlist = Bundle.main.path(forResource: "Utility", ofType: "plist")
        self.bgmNSDictPre = NSDictionary(contentsOfFile:self.pathUtilityPlist! as! String)!["bgmDict"] as! NSDictionary
        self.bgmNSDict = self.bgmNSDictPre.object(forKey:bgmTag!) as! NSDictionary
        self.scalesNSDict = NSDictionary(contentsOfFile:self.pathUtilityPlist! as! String)!["scalesDict"] as! NSDictionary
        self.pianoKeysNSArray = (NSDictionary(contentsOfFile: pathUtilityPlist! as! String)!["soundsList"] as! NSArray)
        self.uiParametersNSDict = NSDictionary(contentsOfFile:self.pathUtilityPlist! as! String)!["uiParametersDict"] as! NSDictionary
        self.keyboardButtonList = []
        self.bpm = bgmNSDict.object(forKey:"bpm") as! Float
        self.beat = bgmNSDict.object(forKey:"beat") as! Float
        self.numberOfBar = bgmNSDict.object(forKey:"numberOfBar") as! Int
        self.barNow = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func buttonEventSoundOn(_ sender: UIButton){
        audioPlayers[sender.tag].currentTime = 0
        audioPlayers[sender.tag].play()
        switch sender.tag % 12{
        case 0,2,3,5,7,8,10:
            sender.layer.backgroundColor = UIColor(red: 127, green: 255, blue: 212, alpha: 1).cgColor
        default:
            sender.layer.backgroundColor = UIColor(red: 127, green: 255, blue: 212, alpha: 1).cgColor
        }
    }
    
    @objc func buttonEventSoundOff(_ sender: UIButton){
        audioPlayers[sender.tag].stop()
    }
    
    func keyboardSet(){
        
        let whiteKeyWidth = uiParametersNSDict["whiteKeyWidth"] as! Int
        let whiteKeyHeight = uiParametersNSDict["whiteKeyWidth"] as! Int
        let blackKeyWidth = uiParametersNSDict["blackKeyWidth"] as! Int
        let blackKeyHeight = uiParametersNSDict["blackKeyWidth"] as! Int
        
        //keyboardScrollSet(whiteKeyWidth: whiteKeyWidth, whiteKeyHeight: whiteKeyHeight)
        stackViewSet(whiteKeyWidth: whiteKeyWidth, whiteKeyHeight: whiteKeyHeight, blackKeyWidth: blackKeyWidth, blackKeyHeight: blackKeyHeight)
        
        //view.addSubview(keyboardViewInScroll)
        var buttonCount:Int = 0
        
        for i in 0...(52*2 - 1){

            let button:UIButton = UIButton()
            
            button.addTarget(self, action: #selector(buttonEventSoundOn(_:)), for: UIControl.Event.touchDown)
            button.addTarget(self, action: #selector(buttonEventSoundOn(_:)), for: UIControl.Event.touchDragEnter)
            button.addTarget(self, action: #selector(buttonEventSoundOff(_:)), for: UIControl.Event.touchUpInside)
            button.addTarget(self, action: #selector(buttonEventSoundOff(_:)), for: UIControl.Event.touchUpOutside)
            button.addTarget(self, action: #selector(buttonEventSoundOff(_:)), for: UIControl.Event.touchDragExit)
            
            switch i%14{
            case 0,2,4,6,8,10,12:
                button.tag = buttonCount
                button.setTitle((pianoKeysNSArray[buttonCount] as! String), for:UIControl.State.normal)
                button.frame = CGRect(x: 0, y: 0, width: whiteKeyWidth, height: whiteKeyHeight)
                button.layer.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1).cgColor
                button.layer.borderWidth = 1.0
                button.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
                whiteStackView.addArrangedSubview(button)
                keyboardButtonList.append(button)
                buttonCount += 1
            case 1,5,7,11,13:
                button.tag = buttonCount
                button.setTitle((pianoKeysNSArray[buttonCount] as! String), for:UIControl.State.normal)
                button.frame = CGRect(x: 0, y: 0, width: blackKeyWidth, height: blackKeyHeight)
                button.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
                button.layer.borderWidth = 1.0
                button.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
                blackStackView.addArrangedSubview(button)
                keyboardButtonList.append(button)
                buttonCount += 1
            default:
                button.frame = CGRect(x: 0, y: 0, width: blackKeyWidth, height: blackKeyHeight)
                button.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
                blackStackView.addArrangedSubview(button)
            }
            
            /*
            self.keyboardViewInScroll.addSubview(button)
            var buttonLeadingConstraint:NSLayoutConstraint
            let buttonTopConstraint = NSLayoutConstraint(item: button,
                                                          attribute: NSLayoutConstraint.Attribute.top,
                                                          relatedBy: NSLayoutConstraint.Relation.equal,
                                                          toItem: self.keyboardViewInScroll,
                                                          attribute: NSLayoutConstraint.Attribute.top,
                                                          multiplier: 1.0,
                                                          constant: 0)
            
            switch i % 12{
            case 0,2,3,5,7,8,10:
                button.frame = CGRect(x: 0, y: 0, width: whiteKeyWidth, height: whiteKeyHeight)
                button.layer.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1).cgColor
                buttonLeadingConstraint = NSLayoutConstraint(item: button,
                                                              attribute: NSLayoutConstraint.Attribute.leading,
                                                              relatedBy: NSLayoutConstraint.Relation.equal,
                                                              toItem: self.keyboardViewInScroll,
                                                              attribute: NSLayoutConstraint.Attribute.leading,
                                                              multiplier: 1.0,
                                                              constant: CGFloat(whiteKeyWidth * whiteKeyCount))
                self.keyboardViewInScroll.addConstraint(buttonTopConstraint)
                self.keyboardViewInScroll.addConstraint(buttonLeadingConstraint)
                whiteKeyCount += 1
            default:
                blackKeyList.append(button)
                button.frame = CGRect(x: 0, y: 0, width: blackKeyWidth, height: blackKeyHeight)
                button.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
                switch blackKeyCount % 5{
                case 0,2,4:
                    if blackKeyCount == 0{
                        buttonLeadingConstraint = NSLayoutConstraint(item: button,
                                                                     attribute: NSLayoutConstraint.Attribute.leading,
                                                                     relatedBy: NSLayoutConstraint.Relation.equal,
                                                                     toItem: self.keyboardViewInScroll,
                                                                     attribute: NSLayoutConstraint.Attribute.leading,
                                                                     multiplier: 1.0,
                                                                     constant: CGFloat(whiteKeyWidth - (blackKeyWidth/2)))
                        self.keyboardViewInScroll.addConstraint(buttonTopConstraint)
                        self.keyboardViewInScroll.addConstraint(buttonLeadingConstraint)
                        blackKeyCount += 1
                    }else{
                        buttonLeadingConstraint = NSLayoutConstraint(item: button,
                                                                     attribute: NSLayoutConstraint.Attribute.leading,
                                                                     relatedBy: NSLayoutConstraint.Relation.equal,
                                                                     toItem: blackKeyList[blackKeyCount-1],
                                                                     attribute: NSLayoutConstraint.Attribute.leading,
                                                                     multiplier: 1.0,
                                                                     constant: CGFloat(whiteKeyWidth))
                        self.keyboardViewInScroll.addConstraint(buttonTopConstraint)
                        self.keyboardViewInScroll.addConstraint(buttonLeadingConstraint)
                        blackKeyCount += 1
                    }
                default:
                    buttonLeadingConstraint = NSLayoutConstraint(item: button,
                                                                     attribute: NSLayoutConstraint.Attribute.leading,
                                                                     relatedBy: NSLayoutConstraint.Relation.equal,
                                                                     toItem: blackKeyList[blackKeyCount-1],
                                                                     attribute: NSLayoutConstraint.Attribute.leading,
                                                                     multiplier: 1.0,
                                                                     constant: CGFloat(whiteKeyWidth * 2))
                    self.keyboardViewInScroll.addConstraint(buttonTopConstraint)
                    self.keyboardViewInScroll.addConstraint(buttonLeadingConstraint)
                    blackKeyCount += 1
                }
            }
        keyboardButtonList.append(button)
            */
        }
    }
    
    func keyboardScrollSet(whiteKeyWidth:Int, whiteKeyHeight:Int){
        keyboardScrollView.translatesAutoresizingMaskIntoConstraints = false
        keyboardScrollView.frame.size = CGSize(width: view.frame.width, height: 100) // height must be substituted by a var in the future.
        keyboardScrollView.isPagingEnabled = false
        view.addSubview(keyboardScrollView)
        keyboardScrollView.contentSize = CGSize(width:whiteKeyWidth*45, height:whiteKeyHeight)
        
        let scrollViewBottomConstraint = NSLayoutConstraint(item: keyboardScrollView,
                                                     attribute: NSLayoutConstraint.Attribute.bottom,
                                                     relatedBy: NSLayoutConstraint.Relation.equal,
                                                     toItem: view,
                                                     attribute: NSLayoutConstraint.Attribute.bottom,
                                                     multiplier: 1.0,
                                                     constant: 50)
        let scrollViewLeadingConstraint = NSLayoutConstraint(item: keyboardScrollView,
                                                            attribute: NSLayoutConstraint.Attribute.leading,
                                                            relatedBy: NSLayoutConstraint.Relation.equal,
                                                            toItem: view,
                                                            attribute: NSLayoutConstraint.Attribute.leading,
                                                            multiplier: 1.0,
                                                            constant: 0)
        
        view.addConstraint(scrollViewBottomConstraint)
        view.addConstraint(scrollViewLeadingConstraint)
        
    }
    
    func stackViewSet(whiteKeyWidth:Int, whiteKeyHeight:Int, blackKeyWidth:Int, blackKeyHeight:Int){
        //keyboardScrollView.addSubview(whiteStackView)
        //keyboardScrollView.addSubview(blackStackView)
        
        view.addSubview(whiteStackView)
        view.addSubview(blackStackView)
        whiteStackView.translatesAutoresizingMaskIntoConstraints = false
        whiteStackView.distribution = .fillEqually
        whiteStackView.alignment = .fill
        whiteStackView.spacing = 0
        whiteStackView.leftAnchor.constraint(equalTo:  view.leftAnchor, constant: 0).isActive = true
        whiteStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: CGFloat(-1 * blackKeyHeight)).isActive = true
        whiteStackView.widthAnchor.constraint(equalToConstant: CGFloat(whiteKeyWidth*52)).isActive = true
        whiteStackView.heightAnchor.constraint(equalToConstant: CGFloat(whiteKeyHeight)).isActive = true
        
        blackStackView.translatesAutoresizingMaskIntoConstraints = false
        blackStackView.distribution = .fillEqually
        blackStackView.alignment = .fill
        blackStackView.spacing = CGFloat(whiteKeyWidth)
        blackStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: CGFloat(whiteKeyWidth - (blackKeyWidth * 1/2))).isActive = true
        blackStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: CGFloat(-1 * whiteKeyHeight)).isActive = true
        blackStackView.widthAnchor.constraint(equalToConstant: CGFloat(whiteKeyWidth*52 - (whiteKeyWidth - (blackKeyWidth * 1/2)))).isActive = true
        blackStackView.heightAnchor.constraint(equalToConstant: CGFloat(blackKeyHeight)).isActive = true
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
        var soundKeyListNow:[Int] = []
        for soundNSString in soundNSArrayInScaleNow{
            let sound:Int = soundNSString as! Int
            for i in 1...8{
                if (sound%12) * i <= 87{
                    soundKeyListNow.append((sound%12) * i)
                }
            }
        }
        for soundKey in soundKeyListNow{
            keyboardButtonList[soundKey].layer.backgroundColor = UIColor(red: 127, green: 255, blue: 212, alpha: 1).cgColor
        }
    }
    
    func terminateViewController(){
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    deinit{
        print("A deinit")
    }
}
