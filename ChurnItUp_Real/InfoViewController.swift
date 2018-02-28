//
//  InfoViewController.swift
//  ChurnItUp_Real
//
//  Created by Jon Vollmer on 2/20/18.
//  Copyright © 2018 Craker, Rydge. All rights reserved.
//

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
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
