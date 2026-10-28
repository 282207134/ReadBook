"""Render the project's geometric book icon to platform launcher sizes."""
import json
from pathlib import Path
from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parents[1]
SIZE = 1024
icon = Image.new('RGB', (SIZE, SIZE), '#32cd77')
draw = ImageDraw.Draw(icon)
# Same geometry as app_icon.svg; supersampling keeps small launcher icons crisp.
draw.line([(224, 272), (424, 272), (470, 280), (512, 310),
           (554, 280), (600, 272), (800, 272), (800, 720),
           (600, 720), (554, 728), (512, 758), (470, 728),
           (424, 720), (224, 720), (224, 272)], fill='white', width=40, joint='curve')
draw.line([(512, 320), (512, 750)], fill='white', width=30)
for y in [390, 470]:
    draw.line([(600, y), (720, y)], fill='white', width=30)


def save(path, size):
    icon.resize((size, size), Image.Resampling.LANCZOS).save(ROOT / path)


for density, size in {'mdpi': 48, 'hdpi': 72, 'xhdpi': 96, 'xxhdpi': 144, 'xxxhdpi': 192}.items():
    save(f'android/app/src/main/res/mipmap-{density}/ic_launcher.png', size)
folder = Path('ios/Runner/Assets.xcassets/AppIcon.appiconset')
for item in json.loads((ROOT / folder / 'Contents.json').read_text())['images']:
    size = round(float(item['size'].split('x')[0]) * float(item['scale'].rstrip('x')))
    save(folder / item['filename'], size)
for size in [192, 512]:
    for variant in ['Icon', 'Icon-maskable']:
        save(f'web/icons/{variant}-{size}.png', size)
save('web/favicon.png', 32)
