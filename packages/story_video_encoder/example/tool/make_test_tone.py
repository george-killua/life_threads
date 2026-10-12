#!/usr/bin/env python3
"""Synthesises the example's test music (assets/tone.m4a).

A 12 s C-major arpeggio over a low drone, 44.1 kHz stereo. It is generated
here (no downloaded music), so it carries no third-party licence.

    python3 tool/make_test_tone.py /tmp/tone.wav
    afconvert -f m4af -d aac -b 128000 /tmp/tone.wav assets/tone.m4a   # macOS
"""
import math
import struct
import sys
import wave

SAMPLE_RATE = 44100
SECONDS = 12
NOTES = [261.63, 329.63, 392.00, 523.25]  # C4 E4 G4 C5, one per 0.5 s


def main(path: str) -> None:
    frames = bytearray()
    for i in range(SAMPLE_RATE * SECONDS):
        t = i / SAMPLE_RATE
        note = NOTES[int(t * 2) % len(NOTES)]
        envelope = math.exp(-3 * ((t * 2) % 1))
        sample = 0.25 * math.sin(2 * math.pi * 130.81 * t)
        sample += 0.35 * envelope * math.sin(2 * math.pi * note * t)
        value = int(max(-1.0, min(1.0, sample)) * 32767 * 0.8)
        frames += struct.pack('<hh', value, value)
    with wave.open(path, 'wb') as out:
        out.setnchannels(2)
        out.setsampwidth(2)
        out.setframerate(SAMPLE_RATE)
        out.writeframes(bytes(frames))


if __name__ == '__main__':
    main(sys.argv[1] if len(sys.argv) > 1 else 'tone.wav')
