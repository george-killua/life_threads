import { execFileSync } from 'node:child_process';
import fs from 'node:fs';
import path from 'node:path';

const root = path.resolve(import.meta.dirname, '..');
const outPhone = path.join(root, 'store_listing_assets/play_screenshots/phone');
const outTablet = path.join(root, 'store_listing_assets/play_screenshots/tablet');
const photoDir = path.join(root, 'assets/demo_people');

const photos = {
  vienna: dataUri('vienna_evening_walk.jpg'),
  coffee: dataUri('linz_rain_coffee.jpg'),
  family: dataUri('family_table.jpg'),
  launch: dataUri('first_launch_night.jpg'),
};

const palette = {
  ink: '#09070b',
  deep: '#171018',
  panel: '#1d1720',
  warm: '#2a1e22',
  card: '#fff1d8',
  gold: '#d2a24a',
  amber: '#f2c86b',
  muted: '#c2b6a8',
  text: '#fff8ea',
  line: '#3a2c33',
  paper: '#261c17',
};

const phone = { width: 1080, height: 1920 };
const tablet = { width: 1920, height: 1080 };

const phoneShots = [
  {
    file: '01_wall',
    title: 'Build a private wall',
    subtitle: 'Photos, notes, places, and moments connected by meaning.',
    screen: wallScreen,
  },
  {
    file: '02_create_memory',
    title: 'Capture the story',
    subtitle: 'Save the photo, date, people, feeling, and memory itself.',
    screen: createMemoryScreen,
  },
  {
    file: '03_memory_chapter',
    title: 'Open each chapter',
    subtitle: 'Every memory keeps the story, photos, people, and connections.',
    screen: detailScreen,
  },
  {
    file: '04_timeline',
    title: 'Revisit by time',
    subtitle: 'Switch from the wall to a clean timeline whenever you want.',
    screen: timelineScreen,
  },
  {
    file: '05_map',
    title: 'See where life happened',
    subtitle: 'Photo GPS creates the map. No background tracking needed.',
    screen: mapScreen,
  },
  {
    file: '06_premium',
    title: 'Keep it private',
    subtitle: 'Local-first by default, with backup and lifetime unlock.',
    screen: privacyScreen,
  },
];

const tabletShots = [
  {
    file: '01_wall_tablet',
    title: 'Build a private wall of living memories',
    subtitle: 'Arrange moments visually and connect the ones that belong together.',
    screen: wallScreen,
  },
  {
    file: '02_create_memory_tablet',
    title: 'Capture the story behind every photo',
    subtitle: 'Add people, date, feeling, and story before the moment fades.',
    screen: createMemoryScreen,
  },
  {
    file: '03_memory_chapter_tablet',
    title: 'Open a memory as a chapter',
    subtitle: 'See the photo, story, people, map, and connected memories together.',
    screen: detailScreen,
  },
  {
    file: '04_timeline_tablet',
    title: 'Timeline and map when you need structure',
    subtitle: 'Move from emotional wall to chronological or place-based views.',
    screen: splitTimelineMapScreen,
  },
];

fs.mkdirSync(outPhone, { recursive: true });
fs.mkdirSync(outTablet, { recursive: true });

for (const shot of phoneShots) writeShot(outPhone, shot, phone);
for (const shot of tabletShots) writeShot(outTablet, shot, tablet);

function writeShot(outDir, shot, size) {
  const svg = screenshotSvg(size, shot);
  const svgPath = path.join(outDir, `${shot.file}.svg`);
  const pngPath = path.join(outDir, `${shot.file}.png`);
  fs.writeFileSync(svgPath, svg);
  execFileSync('rsvg-convert', [
    svgPath,
    '--format',
    'png',
    '--output',
    pngPath,
  ]);
}

