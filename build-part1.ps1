$root="ArtWebsite"
$dirs=@("$root","$root/css","$root/js","$root/data","$root/images","$root/images/logo","$root/images/icons","$root/images/series")
$dirs|ForEach-Object{New-Item -ItemType Directory -Force -Path $_|Out-Null}
function W($p,$c){Set-Content -Path $p -Value $c -Encoding UTF8}

W "$root/index.html" @'
<!--
==================================================
index.html
Purpose: Homepage for the CSV-powered artist portfolio.
==================================================
-->
<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Elena Marlow Studio</title><meta name="description" content="Contemporary artist portfolio powered by editable CSV files."><meta property="og:title" content="Elena Marlow Studio"><meta property="og:type" content="website"><meta property="og:image" content="images/logo/social-preview.svg"><meta name="twitter:card" content="summary_large_image"><link rel="icon" href="images/logo/favicon.svg" type="image/svg+xml"><link rel="preconnect" href="https://fonts.googleapis.com"><link rel="preconnect" href="https://fonts.gstatic.com" crossorigin><link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Playfair+Display:wght@600;700&display=swap" rel="stylesheet"><link rel="stylesheet" href="css/style.css"><link rel="stylesheet" href="css/gallery.css"><link rel="stylesheet" href="css/animations.css"><link rel="stylesheet" href="css/mobile.css"></head><body data-page="home"><a class="skip-link" href="#main">Skip to content</a><header class="site-header"><nav class="site-nav"><a class="brand" href="index.html"><img src="images/logo/favicon.svg" alt=""><span>Elena Marlow</span></a><button class="nav-toggle" data-nav-toggle aria-label="Menu"><span></span><span></span><span></span></button><div class="nav-links" data-nav-links><a href="index.html">Home</a><a href="gallery.html">Gallery</a><a href="about.html">About</a><a href="contact.html">Contact</a><a href="https://www.instagram.com/" target="_blank" rel="noopener">Instagram</a></div></nav></header><main id="main"><section class="hero"><div class="hero-wall" data-hero-wall></div><div class="hero-copy reveal"><p class="eyebrow">Contemporary Painting / Works on Paper / Mixed Media</p><h1>Elena Marlow Studio</h1><p>Quiet, tactile works exploring architecture, memory, weather, and the emotional charge of ordinary places.</p><a class="button dark" href="gallery.html">View Gallery</a><a class="button light" href="contact.html">Request Availability</a></div></section><section class="section"><p class="eyebrow">Selected Work</p><h2>Featured Artwork</h2><div data-featured-artwork></div></section><section class="section soft"><p class="eyebrow">Bodies of Work</p><h2>Featured Series</h2><div class="series-grid" data-featured-series></div></section><section class="section"><p class="eyebrow">Recently Added</p><h2>Latest Artworks</h2><div class="artwork-grid" data-latest-artworks></div></section><section class="statement reveal"><p class="eyebrow">Artist Statement</p><h2>I build images from remembered thresholds, windows after rain, stairwells at dusk, and rooms that hold the shape of someone just gone.</h2><p>Layered paint, scraped surfaces, and translucent veils create a record of revision and return.</p></section></main><footer><strong>Elena Marlow Studio</strong><p>Static portfolio. Edit CSV files to update the site.</p></footer><script src="js/utils.js"></script><script src="js/csv.js"></script><script src="js/menu.js"></script><script src="js/main.js"></script></body></html>
'@

