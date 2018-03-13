//
//  InfoViewController.swift
//  ChurnItUp_Real
//
//  Created by Jon Vollmer on 2/20/18.
//  Copyright © 2018 Craker, Rydge. All rights reserved.
//
//This screen shows the Info html screen.

import UIKit
import WebKit
class InfoViewController: UIViewController {


    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
            super.viewDidLoad()
            
            if let url = Bundle.main.url(forResource: "info", withExtension: "html"){
                if let htmlData = try? Data(contentsOf: url){
                    let baseURL = URL(fileURLWithPath: Bundle.main.bundlePath)
                    webView.load(htmlData, mimeType: "text/html", characterEncodingName: "UTF-8", baseURL:baseURL)
                }
            }
        }

}