function screenshotSvg(size, shot) {
  const isPhone = size.width < size.height;
  const frame = isPhone
    ? { x: 62, y: 292, width: 956, height: 1472 }
    : { x: 650, y: 82, width: 1190, height: 916 };
  const titleX = isPhone ? 72 : 80;
  const titleY = isPhone ? 112 : 118;
  const titleWidth = isPhone ? 940 : 540;
  const fontSize = isPhone ? 62 : 54;
  const subtitleSize = isPhone ? 30 : 29;
  const titleLines = wrap(shot.title, isPhone ? 28 : 24);
  const subY = titleY + titleLines.length * fontSize * 1.04 + 18;

  return `<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" width="${size.width}" height="${size.height}" viewBox="0 0 ${size.width} ${size.height}">
  <defs>
    ${baseDefs()}
  </defs>
  ${background(size)}
  ${textBlock(titleX, titleY, titleLines, fontSize, 0.98, 900, palette.text, titleWidth)}
  ${textBlock(titleX, subY, wrap(shot.subtitle, isPhone ? 45 : 36), subtitleSize, 1.25, 800, palette.amber, titleWidth)}
  ${deviceFrame(frame)}
  ${shot.screen(innerFrame(frame), { isPhone, size })}
</svg>`;
}

function baseDefs() {
  return `
  <linearGradient id="bg" x1="0" y1="0" x2="1" y2="1">
    <stop offset="0" stop-color="#07060a"/>
    <stop offset="0.48" stop-color="#150b12"/>
    <stop offset="1" stop-color="#271a10"/>
  </linearGradient>
  <radialGradient id="warmGlow" cx="72%" cy="18%" r="76%">
    <stop offset="0" stop-color="#81591d" stop-opacity="0.46"/>
    <stop offset="0.42" stop-color="#38230f" stop-opacity="0.22"/>
    <stop offset="1" stop-color="#000000" stop-opacity="0"/>
  </radialGradient>
  <pattern id="grid" width="112" height="112" patternUnits="userSpaceOnUse">
    <path d="M112 0H0V112" fill="none" stroke="#ffffff" stroke-opacity="0.045" stroke-width="2"/>
  </pattern>
  <pattern id="paper" width="9" height="9" patternUnits="userSpaceOnUse" patternTransform="rotate(45)">
    <line x1="0" y1="0" x2="0" y2="9" stroke="#7a5a29" stroke-opacity="0.08" stroke-width="1"/>
  </pattern>
  <filter id="shadow" x="-25%" y="-25%" width="150%" height="150%">
    <feDropShadow dx="0" dy="22" stdDeviation="24" flood-color="#000000" flood-opacity="0.42"/>
  </filter>
  <filter id="softShadow" x="-35%" y="-35%" width="170%" height="170%">
    <feDropShadow dx="0" dy="16" stdDeviation="18" flood-color="#000000" flood-opacity="0.34"/>
  </filter>
  <linearGradient id="glass" x1="0" y1="0" x2="1" y2="1">
    <stop offset="0" stop-color="#2a1e22" stop-opacity="0.92"/>
    <stop offset="1" stop-color="#0a070b" stop-opacity="0.84"/>
  </linearGradient>`;
}

function background({ width, height }) {
  return `
  <rect width="${width}" height="${height}" fill="url(#bg)"/>
  <rect width="${width}" height="${height}" fill="url(#warmGlow)"/>
  <rect width="${width}" height="${height}" fill="url(#grid)"/>
  <path d="M${-width * 0.08} ${height * 0.86}C${width * 0.18} ${height * 0.74} ${width * 0.38} ${height * 0.86} ${width * 0.58} ${height * 0.72}C${width * 0.76} ${height * 0.60} ${width * 0.86} ${height * 0.66} ${width * 1.08} ${height * 0.54}" fill="none" stroke="${palette.gold}" stroke-opacity="0.10" stroke-width="${height * 0.045}"/>`;
}

