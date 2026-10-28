"""Compose unmodified Android screenshots into documentation contact sheets."""
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[1]
FOLDER = ROOT / 'docs' / 'screenshots'


def sheet(names, output, columns, width):
    images = [Image.open(FOLDER / f'{name}.png').convert('RGB') for name in names]
    height = round(images[0].height * width / images[0].width)
    gap, caption = 20, 34
    rows = (len(names) + columns - 1) // columns
    canvas = Image.new('RGB', (columns * (width + gap) + gap,
                              rows * (height + caption + gap) + gap), '#f0f2f5')
    draw = ImageDraw.Draw(canvas)
    try:
        font = ImageFont.truetype('/System/Library/Fonts/Helvetica.ttc', 15)
    except OSError:
        font = ImageFont.load_default()
    for index, (name, image) in enumerate(zip(names, images)):
        x = gap + index % columns * (width + gap)
        y = gap + index // columns * (height + caption + gap)
        canvas.paste(image.resize((width, height), Image.Resampling.LANCZOS), (x, y))
        draw.text((x + 4, y + height + 9), name.replace('_', ' ').title(), fill='#646475', font=font)
    canvas.save(FOLDER / output)


if __name__ == '__main__':
    main = ['01_home', '03_category_detail', '04_book_detail',
            '08_wishlist', '10_cart', '16_payment']
    all_screens = [p.stem for p in sorted(FOLDER.glob('*.png'))
                   if p.stem[:2].isdigit() and '_bottom' not in p.stem]
    sheet(main, 'main_flows.png', 3, 300)
    sheet(all_screens, 'all_screens.png', 4, 230)
    print(f'Prepared 2 contact sheets from {len(all_screens)} App screens.')
