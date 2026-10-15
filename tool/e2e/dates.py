"""Prints the photo dates as the app's photo picker labels them
("Photo from Oct 15, 2025"), as shell assignments for run_e2e.sh.

They match the photos from make_photos.py.
"""
import datetime


def label(day):
    months = "Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec".split()
    return f"{months[day.month - 1]} {day.day}, {day.year}"


today = datetime.date.today()
try:
    year_ago = today.replace(year=today.year - 1)
except ValueError:  # 29 February
    year_ago = today.replace(year=today.year - 1, day=28)

print(f'PHOTO_YEAR_AGO="{label(year_ago)}"')
print(f'PHOTO_SUMMIT="{label(datetime.date(year_ago.year, 7, 20))}"')
print(f'PHOTO_GARDEN="{label(datetime.date(year_ago.year, 5, 18))}"')
print(f'LAST_YEAR="{year_ago.year}"')