function deviceFrame(frame) {
  const inner = innerFrame(frame);
  return `
  <rect x="${frame.x}" y="${frame.y}" width="${frame.width}" height="${frame.height}" rx="58" fill="#21131a" fill-opacity="0.74" stroke="#4a3425" stroke-width="2" filter="url(#shadow)"/>
  <rect x="${inner.x}" y="${inner.y}" width="${inner.width}" height="${inner.height}" rx="42" fill="#0d1019" fill-opacity="0.52"/>
  <rect x="${inner.x}" y="${inner.y}" width="${inner.width}" height="${inner.height}" rx="42" fill="url(#grid)" opacity="0.55"/>`;
}

function innerFrame(frame) {
  const pad = Math.min(frame.width, frame.height) > 1000 ? 26 : 22;
  return {
    x: frame.x + pad,
    y: frame.y + pad,
    width: frame.width - pad * 2,
    height: frame.height - pad * 2,
  };
}

function wallScreen(r, opts) {
  const sx = r.width / 900;
  const sy = r.height / 1350;
  const cardWidth = opts.isPhone ? 205 : 155;
  const card = (x, y, rotation, title, meta, photo, scale = 1) =>
    memoryCard(r.x + x * sx, r.y + y * sy, cardWidth * sx * scale, title, meta, photo, rotation);
  const positions = opts.isPhone
    ? {
        vienna: [92, 410],
        coffee: [390, 520],
        family: [645, 405],
        launch: [302, 905],
        pill: [58, 1210],
        add: [690, 1225],
      }
    : {
        vienna: [95, 380],
        coffee: [410, 470],
        family: [660, 400],
        launch: [330, 840],
        pill: [70, 1175],
        add: [710, 1185],
      };
  const coffeeScale = opts.isPhone ? 1.05 : 0.92;
  const launchScale = opts.isPhone ? 1 : 0.82;
  return `
  ${wallHeader(r, 'Wall')}
  ${ropePath(r, [
    [190, 390],
    [470, 540],
    [735, 360],
  ], sx, sy)}
  ${ropePath(r, [
    [470, 540],
    [360, 870],
    [650, 980],
  ], sx, sy)}
  ${card(...positions.vienna, -6, 'Vienna evening walk', 'Travel · Vienna', photos.vienna)}
  ${card(...positions.coffee, 4, 'Rain and coffee', 'Personal · Linz', photos.coffee, coffeeScale)}
  ${card(...positions.family, 5, 'Family table', 'Family · Home', photos.family)}
  ${card(...positions.launch, -4, 'First launch night', 'Personal · Linz', photos.launch, launchScale)}
  ${pill(r.x + positions.pill[0] * sx, r.y + positions.pill[1] * sy, 520 * sx, 92 * sy, 'Remember this', 'Vienna evening walk', 'history_edu')}
  ${addButton(r.x + positions.add[0] * sx, r.y + positions.add[1] * sy, 150 * sx, 82 * sy)}
  `;
}

function createMemoryScreen(r) {
  const x = r.x + 58;
  const y = r.y + 92;
  const w = r.width - 116;
  return `
  ${screenTitle(r, 'Create a memory', 'One line is enough. Details can wait.')}
  ${imagePanel(x, y + 150, w, 310, photos.vienna, 28)}
  ${inputRow(x, y + 500, w, 'Title', 'Vienna evening walk')}
  ${inputRow(x, y + 610, w, 'Feeling', 'Warm · Nostalgic')}
  ${inputRow(x, y + 720, w, 'People', 'Lara, Sami')}
  ${storyBox(x, y + 830, w, 240)}
  ${smallChip(x, y + 1108, 'Photo GPS detected')}
  ${smallChip(x + 260, y + 1108, 'Private storage')}
  ${primaryButton(x + w - 230, y + 1210, 230, 76, 'Save')}
  `;
}

