//
//  ThirdViewController.swift
//  MedRhythmsBeta
//
//  Created by Work on 10/17/16.
//  Copyright © 2016 Work. All rights reserved.
//

import UIKit
import AudioKit
import Foundation

class ThirdViewController: UIViewController {
	@IBOutlet weak var scoreView: UIView!

	@IBOutlet weak var amplitudeScoreLabel: UILabel!

	@IBOutlet weak var frequencyScoreLabel: UILabel!

	@IBOutlet weak var notesMatchedLabel: UILabel!

	@IBOutlet weak var restartButton: UIButton!

	@IBOutlet weak var audioPlotView: EZAudioPlot!
	@IBOutlet weak var micAmpLabel: UILabel!
	@IBOutlet weak var micFreqLabel: UILabel!
	@IBOutlet weak var micNoteSharpLabel: UILabel!
	@IBOutlet weak var playerAmpLabel: UILabel!
	@IBOutlet weak var playerFreqLabel: UILabel!
	@IBOutlet weak var playerNoteSharpLabel: UILabel!

	//Variables - Passed on Segue
	var numberOfTrials = Int()
	var chosenSound = String()

	//Variables - Notes
	let noteFrequencies = [16.35, 17.32, 18.35, 19.45, 20.6, 21.83, 23.12, 24.5, 25.96, 27.5, 29.14, 30.87]
	let noteNamesWithSharps = ["C", "C♯", "D", "D♯", "E", "F", "F♯", "G", "G♯", "A", "A♯", "B"]
	let noteNamesWithFlats = ["C", "D♭", "D", "E♭", "E", "F", "G♭", "G", "A♭", "A", "B♭", "B"]

	//Variables - AudioKit
	var mic: AKMicrophone!
	var micBooster: AKBooster!
	var micTracker: AKFrequencyTracker!
	var micSilence: AKBooster!
	var chosenFile: AKAudioFile!
	var player: AKAudioPlayer!
	var playerTracker: AKFrequencyTracker!
	var balancer: AKBalancer!
	var trackerMixer: AKMixer!
    var playerDampener: AKBooster!
	var numberOfLoops = 0
	var timer: Timer!

	var numberOfIndividualScores = 0
	var amplitudeScore = 0.0
	var frequencyScore = 0.0
	var notesMatched = 0

	//FUNCTIONS

	func setupPlots() {
		print("Setting up plots")
		let playerPlot = AKRollingOutputPlot(frame: audioPlotView.bounds)
		playerPlot.setRollingHistoryLength(100)
		playerPlot.gain = 10
		playerPlot.shouldCenterYAxis = false
		playerPlot.plotType = .rolling
		playerPlot.shouldFill = true
		playerPlot.shouldMirror = false
		playerPlot.color = UIColor.red
		playerPlot.backgroundColor = UIColor.clear

		audioPlotView.addSubview(playerPlot)

		let micPlot = AKNodeOutputPlot(mic, frame: audioPlotView.bounds)
		micPlot.setRollingHistoryLength(100)
		micPlot.gain = 10
		micPlot.shouldCenterYAxis = false
		micPlot.plotType = .rolling
		micPlot.shouldFill = false
		micPlot.shouldMirror = false
		micPlot.color = UIColor.green
		micPlot.waveformLayer.lineWidth = 3
		micPlot.backgroundColor = UIColor.clear
		audioPlotView.insertSubview(micPlot, aboveSubview: playerPlot)
	}

	func loopPlayer() {
		if numberOfLoops < numberOfTrials {
			player.start()
		} else {
			numberOfLoops = 0
			trackerMixer.stop()
            mic.stop()
            micBooster.stop()
            micSilence.stop()
            micTracker.stop()
            
            player.stop()
            playerTracker.stop()
            

		}
	}

	func updateFrequencyLabel(frequency: Float) -> String {

		guard frequency > Float(noteFrequencies[noteFrequencies.count-1]) else {return "N/A High"}
		guard frequency < Float(noteFrequencies[0]) else {return "N/A Low"}

		var minDistance: Float = 10000.0
		var index = 0

		for i in 0..<noteFrequencies.count {
			let distance = fabsf(Float(noteFrequencies[i]) - frequency)
			if distance < minDistance {
				index = i
				minDistance = distance
			}
		}
		let octave = Int(log2f(frequency/frequency))
		return "\(noteNamesWithSharps[index])\(octave)"
	}

	func updateUI() {
		//UPDATE LABELS
		var notesDetected = 0
		micAmpLabel.text = String(format: "%0.1f", micTracker.amplitude)
		if micTracker.amplitude > 0.1 {
			micFreqLabel.text = String(format: "%0.1f", micTracker.frequency)
			micNoteSharpLabel.text = updateFrequencyLabel(frequency: Float(micTracker.frequency))
			notesDetected += 1
		}

		playerAmpLabel.text = String(format: "%0.1f", playerTracker.amplitude)
		if playerTracker.amplitude > 0.1 {
			playerFreqLabel.text = String(format: "%0.1f", playerTracker.frequency)
			playerNoteSharpLabel.text = updateFrequencyLabel(frequency: Float(playerTracker.frequency))
			notesDetected += 1

			//UPDATE SCORE - Only Score when player has sound
			numberOfIndividualScores += 1
			amplitudeScore += playerTracker.amplitude - micTracker.amplitude
			frequencyScore += playerTracker.frequency - micTracker.frequency
			if notesDetected == 2 {
				notesMatched += 1
			}

		}
		//Segue to Results ViewController
		if player.isStopped {
			timer.invalidate()
			timer = nil
			amplitudeScoreLabel.text = String(format:"%0.2f", amplitudeScore / numberOfIndividualScores)
			frequencyScoreLabel.text = String(format:"%0.2f", frequencyScore / numberOfIndividualScores)
			notesMatchedLabel.text = String(notesMatched)
			scoreView.isHidden = false

		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		//Set Microphone
		mic = AKMicrophone()

		//Set Player
		do {chosenFile = try AKAudioFile(readFileName: "\(self.chosenSound)")
		} catch {print("#ERROR: COULD NOT READ/FIND FILE")
		}

		do {player = try AKAudioPlayer(file: chosenFile, looping: false, completionHandler: { (Void) in
			self.numberOfLoops += 1
			self.loopPlayer()
		})
		} catch {print("#ERROR: COULD NOT SET PLAYER")
		}

		//Set Trackers and Output
		micTracker = AKFrequencyTracker(mic)
		playerTracker = AKFrequencyTracker(player)
		micSilence = AKBooster(micTracker, gain:0)
		playerDampener = AKBooster(playerTracker, gain:0.1)
		trackerMixer = AKMixer(micSilence, playerDampener)
		AudioKit.output = trackerMixer
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		//Start nodes
		AudioKit.start()
		mic.start()
		player.start()
		timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ThirdViewController.updateUI), userInfo: nil, repeats: true)
		setupPlots()
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
	}

	@IBAction func restartButtonPressed(_ sender: AnyObject) {
		self.dismiss(animated: true)
	}
		override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

}
