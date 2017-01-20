//
//  FourthViewController.swift
//  MedRhythmsBeta
//
//  Created by Work on 10/18/16.
//  Copyright © 2016 Work. All rights reserved.
//

import UIKit

class FourthViewController: UIViewController {
	@IBOutlet weak var restartButton: UIButton!

	var amplitudeScore = Double()
	var frequencyScore = Double()
	var notesMatched = Int()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
	@IBAction func restartBtnPressed(_ sender: AnyObject) {
	self.performSegue(withIdentifier: "unwindFourthViewController", sender: self)
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
