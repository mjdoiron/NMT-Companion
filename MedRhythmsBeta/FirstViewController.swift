//
//  FirstViewController.swift
//  MedRhythmsBeta
//
//  Created by Work on 10/17/16.
//  Copyright © 2016 Work. All rights reserved.
//

import UIKit
import AudioKit

class FirstViewController: UIViewController {
	@IBOutlet weak var metronomeBtn: UIButton!
	@IBOutlet weak var guitarBtn: UIButton!
	@IBOutlet weak var playPauseBtn: UIButton!
	@IBOutlet weak var bpmLbl: UILabel!
	@IBOutlet weak var bpmSlider: UISlider!

	var conductor = Conductor()

	override func viewDidLoad() {
		super.viewDidLoad()
		metronomeBtn.isSelected = true
		bpmSlider.value = 140
		bpmLbl.text = "BPM: 140"
		conductor.updateBPM(Int(bpmSlider.value))

	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		AudioKit.stop()

	}

	@IBAction func playSound(_ sender: UIButton) {
		playPauseBtn.isSelected = !playPauseBtn.isSelected
		if playPauseBtn.isSelected == true {
			conductor.startMixer()
		} else {
			conductor.stopMixer()
		}

	}

	@IBAction func guitarPressed(_ sender: UIButton) {
		conductor.ToggleMetronome("guitar", newBPM:Int(bpmSlider.value))
		guitarBtn.isSelected = true
		metronomeBtn.isSelected = false
	}

	@IBAction func metronomePressed(_ sender: UIButton) {
		conductor.ToggleMetronome("beeping", newBPM:Int(bpmSlider.value))
		metronomeBtn.isSelected = true
		guitarBtn.isSelected = false
	}

	@IBAction func sliderValueChanged(_ sender: UISlider) {
		let currentValue = Float(5 * Int(round(bpmSlider.value / 05.0)))
		sender.setValue(currentValue, animated: true)
		bpmLbl.text = "BPM: \(Int(currentValue))"
		conductor.updateBPM(Int(currentValue))
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

}
