//
//  ViewController.swift
//  ChurnItUp_Real
//
//  Created by Craker, Rydge on 2/8/18.
//  Copyright © 2018 Craker, Rydge. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let SegueMainScreenViewController = "MainScreenViewController"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func StartButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "MainScreenViewController", sender: self)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    // Use this area to do anything that you want before you go to the new screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        // First, check if the segue's identifier is what we expect it to be
        if segue.identifier == SegueMainScreenViewController {
            let destinationViewController = segue.destination as! MainScreenViewController
 
            }
            
        
    }


}

