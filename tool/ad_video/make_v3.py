"""Builds the 15-second before/after ad (V3) from the recorded app footage:

    python3 tool/ad_video/make_v3.py en      # or de

Needs tool/ad_video/record.sh <lang> first (build/ad_video/<lang>/).
Output: build/ad_video/<lang>/lifethreads_v3_<lang>.mp4 (1080×1920, voice-over and music).

The voice is macOS `say`, a draft. For the final ad, make the three lines in ElevenLabs (or
record them), save them as build/ad_video/<lang>/v3/line0.m4a … line2.m4a and run with
VOICE=files: the picture is timed to whichever lines it gets.
"""
import os
import random
import re
import subprocess
import sys

from PIL import Image, ImageDraw, ImageEnhance, ImageFilter, ImageFont

LANG = sys.argv[1] if len(sys.argv) > 1 else 'en'
ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..')
OUT = os.path.join(ROOT, 'build', 'ad_video', LANG)
WORK = os.path.join(OUT, 'v3')
W, H, FPS = 1080, 1920, 30
BG = (10, 7, 11)
GOLD = (210, 162, 74)
CREAM = (255, 248, 234)
FONT = '/System/Library/Fonts/Avenir Next.ttc'

TEXT = {
    'en': {
        'voice': ['Twelve thousand photos… and you can’t find a single story.',
                  'LifeThreads keeps the moments that matter, with the story behind them.',
                  'Free on the App Store and Google Play.'],
        'say': 'Samantha',
        'a1': '12,000 photos.', 'a2': 'Zero stories.',
        'b': 'Only the moments\nthat matter.',
        'c': 'Free on the App Store\n& Google Play',
    },
    'de': {
        'voice': ['Zwölftausend Fotos … und keine einzige Geschichte.',
                  'LifeThreads hält die Momente fest, die zählen – mit der Geschichte dahinter.',
                  'Gratis im App Store und bei Google Play.'],
        'say': 'Anna',
        'a1': '12.000 Fotos.', 'a2': 'Keine Geschichte.',
        'b': 'Nur die Momente,\ndie zählen.',
        'c': 'Gratis im App Store\n& bei Google Play',
    },
}[LANG]


def run(*args):
    r = subprocess.run(args, stdout=subprocess.DEVNULL, stderr=subprocess.PIPE, text=True)
    if r.returncode:
        sys.exit(r.stderr[-2000:])


def duration(path):
    out = subprocess.run(['ffprobe', '-v', 'error', '-show_entries', 'format=duration', '-of',
                          'csv=p=0', path], capture_output=True, text=True, check=True).stdout
    return float(out)


def font(size, bold=True):
    # Avenir Next: index 0 Bold, 7 Regular in the system collection.
    return ImageFont.truetype(FONT, size, index=0 if bold else 7)