function detailScreen(r) {
  const x = r.x + 44;
  const y = r.y + 56;
  const w = r.width - 88;
  return `
  ${imagePanel(x, y, w, 500, photos.vienna, 34)}
  <rect x="${x}" y="${y + 390}" width="${w}" height="250" rx="34" fill="#0a070b" fill-opacity="0.84"/>
  ${text(x + 34, y + 470, 'Vienna evening walk', 42, 900, palette.text)}
  ${text(x + 34, y + 520, 'Travel · nostalgic · Vienna, Austria', 23, 800, palette.muted)}
  ${textBlock(x + 34, y + 604, ['A quiet evening in Vienna, remembered because', 'nothing needed to be perfect.'], 24, 1.25, 750, palette.text, w - 68)}
  ${sectionCard(x, y + 700, w, 'People', 'Lara · Sami · You', 'person')}
  ${sectionCard(x, y + 835, w, 'Connected moments', 'Rain and coffee · First launch night', 'hub')}
  ${sectionCard(x, y + 970, w, 'Place', 'Vienna, Austria from photo GPS', 'map')}
  ${primaryButton(x + w - 250, y + 1130, 250, 76, 'Connect')}
  `;
}

function timelineScreen(r) {
  const x = r.x + 58;
  const y = r.y + 82;
  const w = r.width - 116;
  return `
  ${screenTitle(r, 'Timeline', 'Revisit moments by date.')}
  ${timelineItem(x, y + 180, w, 'May 21, 2024', 'Vienna evening walk', 'Travel · Vienna', photos.vienna)}
  ${timelineItem(x, y + 410, w, 'Nov 4, 2024', 'Rain and coffee', 'Personal · Linz', photos.coffee)}
  ${timelineItem(x, y + 640, w, 'Jan 12, 2025', 'Family table', 'Family · Home', photos.family)}
  ${timelineItem(x, y + 870, w, 'Mar 9, 2025', 'First launch night', 'Personal · Linz', photos.launch)}
  `;
}

function mapScreen(r) {
  const x = r.x + 46;
  const y = r.y + 72;
  const w = r.width - 92;
  const h = r.height - 144;
  return `
  ${screenTitle(r, 'Map', 'Only memories with photo GPS appear here.')}
  <rect x="${x}" y="${y + 132}" width="${w}" height="${h - 132}" rx="38" fill="#172024" stroke="#314844" stroke-width="2"/>
  <path d="M${x + 80} ${y + 680}C${x + 260} ${y + 520} ${x + 340} ${y + 610} ${x + 520} ${y + 420}C${x + 640} ${y + 300} ${x + 710} ${y + 360} ${x + 825} ${y + 235}" fill="none" stroke="#657d70" stroke-width="28" stroke-linecap="round" opacity="0.35"/>
  <path d="M${x + 90} ${y + 290}L${x + 780} ${y + 900}" stroke="#405852" stroke-width="16" opacity="0.24"/>
  ${mapPin(x + 235, y + 430, photos.vienna, 'Vienna')}
  ${mapPin(x + 610, y + 690, photos.coffee, 'Linz')}
  ${mapPin(x + 455, y + 920, photos.launch, 'Launch')}
  <rect x="${x + 46}" y="${y + h - 170}" width="${w - 92}" height="104" rx="30" fill="#0a070b" fill-opacity="0.76" stroke="#4a3425"/>
  ${text(x + 80, y + h - 108, 'No background tracking. Locations come from selected photos.', 24, 820, palette.text)}
  `;
}

function privacyScreen(r) {
  const x = r.x + 58;
  const y = r.y + 94;
  const w = r.width - 116;
  return `
  ${screenTitle(r, 'Backup & privacy', 'Built for memories you control.')}
  ${privacyCard(x, y + 180, w, 'Local-first', 'No account required. Your wall stays on your device by default.')}
  ${privacyCard(x, y + 380, w, 'Cloud Sync', 'Optional encrypted backup using your own sync key and password.')}
  ${privacyCard(x, y + 580, w, 'Display Wall', 'Generate a QR code and show the wall without saving it publicly.')}
  ${privacyCard(x, y + 780, w, 'Lifetime unlock', 'One-time upgrade for unlimited memories and premium wall tools.')}
  ${primaryButton(x + 56, y + 1060, w - 112, 82, 'Ready for your wall')}
  `;
}