W "$root/gallery.html" @'
<!--
==================================================
gallery.html
Purpose: Dynamic gallery page with search, filters, and sorting.
==================================================
-->
<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Gallery | Elena Marlow Studio</title><meta name="description" content="Browse artworks by series, medium, year, price, availability, tags, and orientation."><link rel="icon" href="images/logo/favicon.svg" type="image/svg+xml"><link rel="stylesheet" href="css/style.css"><link rel="stylesheet" href="css/gallery.css"><link rel="stylesheet" href="css/animations.css"><link rel="stylesheet" href="css/mobile.css"></head><body data-page="gallery"><header class="site-header"><nav class="site-nav"><a class="brand" href="index.html"><img src="images/logo/favicon.svg" alt=""><span>Elena Marlow</span></a><button class="nav-toggle" data-nav-toggle aria-label="Menu"><span></span><span></span><span></span></button><div class="nav-links" data-nav-links><a href="index.html">Home</a><a href="gallery.html">Gallery</a><a href="about.html">About</a><a href="contact.html">Contact</a><a href="https://www.instagram.com/" target="_blank">Instagram</a></div></nav></header><main class="page"><section class="intro reveal"><p class="eyebrow">Archive</p><h1>Gallery</h1><p>Search the full catalog or filter by artwork details.</p></section><section class="gallery-layout"><aside class="filters reveal"><label>Search<input data-search-input type="search" placeholder="Title, tags, medium..."></label><label>Series<select data-filter="series"><option value="">All series</option></select></label><label>Medium<select data-filter="medium"><option value="">All media</option></select></label><label>Year<select data-filter="year"><option value="">All years</option></select></label><label>Availability<select data-filter="availability"><option value="">Any</option></select></label><label>Orientation<select data-filter="orientation"><option value="">Any</option></select></label><label>Minimum width<input data-filter="minWidth" type="number" min="0"></label><label>Minimum height<input data-filter="minHeight" type="number" min="0"></label><label>Minimum price<input data-filter="minPrice" type="number" min="0"></label><label>Maximum price<input data-filter="maxPrice" type="number" min="0"></label><label>Tag contains<input data-filter="tag" type="text"></label><button class="button light" data-clear-filters>Clear Filters</button></aside><section class="results"><div class="toolbar reveal"><p data-result-count>Loading artworks...</p><select data-sort-select><option value="newest">Newest</option><option value="oldest">Oldest</option><option value="alphabetical">Alphabetical</option><option value="priceLow">Price Low to High</option><option value="priceHigh">Price High to Low</option><option value="random">Random</option></select></div><div class="series-strip" data-series-strip></div><div class="artwork-grid" data-gallery-grid></div></section></section></main><footer><strong>Elena Marlow Studio</strong></footer><script src="js/utils.js"></script><script src="js/csv.js"></script><script src="js/search.js"></script><script src="js/filters.js"></script><script src="js/menu.js"></script><script src="js/gallery.js"></script></body></html>
'@

W "$root/artwork.html" @'
<!--
==================================================
artwork.html
Purpose: Single artwork page with thumbnails, lightbox, metadata, and related works.
==================================================
-->
<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Artwork | Elena Marlow Studio</title><meta name="description" content="Artwork detail page."><link rel="icon" href="images/logo/favicon.svg" type="image/svg+xml"><link rel="stylesheet" href="css/style.css"><link rel="stylesheet" href="css/artwork.css"><link rel="stylesheet" href="css/mobile.css"></head><body data-page="artwork"><header class="site-header"><nav class="site-nav"><a class="brand" href="index.html"><img src="images/logo/favicon.svg" alt=""><span>Elena Marlow</span></a><button class="nav-toggle" data-nav-toggle aria-label="Menu"><span></span><span></span><span></span></button><div class="nav-links" data-nav-links><a href="index.html">Home</a><a href="gallery.html">Gallery</a><a href="about.html">About</a><a href="contact.html">Contact</a><a href="https://www.instagram.com/" target="_blank">Instagram</a></div></nav></header><main class="page"><section data-artwork-detail></section></main><footer><strong>Elena Marlow Studio</strong></footer><script src="js/utils.js"></script><script src="js/csv.js"></script><script src="js/lightbox.js"></script><script src="js/menu.js"></script><script src="js/artwork.js"></script></body></html>
'@