def caption(path, text, size, color=CREAM, y=0.42):
    """A transparent full-frame PNG with centered text and a soft shadow, inside the safe zone."""
    img = Image.new('RGBA', (W, H), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    f = font(size)
    box = d.multiline_textbbox((0, 0), text, font=f, align='center', spacing=size * 0.18)
    x = (W - (box[2] - box[0])) / 2 - 40  # a little left of center: the right edge has the app buttons
    top = H * y - (box[3] - box[1]) / 2
    # A dark rounded band behind the text, so it reads over busy photos and the app.
    pad = size * 0.45
    ImageDraw.Draw(img).rounded_rectangle(
        (x - pad, top - pad * 0.7, x + (box[2] - box[0]) + pad, top + (box[3] - box[1]) + pad * 1.1),
        radius=size * 0.5, fill=(10, 7, 11, 190))
    shadow = Image.new('RGBA', (W, H), (0, 0, 0, 0))
    ImageDraw.Draw(shadow).multiline_text((x, top + 4), text, font=f, fill=(0, 0, 0, 200),
                                          align='center', spacing=size * 0.18)
    img = Image.alpha_composite(img, shadow.filter(ImageFilter.GaussianBlur(10)))
    ImageDraw.Draw(img).multiline_text((x, top), text, font=f, fill=color, align='center',
                                       spacing=size * 0.18)
    img.save(path)


def camera_roll(path, seconds):
    """A fast scroll through a crowded, messy photo grid: crops, near-duplicates, blurry and
    dark shots and screenshots, made from the demo photos."""
    photos = [Image.open(os.path.join(ROOT, 'assets', 'demo_moments', n)).convert('RGB')
              for n in sorted(os.listdir(os.path.join(ROOT, 'assets', 'demo_moments')))
              if n.endswith('.jpg')]
    rnd = random.Random(7)
    cols, gap = 4, 4
    tile = (W - gap * (cols - 1)) // cols
    rows = 70
    sheet = Image.new('RGB', (W, rows * (tile + gap)), (0, 0, 0))
    for i in range(rows * cols):
        kind = rnd.random()
        if kind < 0.12:  # a screenshot
            t = Image.new('RGB', (tile, tile), rnd.choice([(242, 242, 247), (28, 28, 30), (230, 236, 255)]))
            dd = ImageDraw.Draw(t)
            for k in range(rnd.randint(4, 8)):
                yy = 20 + k * 30
                dd.rounded_rectangle((16, yy, 16 + rnd.randint(80, tile - 32), yy + 14), 6,
                                     fill=rnd.choice([(170, 170, 180), (120, 140, 230), (90, 90, 96)]))
        else:
            p = rnd.choice(photos)
            s = rnd.uniform(0.35, 0.9)
            cw, ch = int(p.width * s), int(p.height * s)
            x0, y0 = rnd.randint(0, p.width - cw), rnd.randint(0, p.height - ch)
            side = min(cw, ch)
            t = p.crop((x0, y0, x0 + side, y0 + side)).resize((tile, tile))
            if kind < 0.3:
                t = t.filter(ImageFilter.GaussianBlur(rnd.uniform(4, 10)))
            elif kind < 0.42:
                t = ImageEnhance.Brightness(t).enhance(rnd.uniform(0.25, 0.5))
            elif kind < 0.5:
                t = t.rotate(rnd.choice([90, -90]))
        r, c = divmod(i, cols)
        sheet.paste(t, (c * (tile + gap), r * (tile + gap)))
    frames = int(seconds * FPS)
    travel = sheet.height - H
    enc = subprocess.Popen(['ffmpeg', '-y', '-loglevel', 'error', '-f', 'rawvideo', '-pix_fmt', 'rgb24',
                            '-s', f'{W}x{H}', '-r', str(FPS), '-i', '-', '-c:v', 'libx264', '-crf', '18',
                            '-pix_fmt', 'yuv420p', path], stdin=subprocess.PIPE)
    for f in range(frames):
        t = f / max(1, frames - 1)
        y = int(travel * (t ** 1.6))  # speeds up, like a frustrated thumb
        enc.stdin.write(sheet.crop((0, y, W, y + H)).tobytes())
    enc.stdin.close()
    enc.wait()


def end_card(path):
    img = Image.new('RGB', (W, H), BG)
    icon = Image.open(os.path.join(ROOT, 'assets', 'brand', 'lifethreads_app_icon_1024.png')).convert('RGBA')
    icon = icon.resize((300, 300))
    mask = Image.new('L', icon.size, 0)
    ImageDraw.Draw(mask).rounded_rectangle((0, 0, 299, 299), 68, fill=255)
    img.paste(icon, ((W - 300) // 2, 560), mask)
    d = ImageDraw.Draw(img)
    f = font(92)
    tw = d.textlength('LifeThreads', font=f)
    d.text(((W - tw) / 2, 920), 'LifeThreads', font=f, fill=CREAM)
    d.line(((W - 360) / 2, 1060, (W + 360) / 2, 1060), fill=GOLD, width=4)
    f2 = font(52, bold=False)
    box = d.multiline_textbbox((0, 0), TEXT['c'], font=f2, align='center', spacing=14)
    d.multiline_text(((W - (box[2] - box[0])) / 2, 1110), TEXT['c'], font=f2, fill=GOLD,
                     align='center', spacing=14)
    img.save(path)


def main():
    os.makedirs(WORK, exist_ok=True)
    footage = os.path.join(OUT, f'lifethreads_{LANG}_9x16.mp4')
    scenes = dict((name, float(sec)) for sec, name in
                  re.findall(r'([\d.]+)s\s+(\S+)', open(os.path.join(OUT, 'scenes.txt')).read()))

    # Voice: three lines, measured so the picture fits them.
    lines = []
    for i, text in enumerate(TEXT['voice']):
        if os.environ.get('VOICE') == 'files':
            path = os.path.join(WORK, f'line{i}.m4a')
        else:
            path = os.path.join(WORK, f'line{i}.aiff')
            run('say', '-v', TEXT['say'], '-r', '175', '-o', path, text)
        lines.append((path, duration(path)))
    a = max(5.5, lines[0][1] + 1.0)
    b = max(5.0, lines[1][1] + 0.9)
    c = max(2.6, lines[2][1] + 1.0)
    flash = 0.25
    total = a + flash + b + c

    roll = os.path.join(WORK, 'roll.mp4')
    camera_roll(roll, a)
    for name, text, size, y in (('a1', TEXT['a1'], 110, 0.42), ('a2', TEXT['a2'], 110, 0.42),
                                ('b', TEXT['b'], 92, 0.68)):
        caption(os.path.join(WORK, f'{name}.png'), text, size, y=y)
    end = os.path.join(WORK, 'end.png')
    end_card(end)

    # The wall for a moment, then a memory opening (the 'memory' scene starts with the tap).
    wall_from = max(0.0, scenes.get('memory', 3.0) - 2.2)
    music = os.path.join(ROOT, 'assets', 'music', 'holizna_the_good_times.m4a')
    out = os.path.join(OUT, f'lifethreads_v3_{LANG}.mp4')
    v1, v2, v3 = lines[0][0], lines[1][0], lines[2][0]
    t2, t3 = a + flash + 0.3, a + flash + b + 0.2
    graph = (
        f'[0:v]setpts=PTS-STARTPTS,fps={FPS}[roll];'
        f'color=c=white:s={W}x{H}:d={flash}:r={FPS}[flash];'
        f'[1:v]trim=start={wall_from}:duration={b},setpts=PTS-STARTPTS,fps={FPS},scale={W}:{H}[app];'
        f'[2:v]loop=loop=-1:size=1:start=0,trim=duration={c},setpts=PTS-STARTPTS,fps={FPS},format=yuv420p[end];'
        f'[roll][flash][app][end]concat=n=4:v=1:a=0,format=yuv420p[base];'
        f'[base][3:v]overlay=enable=\'between(t,0.3,{a / 2:.2f})\'[o1];'
        f'[o1][4:v]overlay=enable=\'between(t,{a / 2:.2f},{a:.2f})\'[o2];'
        f'[o2][5:v]overlay=enable=\'between(t,{a + flash + 0.4:.2f},{a + flash + b:.2f})\',fade=t=out:st={total - 0.4:.2f}:d=0.4[v];'
        f'[6:a]adelay=400|400[l1];[7:a]adelay={int(t2 * 1000)}|{int(t2 * 1000)}[l2];'
        f'[8:a]adelay={int(t3 * 1000)}|{int(t3 * 1000)}[l3];'
        f'[l1][l2][l3]amix=inputs=3:normalize=0,volume=1.25[vo];'
        f'[9:a]atrim=duration={total},volume=0.22,afade=t=in:d=0.5,afade=t=out:st={total - 1.2:.2f}:d=1.2[mu];'
        f'[vo][mu]amix=inputs=2:normalize=0:duration=longest,atrim=duration={total},alimiter=limit=0.89[a]'
    )
    run('ffmpeg', '-y', '-loglevel', 'error',
        '-i', roll, '-i', footage, '-i', end,
        '-i', os.path.join(WORK, 'a1.png'), '-i', os.path.join(WORK, 'a2.png'), '-i', os.path.join(WORK, 'b.png'),
        '-i', v1, '-i', v2, '-i', v3, '-i', music,
        '-filter_complex', graph, '-map', '[v]', '-map', '[a]',
        '-c:v', 'libx264', '-crf', '23', '-preset', 'slow', '-pix_fmt', 'yuv420p', '-c:a', 'aac', '-b:a', '192k',
        '-movflags', '+faststart', '-t', f'{total:.2f}', out)
    print(f'{out}  {total:.1f} s')


if __name__ == '__main__':
    main()
