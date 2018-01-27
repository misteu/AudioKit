//
//  AKModalResonanceFilterAudioUnit.swift
//  AudioKit
//
//  Created by Aurelius Prochazka, revision history on Github.
//  Copyright © 2018 AudioKit. All rights reserved.
//

import AVFoundation

public class AKModalResonanceFilterAudioUnit: AKAudioUnitBase {

    func setParameter(_ address: AKModalResonanceFilterParameter, value: Double) {
        setParameterWithAddress(AUParameterAddress(address.rawValue), value: Float(value))
    }

    func setParameterImmediately(_ address: AKModalResonanceFilterParameter, value: Double) {
        setParameterImmediatelyWithAddress(AUParameterAddress(address.rawValue), value: Float(value))
    }

    var frequency: Double = 500.0 {
        didSet { setParameter(.frequency, value: frequency) }
    }
    var qualityFactor: Double = 50.0 {
        didSet { setParameter(.qualityFactor, value: qualityFactor) }
    }

    var rampTime: Double = 0.0 {
        didSet { setParameter(.rampTime, value: rampTime) }
    }

    public override func initDSP(withSampleRate sampleRate: Double,
                                 channelCount count: AVAudioChannelCount) -> UnsafeMutableRawPointer! {
        return createModalResonanceFilterDSP(Int32(count), sampleRate)
    }

    public override init(componentDescription: AudioComponentDescription,
                  options: AudioComponentInstantiationOptions = []) throws {
        try super.init(componentDescription: componentDescription, options: options)

        let flags: AudioUnitParameterOptions = [.flag_IsReadable, .flag_IsWritable, .flag_CanRamp]

        let frequency = AUParameterTree.createParameter(
            withIdentifier: "frequency",
            name: "Resonant Frequency (Hz)",
            address: AUParameterAddress(0),
            min: 12.0,
            max: 20_000.0,
            unit: .hertz,
            unitName: nil,
            flags: flags,
            valueStrings: nil,
            dependentParameters: nil
        )
        let qualityFactor = AUParameterTree.createParameter(
            withIdentifier: "qualityFactor",
            name: "Quality Factor",
            address: AUParameterAddress(1),
            min: 0.0,
            max: 100.0,
            unit: .generic,
            unitName: nil,
            flags: flags,
            valueStrings: nil,
            dependentParameters: nil
        )

        setParameterTree(AUParameterTree.createTree(withChildren: [frequency, qualityFactor]))
        frequency.value = 500.0
        qualityFactor.value = 50.0
    }

    public override var canProcessInPlace: Bool { get { return true; }}

}
