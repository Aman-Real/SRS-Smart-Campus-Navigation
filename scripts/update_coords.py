from pathlib import Path
import re

root = Path(__file__).resolve().parent.parent
LAT = '30.400586'
LNG = '78.078447'
updated = []
for path in root.rglob('*.*'):
    if path.suffix.lower() not in {'.dart', '.html', '.md'}:
        continue
    text = path.read_text(encoding='utf-8')
    new_text = text
    new_text = re.sub(r'(latitude\s*:\s*)([-+]?[0-9]*\.?[0-9]+)', r'\1' + LAT, new_text)
    new_text = re.sub(r'(longitude\s*:\s*)([-+]?[0-9]*\.?[0-9]+)', r'\1' + LNG, new_text)
    new_text = re.sub(r'(defaultCampusLat\s*=\s*)([-+]?[0-9]*\.?[0-9]+)', r'\1' + LAT, new_text)
    new_text = re.sub(r'(defaultCampusLng\s*=\s*)([-+]?[0-9]*\.?[0-9]+)', r'\1' + LNG, new_text)
    new_text = re.sub(r'\[\s*[-+]?[0-9]*\.?[0-9]+\s*,\s*[-+]?[0-9]*\.?[0-9]+\s*\]', f'[{LAT}, {LNG}]', new_text)
    new_text = re.sub(r'\b28\.5448\s*°?N\s*,\s*77\.1647\s*°?E\b', f'{LAT}, {LNG}', new_text)
    new_text = re.sub(r'\b28\.5448\s*,\s*77\.1647\b', f'{LAT}, {LNG}', new_text)
    if new_text != text:
        path.write_text(new_text, encoding='utf-8')
        updated.append(path.relative_to(root))
print('updated files:')
for f in sorted(updated):
    print(f)
