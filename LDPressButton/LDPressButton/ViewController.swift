//
//  ViewController.swift
//  LDPressButton
//
//  Created by Artron_LQQ on 2017/2/23.
//  Copyright © 2017年 Artup. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let btn = UIButton.init(type: .custom)
        
        btn.setTitle("点击弹出", for: .normal)
        btn.backgroundColor = UIColor.red
        btn.frame = CGRect.init(x: 100, y: 100, width: 100, height: 40)
        btn.setTitleColor(UIColor.white, for: .normal)
        
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        self.view.addSubview(btn)
        
    }

    func btnClick() {
        
        let test = TestViewController()
        
        self.present(test, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