function splitTimelineMapScreen(r) {
  const left = { x: r.x + 42, y: r.y + 82, width: (r.width - 110) / 2, height: r.height - 164 };
  const right = { x: left.x + left.width + 26, y: left.y, width: left.width, height: left.height };
  return `
  <rect x="${left.x}" y="${left.y}" width="${left.width}" height="${left.height}" rx="36" fill="#0f1118" fill-opacity="0.72" stroke="#4a3425"/>
  <rect x="${right.x}" y="${right.y}" width="${right.width}" height="${right.height}" rx="36" fill="#162021" fill-opacity="0.72" stroke="#4a3425"/>
  ${text(left.x + 38, left.y + 70, 'Timeline', 34, 900, palette.text)}
  ${timelineItem(left.x + 38, left.y + 110, left.width - 76, 'May 2024', 'Vienna evening walk', 'Travel · Vienna', photos.vienna, 0.72)}
  ${timelineItem(left.x + 38, left.y + 285, left.width - 76, 'Nov 2024', 'Rain and coffee', 'Personal · Linz', photos.coffee, 0.72)}
  ${timelineItem(left.x + 38, left.y + 460, left.width - 76, 'Mar 2025', 'First launch night', 'Personal · Linz', photos.launch, 0.72)}
  ${text(right.x + 38, right.y + 70, 'Map', 34, 900, palette.text)}
  <path d="M${right.x + 90} ${right.y + 520}C${right.x + 240} ${right.y + 360} ${right.x + 350} ${right.y + 420} ${right.x + 480} ${right.y + 210}" fill="none" stroke="#657d70" stroke-width="24" stroke-linecap="round" opacity="0.35"/>
  ${mapPin(right.x + 210, right.y + 300, photos.vienna, 'Vienna', 0.82)}
  ${mapPin(right.x + 420, right.y + 500, photos.coffee, 'Linz', 0.82)}
  `;
}

function wallHeader(r, active) {
  return `
  ${text(r.x + 44, r.y + 72, 'LifeThreads', 36, 900, palette.text)}
  ${text(r.x + 44, r.y + 112, 'Your memories, hanging together.', 21, 760, palette.muted)}
  ${headerPill(r.x + 44, r.y + 152, 172, active === 'Wall', 'Wall')}
  ${headerPill(r.x + 240, r.y + 152, 214, false, 'Timeline')}
  ${headerPill(r.x + 478, r.y + 152, 142, false, 'Map')}
  `;
}

function screenTitle(r, titleValue, subtitleValue) {
  return `
  ${text(r.x + 58, r.y + 82, titleValue, 40, 900, palette.text)}
  ${text(r.x + 58, r.y + 122, subtitleValue, 22, 760, palette.muted)}
  `;
}

function memoryCard(x, y, width, titleValue, meta, photo, rotation = 0) {
  const h = width * 1.2;
  const imgH = width * 0.56;
  return `
  <g transform="translate(${x} ${y}) rotate(${rotation})" filter="url(#softShadow)">
    <rect width="${width}" height="${h}" rx="22" fill="${palette.card}"/>
    <image href="${photo}" x="${width * 0.08}" y="${width * 0.12}" width="${width * 0.84}" height="${imgH}" preserveAspectRatio="xMidYMid slice"/>
    <rect x="${width * 0.08}" y="${width * 0.12}" width="${width * 0.84}" height="${imgH}" rx="15" fill="url(#paper)" opacity="0.22"/>
    <rect x="${width * 0.28}" y="-5" width="${width * 0.40}" height="28" rx="8" fill="#e7d7ad" opacity="0.78"/>
    ${text(width * 0.10, width * 0.12 + imgH + 42, titleValue, Math.max(18, width * 0.092), 900, palette.paper)}
    ${text(width * 0.10, width * 0.12 + imgH + 74, meta, Math.max(14, width * 0.068), 800, '#806e5a')}
  </g>`;
}

