"""Writes the photos the end-to-end tests pick from the gallery.

Each copy of a demo picture gets EXIF like a phone camera writes it: a capture
date and, for some, a GPS position. One photo is dated exactly one year before
today so "On this day" has a memory to bring back.

    python3 tool/e2e/make_photos.py <out-dir>
"""
import datetime
import os
import sys

from PIL import Image
from PIL.TiffImagePlugin import IFDRational

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
SRC = os.path.join(ROOT, "assets", "demo_moments")


def dms(value):
    value = abs(value)
    d = int(value)
    m = int((value - d) * 60)
    s = round(((value - d) * 60 - m) * 60 * 100)
    return (IFDRational(d, 1), IFDRational(m, 1), IFDRational(s, 100))


def write(src, out, when, gps=None):
    image = Image.open(os.path.join(SRC, src)).convert("RGB")
    exif = image.getexif()
    stamp = when.strftime("%Y:%m:%d %H:%M:%S")
    exif[0x0132] = stamp  # DateTime
    ifd = exif.get_ifd(0x8769)
    ifd[0x9003] = stamp  # DateTimeOriginal
    ifd[0x9004] = stamp  # DateTimeDigitized
    if gps:
        lat, lon = gps
        g = exif.get_ifd(0x8825)
        g[1] = "N" if lat >= 0 else "S"
        g[2] = dms(lat)
        g[3] = "E" if lon >= 0 else "W"
        g[4] = dms(lon)
    image.save(out, "JPEG", quality=88, exif=exif)
    ts = when.timestamp()
    os.utime(out, (ts, ts))


def main():
    out_dir = sys.argv[1]
    os.makedirs(out_dir, exist_ok=True)
    today = datetime.datetime.now().replace(hour=11, minute=30, second=0, microsecond=0)
    try:
        year_ago = today.replace(year=today.year - 1)
    except ValueError:  # 29 February
        year_ago = today.replace(year=today.year - 1, day=28)
    last_year = year_ago.year
    photos = [
        # Same calendar year (last year), so Thread of the Year has a film.
        ("beach_sunset.jpg", "e2e_1_split.jpg", year_ago, (43.5081, 16.4402)),
        ("alpine_summit.jpg", "e2e_2_summit.jpg", datetime.datetime(last_year, 7, 20, 9, 5), (47.0742, 12.6947)),
        ("garden_dinner.jpg", "e2e_3_garden.jpg", datetime.datetime(last_year, 5, 18, 19, 0), None),
        ("first_dance.jpg", "e2e_4_salzburg.jpg", datetime.datetime(2021, 6, 12, 20, 15), (47.8095, 13.0550)),
        ("first_home.jpg", "e2e_5_linz.jpg", datetime.datetime(2022, 9, 3, 14, 0), (48.3069, 14.2858)),
        ("grandma_kitchen.jpg", "e2e_6_graz.jpg", datetime.datetime(2023, 12, 23, 16, 40), (47.0707, 15.4395)),
    ]
    for src, name, when, gps in photos:
        write(src, os.path.join(out_dir, name), when, gps)
        print(os.path.join(out_dir, name))


if __name__ == "__main__":
    main()