W "$root/about.html" @'
<!--
==================================================
about.html
Purpose: Artist biography, statement, process, and exhibition information.
==================================================
-->
<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>About | Elena Marlow Studio</title><meta name="description" content="Artist biography and statement."><link rel="stylesheet" href="css/style.css"><link rel="stylesheet" href="css/mobile.css"></head><body><header class="site-header"><nav class="site-nav"><a class="brand" href="index.html">Elena Marlow</a><button class="nav-toggle" data-nav-toggle><span></span><span></span><span></span></button><div class="nav-links" data-nav-links><a href="index.html">Home</a><a href="gallery.html">Gallery</a><a href="about.html">About</a><a href="contact.html">Contact</a></div></nav></header><main class="page narrow reveal"><p class="eyebrow">About</p><h1>Elena Marlow makes atmospheric works about architecture, memory, and emotional weather.</h1><p>The paintings begin as observations from walks, train windows, studio notes, and small acts of looking. Their finished surfaces balance clarity and erasure.</p><p>Each work is built slowly through staining, drawing, scraping, and repainting. The process leaves visible evidence of time, allowing the final image to feel found rather than declared.</p><h2>Selected Exhibitions</h2><p><strong>2026</strong> Threshold Light, Northline Gallery</p><p><strong>2025</strong> Soft Architecture, Studio Room Project</p><p><strong>2024</strong> Weather Inside, Independent Works Fair</p></main><script src="js/menu.js"></script><script src="js/main.js"></script></body></html>
'@

W "$root/contact.html" @'
<!--
==================================================
contact.html
Purpose: Studio contact page for collectors, curators, and press.
==================================================
-->
<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Contact | Elena Marlow Studio</title><meta name="description" content="Contact the studio."><link rel="stylesheet" href="css/style.css"><link rel="stylesheet" href="css/mobile.css"></head><body><header class="site-header"><nav class="site-nav"><a class="brand" href="index.html">Elena Marlow</a><button class="nav-toggle" data-nav-toggle><span></span><span></span><span></span></button><div class="nav-links" data-nav-links><a href="index.html">Home</a><a href="gallery.html">Gallery</a><a href="about.html">About</a><a href="contact.html">Contact</a></div></nav></header><main class="page narrow reveal"><p class="eyebrow">Contact</p><h1>Artwork inquiries, exhibitions, press, and studio visits.</h1><p>Email <a href="mailto:hello@elenamarlowstudio.com">hello@elenamarlowstudio.com</a> and include the artwork title or series name.</p><form class="contact-form" action="mailto:hello@elenamarlowstudio.com" method="post" enctype="text/plain"><label>Name<input name="name" required></label><label>Email<input name="email" type="email" required></label><label>Subject<input name="subject" required></label><label>Message<textarea name="message" rows="7" required></textarea></label><button class="button dark">Send Inquiry</button></form></main><script src="js/menu.js"></script><script src="js/main.js"></script></body></html>
'@

W "$root/404.html" @'
<!--
==================================================
404.html
Purpose: GitHub Pages not-found page.
==================================================
-->
<!doctype html><html lang="en"><head><meta charset="utf-8"><title>Not Found | Elena Marlow Studio</title><link rel="stylesheet" href="css/style.css"></head><body><main class="page narrow"><p class="eyebrow">404</p><h1>This page is not in the archive.</h1><a class="button dark" href="gallery.html">Return to Gallery</a></main></body></html>
'@

