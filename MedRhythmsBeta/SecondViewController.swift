//
//  SecondViewController.swift
//  MedRhythmsBeta
//
//  Created by Work on 10/17/16.
//  Copyright © 2016 Work. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var picker1: UIPickerView!
    @IBOutlet weak var stepper1: UIStepper!
    @IBOutlet weak var trialsValueLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
	var numberOfTrials = 1
	var pickerOptions = ["User's Name", "Hello", "Bathroom"]
	var soundChoice = "ImPeterSound.wav"

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		picker1.delegate = self
		picker1.dataSource = self

		self.trialsValueLabel.text = "\(Int(self.stepper1.value))"

	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return pickerOptions[row]
	}

	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return pickerOptions.count
	}
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		if row == 0 {
			soundChoice = "ImPeterSound.wav"
		} else if row == 1 {
			soundChoice = "HelloSound.wav"
		}
		print(soundChoice)
	}

	@IBAction func stepperChanged(_ sender: AnyObject) {
		self.numberOfTrials = Int(self.stepper1.value)
					self.trialsValueLabel.text = String(self.numberOfTrials)

	}

	@IBAction func unwindtoSecondViewController (segue: UIStoryboardSegue) {
		print("##unwindFourthViewController")
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let newViewController: ThirdViewController = segue.destination as! ThirdViewController
		newViewController.numberOfTrials = self.numberOfTrials
		newViewController.chosenSound = self.soundChoice
	}

}