function ropePath(r, points, sx, sy) {
  const mapped = points.map(([x, y]) => [r.x + x * sx, r.y + y * sy]);
  const d = mapped
    .map(([x, y], i) => (i === 0 ? `M${x} ${y}` : `S${x - 60 * sx} ${y - 60 * sy} ${x} ${y}`))
    .join(' ');
  return `
  <path d="${d}" fill="none" stroke="#9b713b" stroke-width="${Math.max(5, 8 * sx)}" stroke-linecap="round" opacity="0.82"/>
  ${mapped.map(([x, y]) => `<circle cx="${x}" cy="${y}" r="${12 * sx}" fill="${palette.amber}" stroke="${palette.text}" stroke-width="${4 * sx}"/>`).join('')}`;
}

function headerPill(x, y, w, active, label) {
  return `<rect x="${x}" y="${y}" width="${w}" height="64" rx="32" fill="${active ? palette.gold : '#2a1a20'}" stroke="#56372a" stroke-width="2"/>
  ${text(x + w / 2, y + 41, label, 23, 900, active ? '#1d150b' : palette.muted, 'middle')}`;
}

function pill(x, y, w, h, label, titleValue) {
  return `<rect x="${x}" y="${y}" width="${w}" height="${h}" rx="${h / 2}" fill="#08070a" fill-opacity="0.86" stroke="#4a3425"/>
  ${text(x + 92, y + 34, label, 18, 900, palette.gold)}
  ${text(x + 92, y + 68, titleValue, 26, 900, palette.text)}`;
}

function addButton(x, y, w, h) {
  return `<rect x="${x}" y="${y}" width="${w}" height="${h}" rx="28" fill="${palette.gold}"/>
  ${text(x + w / 2, y + h / 2 + 10, '+ Add', 26, 900, '#1d150b', 'middle')}`;
}

function inputRow(x, y, w, label, value) {
  return `<rect x="${x}" y="${y}" width="${w}" height="86" rx="24" fill="${palette.warm}" stroke="${palette.line}"/>
  ${text(x + 28, y + 34, label, 18, 800, palette.gold)}
  ${text(x + 28, y + 66, value, 25, 900, palette.text)}`;
}

function storyBox(x, y, w, h) {
  return `<rect x="${x}" y="${y}" width="${w}" height="${h}" rx="26" fill="${palette.warm}" stroke="${palette.line}"/>
  ${text(x + 28, y + 38, 'Story', 18, 800, palette.gold)}
  ${textBlock(x + 28, y + 80, ['A quiet evening in Vienna, the kind of', 'moment that stays warm because nothing', 'needed to be perfect.'], 25, 1.35, 760, palette.text, w - 56)}`;
}

function imagePanel(x, y, w, h, photo, rx) {
  return `<rect x="${x}" y="${y}" width="${w}" height="${h}" rx="${rx}" fill="${palette.panel}" stroke="${palette.line}" filter="url(#softShadow)"/>
  <image href="${photo}" x="${x}" y="${y}" width="${w}" height="${h}" preserveAspectRatio="xMidYMid slice" opacity="0.96"/>
  <rect x="${x}" y="${y}" width="${w}" height="${h}" rx="${rx}" fill="#000000" opacity="0.12"/>`;
}

function sectionCard(x, y, w, titleValue, subtitleValue) {
  return `<rect x="${x}" y="${y}" width="${w}" height="104" rx="28" fill="${palette.panel}" fill-opacity="0.92" stroke="${palette.line}"/>
  ${text(x + 30, y + 40, titleValue, 21, 900, palette.gold)}
  ${text(x + 30, y + 72, subtitleValue, 25, 850, palette.text)}`;
}

