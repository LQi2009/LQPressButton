//
//  TestViewController.swift
//  LZPressButton
//
//  Created by Artron_LQQ on 2017/2/16.
//  Copyright © 2017年 Artup. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.lightGray
        
        let press = LDPressButton.init(frame: CGRect.init(x: 100, y: 100, width: 100, height: 100))
        self.view.addSubview(press)
        
        press.actionWithClosure { (state) in
            
            switch state {
                
            case .Begin:
                print("begin")
            case .Moving:
                print("moving")
            case .WillCancel:
                print("willCancel")
            case .DidCancel:
                print("didCancel")
            case .End:
                print("end")
            case .Click:
                print("click")
            }
        }
        
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect.init(x: 100, y: 400, width: 100, height: 100)
        btn.backgroundColor = UIColor.red
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        self.view.addSubview(btn)
        
    }

    func btnClick() {
        
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