W "$root/css/style.css" @'
/*
==================================================
style.css
Purpose: Main typography, layout, navigation, cards, footer, and shared visual system.
==================================================
*/
:root{--ink:#111;--muted:#666;--paper:#fff;--soft:#f6f2ec;--line:#e7dfd6;--accent:#8d5d45;--shadow:0 18px 60px rgba(0,0,0,.08)}*{box-sizing:border-box}html{scroll-behavior:smooth}body{margin:0;font-family:Inter,Arial,sans-serif;color:var(--ink);background:var(--paper);line-height:1.6}img{max-width:100%;display:block}a{color:inherit}.skip-link{position:absolute;left:-999px}.skip-link:focus{left:12px;top:12px;background:#fff;padding:10px;z-index:99}.site-header{position:sticky;top:0;z-index:20;background:rgba(255,255,255,.9);backdrop-filter:blur(18px);border-bottom:1px solid var(--line)}.site-nav{height:72px;max-width:1180px;margin:auto;padding:0 24px;display:flex;align-items:center;justify-content:space-between}.brand{display:flex;gap:10px;align-items:center;text-decoration:none;font-weight:800}.brand img{width:34px;height:34px}.nav-links{display:flex;gap:24px}.nav-links a{text-decoration:none;font-weight:700;font-size:14px}.nav-toggle{display:none;background:none;border:0}.nav-toggle span{display:block;width:25px;height:2px;background:#111;margin:5px}.hero{min-height:calc(100vh - 72px);position:relative;display:grid;align-items:end;padding:8vw;overflow:hidden}.hero-wall{position:absolute;inset:0;display:grid;grid-template-columns:repeat(6,1fr);gap:14px;opacity:.24;transform:rotate(-4deg) scale(1.12)}.wall-tile{min-height:190px;background:linear-gradient(135deg,#d8c4b2,#52656b);animation:float 8s ease-in-out infinite}.hero-copy{position:relative;max-width:850px}.eyebrow{text-transform:uppercase;letter-spacing:.14em;font-size:12px;font-weight:800;color:var(--accent)}h1,h2{font-family:"Playfair Display",Georgia,serif;line-height:1.02;margin:0 0 22px}h1{font-size:clamp(48px,8vw,108px)}h2{font-size:clamp(34px,5vw,64px)}.hero p{font-size:20px;max-width:660px}.button{display:inline-flex;align-items:center;justify-content:center;margin:8px 8px 0 0;padding:13px 20px;border:1px solid #111;border-radius:999px;text-decoration:none;font-weight:800;transition:.2s}.button:hover{transform:translateY(-2px)}.dark{background:#111;color:#fff}.light{background:#fff;color:#111}.section{padding:92px 24px;max-width:1180px;margin:auto}.soft{max-width:none;background:var(--soft)}.soft>*{max-width:1180px;margin-left:auto;margin-right:auto}.statement{padding:92px 24px;max-width:900px;margin:auto}.artwork-grid,.series-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(230px,1fr));gap:24px}.card{border:1px solid var(--line);background:#fff;border-radius:8px;overflow:hidden;box-shadow:var(--shadow);text-decoration:none}.card figure{margin:0;aspect-ratio:4/5;background:var(--soft);overflow:hidden}.card img{width:100%;height:100%;object-fit:cover;transition:.4s}.card:hover img{transform:scale(1.04)}.card-body{padding:18px}.card h3{margin:0 0 4px}.muted{color:var(--muted)}.page{max-width:1180px;margin:auto;padding:72px 24px}.narrow{max-width:820px}.contact-form{display:grid;gap:16px;margin-top:30px}.contact-form label{font-weight:700}input,select,textarea{width:100%;padding:12px;border:1px solid var(--line);border-radius:6px;background:#fff;font:inherit}.placeholder-image{width:100%;height:100%;display:grid;place-items:center;background:linear-gradient(135deg,#eee0d2,#566c74);color:#fff;font-weight:800;text-align:center;padding:20px}footer{border-top:1px solid var(--line);padding:44px 24px;display:flex;justify-content:space-between;gap:20px}
'@

W "$root/css/gallery.css" @'
/*
==================================================
gallery.css
Purpose: Gallery controls, filter panel, series strip, and result layout.
==================================================
*/
.gallery-layout{display:grid;grid-template-columns:280px 1fr;gap:34px}.filters{position:sticky;top:92px;align-self:start;border:1px solid var(--line);border-radius:8px;padding:18px;background:#fff}.filters label{display:block;margin-bottom:14px;font-size:13px;font-weight:800}.toolbar{display:flex;align-items:center;justify-content:space-between;gap:18px;margin-bottom:24px}.series-strip{display:flex;gap:12px;overflow:auto;margin-bottom:26px;padding-bottom:4px}.chip{border:1px solid var(--line);background:#fff;border-radius:999px;padding:9px 14px;white-space:nowrap;cursor:pointer;font-weight:700}.chip.active{background:#111;color:#fff}.featured-card{display:grid;grid-template-columns:1fr 1fr;gap:34px;align-items:center}.featured-card figure{aspect-ratio:1/1;background:var(--soft);margin:0;overflow:hidden}.featured-card img{width:100%;height:100%;object-fit:cover}
'@

W "$root/css/artwork.css" @'
/*
==================================================
artwork.css
Purpose: Single artwork page, metadata, thumbnails, lightbox, and related artworks.
==================================================
*/
.artwork-detail{display:grid;grid-template-columns:minmax(0,1.15fr) minmax(320px,.85fr);gap:48px}.main-art{aspect-ratio:4/5;background:var(--soft);cursor:zoom-in;margin:0}.main-art img{width:100%;height:100%;object-fit:cover}.thumbs{display:flex;gap:10px;margin-top:12px;overflow:auto}.thumbs button{width:76px;height:76px;border:1px solid var(--line);background:#fff;padding:0;cursor:pointer}.thumbs img{width:100%;height:100%;object-fit:cover}.meta{display:grid;grid-template-columns:1fr 1fr;gap:10px;margin:24px 0}.tag{display:inline-block;border:1px solid var(--line);padding:5px 9px;border-radius:999px;margin:4px}.lightbox{position:fixed;inset:0;background:rgba(0,0,0,.9);z-index:80;display:grid;place-items:center;padding:30px}.lightbox img{max-width:92vw;max-height:84vh}.lightbox button{position:absolute;top:18px;right:18px}
'@

W "$root/css/animations.css" @'
/*
==================================================
animations.css
Purpose: Subtle reveal, hover, navigation, and loading animations.
==================================================
*/
.reveal{opacity:0;transform:translateY(18px);transition:.7s ease}.reveal.visible{opacity:1;transform:none}@keyframes float{50%{transform:translateY(-18px)}}@media(prefers-reduced-motion:reduce){*{animation:none!important;transition:none!important;scroll-behavior:auto!important}}
'@

W "$root/css/mobile.css" @'
/*
==================================================
mobile.css
Purpose: Responsive tablet and phone layout rules.
==================================================
*/
@media(max-width:820px){.nav-toggle{display:block}.nav-links{position:absolute;top:72px;left:0;right:0;background:#fff;border-bottom:1px solid var(--line);display:none;flex-direction:column;padding:20px 24px}.nav-links.open{display:flex}.hero{padding:96px 22px}.hero-wall{grid-template-columns:repeat(3,1fr)}.gallery-layout,.artwork-detail,.featured-card{grid-template-columns:1fr}.filters{position:static}.toolbar{display:block}.meta{grid-template-columns:1fr}.section,.page{padding-left:18px;padding-right:18px}footer{display:block}h1{font-size:46px}}
'@

W "$root/images/logo/favicon.svg" @'
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 96 96"><rect width="96" height="96" rx="18" fill="#111"/><path d="M24 70 46 18h6l20 52h-9l-5-14H39l-6 14h-9Zm18-22h13l-6-18-7 18Z" fill="#fff"/></svg>
'@

W "$root/images/logo/social-preview.svg" @'
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1200 630"><rect width="1200" height="630" fill="#f6f2ec"/><rect x="90" y="80" width="360" height="470" fill="#d8c4b2"/><rect x="410" y="120" width="300" height="390" fill="#586b70"/><text x="760" y="280" font-family="Georgia" font-size="74" fill="#111">Elena Marlow</text><text x="764" y="340" font-family="Arial" font-size="26" fill="#8d5d45">Contemporary Artist Portfolio</text></svg>
'@

W "$root/robots.txt" "User-agent: *`nAllow: /`n`nSitemap: https://example.com/sitemap.xml"
W "$root/sitemap.xml" "<?xml version=""1.0"" encoding=""UTF-8""?><urlset xmlns=""http://www.sitemaps.org/schemas/sitemap/0.9""><url><loc>https://example.com/index.html</loc></url><url><loc>https://example.com/gallery.html</loc></url><url><loc>https://example.com/about.html</loc></url><url><loc>https://example.com/contact.html</loc></url></urlset>"

Write-Host "Success: build-part1.ps1 created HTML, CSS, SEO, and logo files."