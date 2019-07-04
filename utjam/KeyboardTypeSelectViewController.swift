//
//  MusicSelectViewController.swift
//  utjam
//
//  Created by 加納大地 on 2019/06/15.
//  Copyright © 2019 加納大地. All rights reserved.
//

import UIKit

class KeyboardTypeSelectViewController: UIViewController {
    var bgmTag:String?
    var bluetoothTag:String?
    
    override func viewDidLoad() { //これも二回呼ばれてる
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonFullKeyboardTapped(sender : UIButton) {
    }
    @IBAction func buttonScalePadTapped(sender : UIButton) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toPlayFullKeyboardViewController") {
            let vc: Pre_PlayFullKeyboardViewController = (segue.destination as? Pre_PlayFullKeyboardViewController)!
            // Send bgmTag to bgmTag in ViewController
            vc.bgmTag = self.bgmTag
            vc.bluetoothTag = self.bluetoothTag
            //self.dismiss(animated: true, completion: nil)
        }
        if (segue.identifier == "toPlayScalePadViewController") {
            let vc: PlayScalePadViewController = (segue.destination as? PlayScalePadViewController)!
            // Send bgmTag to bgmTag in ViewController
            vc.bgmTag = self.bgmTag!
            vc.bluetoothTag = self.bluetoothTag
            //self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
