//
//  ComprehensivePage.swift
//  Runner
//
//  Created by zhangxianqiang on 2018/9/6.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

import Foundation
import Flutter

class ComprehensivePage: FlutterViewController, FlutterAppLifeCycleProvider {
    func addApplicationLifeCycleDelegate(_ delegate: FlutterPlugin) {
        print("addApplicationLifeCycleDelegate ==== \(delegate)");
    }
    
}
