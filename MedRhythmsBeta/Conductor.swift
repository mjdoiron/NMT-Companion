//
//  Conductor.swift
//  MedRhythmsBeta
//
//  Created by Work on 10/17/16.
//  Copyright © 2016 Work. All rights reserved.
//

import Foundation
import AudioKit

class Conductor {
	var bpm = 120
	var mixer = AKMixer()

	let beepingGenerator = AKOperationGenerator() { parameters in

		let metronome = AKOperation.metronome(frequency: parameters[0] / 60)

		//Creates beeping metronome
		let beep = AKOperation.sineWave(frequency: 480)
		let beeps = beep.triggeredWithEnvelope(
			trigger: metronome,
			attack: 0.01, hold: 0, release: 0.05)

		return beeps
	}

	let guitarGenerator = AKOperationGenerator() { parameters in
		//Sets metronome speed
		let metronome = AKOperation.metronome(frequency: parameters[0] / 60)

		//Creates guitar pluck metronome
		let note = 12 //0, 2, 4, 5, 7, 9, 11, 12
		let octave = 2 * 12 //2...5
		let guitarFrequency = (note+octave).midiNoteToFrequency()
		let plucks = AKOperation.pluckedString(trigger: metronome, frequency: 16.35, amplitude: 1)

		return plucks
	}
	func startMixer() {
		mixer.start()
	}
	func stopMixer() {
		mixer.stop()
	}
	func ToggleMetronome(_ button: String, newBPM: Int) {
		if button == "guitar"{
			guitarGenerator.parameters = [Double(newBPM)]
			beepingGenerator.stop()
			guitarGenerator.start()
		} else if button == "beeping" {
			beepingGenerator.parameters = [Double(newBPM)]
			beepingGenerator.start()
			guitarGenerator.stop()
		}
	}

	func updateBPM(_ newBPM: Int) {
		beepingGenerator.parameters = [Double(newBPM)]
		guitarGenerator.parameters = [Double(newBPM)]
	}

	init() {
		beepingGenerator.parameters = [Double(bpm)]
		guitarGenerator.parameters = [Double(bpm)]
		beepingGenerator.start()
		guitarGenerator.stop()
		mixer = AKMixer(beepingGenerator, guitarGenerator)
		mixer.stop()
		AudioKit.output = mixer
		AudioKit.start()
	}
}