function timelineItem(x, y, w, date, titleValue, meta, photo, scale = 1) {
  const h = 178 * scale;
  const img = 116 * scale;
  return `<rect x="${x}" y="${y}" width="${w}" height="${h}" rx="${26 * scale}" fill="${palette.panel}" fill-opacity="0.88" stroke="${palette.line}"/>
  <image href="${photo}" x="${x + 20 * scale}" y="${y + 24 * scale}" width="${img}" height="${img}" preserveAspectRatio="xMidYMid slice"/>
  ${text(x + 156 * scale, y + 50 * scale, date, 19 * scale, 900, palette.gold)}
  ${text(x + 156 * scale, y + 92 * scale, titleValue, 28 * scale, 900, palette.text)}
  ${text(x + 156 * scale, y + 130 * scale, meta, 20 * scale, 800, palette.muted)}`;
}

function mapPin(x, y, photo, label, scale = 1) {
  const size = 92 * scale;
  return `<circle cx="${x}" cy="${y}" r="${22 * scale}" fill="${palette.gold}" stroke="${palette.text}" stroke-width="${4 * scale}"/>
  <rect x="${x + 26 * scale}" y="${y - 36 * scale}" width="${size}" height="${size}" rx="${22 * scale}" fill="${palette.card}" filter="url(#softShadow)"/>
  <image href="${photo}" x="${x + 34 * scale}" y="${y - 28 * scale}" width="${size - 16 * scale}" height="${size - 16 * scale}" preserveAspectRatio="xMidYMid slice"/>
  ${text(x + 30 * scale, y + 82 * scale, label, 18 * scale, 900, palette.text)}`;
}

function privacyCard(x, y, w, titleValue, subtitleValue) {
  return `<rect x="${x}" y="${y}" width="${w}" height="150" rx="30" fill="${palette.panel}" fill-opacity="0.9" stroke="${palette.line}"/>
  <circle cx="${x + 56}" cy="${y + 75}" r="26" fill="${palette.gold}" fill-opacity="0.20" stroke="${palette.gold}"/>
  ${text(x + 102, y + 60, titleValue, 28, 900, palette.text)}
  ${textBlock(x + 102, y + 96, wrap(subtitleValue, 42), 20, 1.25, 760, palette.muted, w - 132)}`;
}

function smallChip(x, y, label) {
  return `<rect x="${x}" y="${y}" width="220" height="50" rx="25" fill="#0a070b" stroke="${palette.line}"/>
  ${text(x + 110, y + 33, label, 18, 850, palette.amber, 'middle')}`;
}

function primaryButton(x, y, w, h, label) {
  return `<rect x="${x}" y="${y}" width="${w}" height="${h}" rx="${h / 2}" fill="${palette.gold}" filter="url(#softShadow)"/>
  ${text(x + w / 2, y + h / 2 + 10, label, 25, 900, '#1d150b', 'middle')}`;
}

function text(x, y, value, size, weight, color, anchor = 'start') {
  return `<text x="${x}" y="${y}" text-anchor="${anchor}" font-family="Inter, Arial, sans-serif" font-size="${size}" font-weight="${weight}" fill="${color}">${escapeXml(value)}</text>`;
}

function textBlock(x, y, lines, size, lineHeight, weight, color) {
  return lines
    .map((line, index) => text(x, y + index * size * lineHeight, line, size, weight, color))
    .join('\n');
}

function wrap(value, max) {
  const words = value.split(/\s+/);
  const lines = [];
  let line = '';
  for (const word of words) {
    const next = line ? `${line} ${word}` : word;
    if (next.length > max && line) {
      lines.push(line);
      line = word;
    } else {
      line = next;
    }
  }
  if (line) lines.push(line);
  return lines;
}

function dataUri(file) {
  const bytes = fs.readFileSync(path.join(photoDir, file));
  return `data:image/jpeg;base64,${bytes.toString('base64')}`;
}

function escapeXml(value) {
  return String(value)
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;');
}
