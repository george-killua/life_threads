#!/usr/bin/env python3
"""Synthesises the PLACEHOLDER story music (assets/music/placeholder_pad.m4a).

Not a real song: a 30 s gentle chord pad (C - Am - F - G, soft sine voices
with a slow swell), made here so the story-video music path works end to end
before real tracks are approved (see docs/music_candidates.md). It is
generated, not downloaded, so it carries no third-party licence; the output
is dedicated to the public domain (CC0 1.0).

    python3 tool/music/make_placeholder_pad.py            # macOS (afconvert)
    python3 tool/music/make_placeholder_pad.py out.wav    # WAV only
"""
import math
import os
import shutil
import struct
import subprocess
import sys
import tempfile
import wave

SAMPLE_RATE = 44100
SECONDS = 30
CHORD_SECONDS = 7.5
# C major, A minor, F major, G major (root position, around middle C).
CHORDS = [
    [130.81, 261.63, 329.63, 392.00],
    [110.00, 220.00, 261.63, 329.63],
    [87.31, 174.61, 220.00, 261.63],
    [98.00, 196.00, 246.94, 293.66],
]
OUTPUT = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    '..', '..', 'assets', 'music', 'placeholder_pad.m4a',
)


def voice(freq: float, t: float, detune: float) -> float:
    # Two slightly detuned sines plus a quiet octave: a soft "pad".
    return (
        math.sin(2 * math.pi * freq * t)
        + 0.6 * math.sin(2 * math.pi * freq * (1 + detune) * t)
        + 0.15 * math.sin(2 * math.pi * freq * 2 * t)
    )


def chord_gain(local: float) -> float:
    # Each chord swells in over 1.5 s and fades out 1.5 s after the next
    # one starts, so neighbouring chords overlap smoothly.
    attack = min(1.0, local / 1.5)
    release = min(1.0, (CHORD_SECONDS + 1.5 - local) / 1.5)
    return max(0.0, min(attack, release))


def sample_at(t: float, channel: int) -> float:
    value = 0.0
    index = int(t // CHORD_SECONDS)
    for k in (index - 1, index):
        if k < 0 or k >= len(CHORDS):
            continue
        local = t - k * CHORD_SECONDS
        gain = chord_gain(local)
        if gain <= 0:
            continue
        detune = 0.0025 if channel == 0 else 0.0035
        for n, freq in enumerate(CHORDS[k]):
            value += gain * (0.5 if n == 0 else 0.32) * voice(freq, t, detune)
    shimmer = 1 + 0.08 * math.sin(2 * math.pi * 0.2 * t + channel)
    fade_in = min(1.0, t / 2.0)
    fade_out = min(1.0, (SECONDS - t) / 3.0)
    return value * shimmer * fade_in * fade_out * 0.16


def write_wav(path: str) -> None:
    frames = bytearray()
    for i in range(SAMPLE_RATE * SECONDS):
        t = i / SAMPLE_RATE
        left = max(-1.0, min(1.0, sample_at(t, 0)))
        right = max(-1.0, min(1.0, sample_at(t, 1)))
        frames += struct.pack('<hh', int(left * 32767), int(right * 32767))
    with wave.open(path, 'wb') as out:
        out.setnchannels(2)
        out.setsampwidth(2)
        out.setframerate(SAMPLE_RATE)
        out.writeframes(bytes(frames))


def main() -> None:
    if len(sys.argv) > 1:
        write_wav(sys.argv[1])
        return
    if shutil.which('afconvert') is None:
        sys.exit('afconvert (macOS) not found; pass a .wav path instead.')
    with tempfile.TemporaryDirectory() as tmp:
        wav = os.path.join(tmp, 'pad.wav')
        write_wav(wav)
        subprocess.run(
            ['afconvert', '-f', 'm4af', '-d', 'aac', '-b', '128000', wav,
             os.path.abspath(OUTPUT)],
            check=True,
        )
    print('Wrote', os.path.abspath(OUTPUT))


if __name__ == '__main__':
    main()
