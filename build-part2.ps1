$root="ArtWebsite"
function W($p,$c){Set-Content -Path $p -Value $c -Encoding UTF8}

W "$root/js/utils.js" @'
/*
==================================================
utils.js
Purpose: Shared helpers for formatting, links, images, cards, and reveal animations.
==================================================
*/
const StudioUtils=(()=>{function money(v){const n=Number(v||0);return n?new Intl.NumberFormat("en-US",{style:"currency",currency:"USD",maximumFractionDigits:0}).format(n):"Price on request"}function params(){return new URLSearchParams(location.search)}function fallback(title){const d=document.createElement("div");d.className="placeholder-image";d.textContent=title;return d}function image(src,alt){const img=document.createElement("img");img.loading="lazy";img.src=src;img.alt=alt;img.onerror=()=>img.replaceWith(fallback(alt));return img}function card(a){const link=document.createElement("a");link.className="card";link.href=`artwork.html?id=${encodeURIComponent(a.ID)}`;const fig=document.createElement("figure");fig.append(image(a.CoverImage,a.Title));const body=document.createElement("div");body.className="card-body";body.innerHTML=`<h3>${a.Title}</h3><p class="muted">${a.Series} / ${a.Year}</p><p>${money(a.Price)} - ${a.Availability}</p>`;link.append(fig,body);return link}function reveal(){document.querySelectorAll(".reveal").forEach(el=>{const obs=new IntersectionObserver(entries=>entries.forEach(e=>{if(e.isIntersecting)e.target.classList.add("visible")}));obs.observe(el)})}return{money,params,image,card,reveal}})();
'@

W "$root/js/csv.js" @'
/*
==================================================
csv.js
Purpose: Load CSV files and convert them into artwork, series, and featured objects.
==================================================
*/
const StudioData=(()=>{function parse(text){const rows=[];let row=[],cell="",q=false;for(let i=0;i<text.length;i++){const c=text[i],n=text[i+1];if(c=='"'&&q&&n=='"'){cell+='"';i++}else if(c=='"'){q=!q}else if(c==","&&!q){row.push(cell);cell=""}else if((c=="\n"||c=="\r")&&!q){if(cell||row.length){row.push(cell);rows.push(row);row=[];cell=""}if(c=="\r"&&n=="\n")i++}else cell+=c}if(cell||row.length){row.push(cell);rows.push(row)}const head=rows.shift().map(h=>h.trim());return rows.filter(r=>r.length).map(r=>Object.fromEntries(head.map((h,i)=>[h,(r[i]||"").trim()])))}
async function loadCsv(path){const r=await fetch(path);if(!r.ok)throw new Error(`Could not load ${path}`);return parse(await r.text())}
async function loadAll(){const [artworks,series,featured]=await Promise.all([loadCsv("data/artworks.csv"),loadCsv("data/series.csv"),loadCsv("data/featured.csv")]);artworks.forEach(a=>{a.Images=[a.CoverImage,a.Image2,a.Image3,a.Image4,a.Image5].filter(Boolean);a.PriceNumber=Number(a.Price||0);a.WidthNumber=Number(a.Width||0);a.HeightNumber=Number(a.Height||0)});return{artworks,series,featured}}return{loadAll}})();
'@

W "$root/js/menu.js" @'
/*
==================================================
menu.js
Purpose: Mobile navigation toggle behavior.
==================================================
*/
document.addEventListener("click",event=>{const button=event.target.closest("[data-nav-toggle]");if(!button)return;const links=document.querySelector("[data-nav-links]");links.classList.toggle("open");button.setAttribute("aria-expanded",links.classList.contains("open"))});
'@

W "$root/js/search.js" @'
/*
==================================================
search.js
Purpose: Instant search across title, description, tags, medium, series, year, and price.
==================================================
*/
const StudioSearch={matches(art,term){if(!term)return true;const text=[art.Title,art.Description,art.Tags,art.Medium,art.Series,art.Year,art.Price].join(" ").toLowerCase();return text.includes(term.toLowerCase())}};
'@

W "$root/js/filters.js" @'
/*
==================================================
filters.js
Purpose: Multi-filter and sorting logic for gallery results.
==================================================
*/
const StudioFilters={apply(items,state){return items.filter(a=>(!state.series||a.Series===state.series)&&(!state.medium||a.Medium===state.medium)&&(!state.year||a.Year===state.year)&&(!state.availability||a.Availability===state.availability)&&(!state.orientation||a.Orientation===state.orientation)&&(!state.tag||a.Tags.toLowerCase().includes(state.tag.toLowerCase()))&&(!state.minWidth||a.WidthNumber>=Number(state.minWidth))&&(!state.minHeight||a.HeightNumber>=Number(state.minHeight))&&(!state.minPrice||a.PriceNumber>=Number(state.minPrice))&&(!state.maxPrice||a.PriceNumber<=Number(state.maxPrice))).filter(a=>StudioSearch.matches(a,state.search))},sort(items,mode){const a=[...items];if(mode==="oldest")return a.sort((x,y)=>x.Year-y.Year);if(mode==="alphabetical")return a.sort((x,y)=>x.Title.localeCompare(y.Title));if(mode==="priceLow")return a.sort((x,y)=>x.PriceNumber-y.PriceNumber);if(mode==="priceHigh")return a.sort((x,y)=>y.PriceNumber-x.PriceNumber);if(mode==="random")return a.sort(()=>Math.random()-.5);return a.sort((x,y)=>y.Year-x.Year)}};
'@

W "$root/js/lightbox.js" @'
/*
==================================================
lightbox.js
Purpose: Accessible lightweight image lightbox with click-to-close behavior.
==================================================
*/
const StudioLightbox={open(src,alt){const box=document.createElement("div");box.className="lightbox";box.innerHTML=`<button class="button light" type="button">Close</button><img src="${src}" alt="${alt}">`;box.addEventListener("click",e=>{if(e.target===box||e.target.tagName==="BUTTON")box.remove()});document.addEventListener("keydown",function esc(e){if(e.key==="Escape"){box.remove();document.removeEventListener("keydown",esc)}});document.body.append(box)}};
'@

W "$root/js/main.js" @'
/*
==================================================
main.js
Purpose: Homepage CSV rendering, featured artwork, series, latest works, and reveal setup.
==================================================
*/
StudioData?.loadAll?.().then(({artworks,series,featured})=>{const wall=document.querySelector("[data-hero-wall]");if(wall){artworks.slice(0,18).forEach((a,i)=>{const tile=document.createElement("div");tile.className="wall-tile";tile.style.animationDelay=`${i*.18}s`;wall.append(tile)})}const pick=artworks.find(a=>a.ID===featured[0]?.ArtworkID)||artworks[0];const featuredBox=document.querySelector("[data-featured-artwork]");if(featuredBox&&pick){featuredBox.className="featured-card";const fig=document.createElement("figure");fig.append(StudioUtils.image(pick.CoverImage,pick.Title));const copy=document.createElement("div");copy.innerHTML=`<p class="eyebrow">${pick.Series}</p><h2>${pick.Title}</h2><p>${pick.Description}</p><p>${pick.Medium}, ${pick.Width} x ${pick.Height} in, ${pick.Year}</p><a class="button dark" href="artwork.html?id=${pick.ID}">View Artwork</a>`;featuredBox.append(fig,copy)}const seriesGrid=document.querySelector("[data-featured-series]");series.slice(0,5).forEach(s=>{const card=document.createElement("a");card.className="card";card.href=`gallery.html?series=${encodeURIComponent(s.Series)}`;card.innerHTML=`<div class="card-body"><p class="eyebrow">${s.Featured}</p><h3>${s.Series}</h3><p>${s.Description}</p></div>`;seriesGrid?.append(card)});const latest=document.querySelector("[data-latest-artworks]");artworks.slice().sort((a,b)=>b.Year-a.Year).slice(0,8).forEach(a=>latest?.append(StudioUtils.card(a)))}).finally(()=>StudioUtils?.reveal?.());
'@

W "$root/js/gallery.js" @'
/*
==================================================
gallery.js
Purpose: Build gallery page from CSV data and connect filters, search, and sorting.
==================================================
*/
StudioData.loadAll().then(({artworks,series})=>{const grid=document.querySelector("[data-gallery-grid]"),count=document.querySelector("[data-result-count]"),sort=document.querySelector("[data-sort-select]"),search=document.querySelector("[data-search-input]"),controls=[...document.querySelectorAll("[data-filter]")];function fieldName(key){return{series:"Series",medium:"Medium",year:"Year",availability:"Availability",orientation:"Orientation"}[key]}function fill(key){const el=document.querySelector(`[data-filter="${key}"]`);if(!el||el.tagName!=="SELECT")return;[...new Set(artworks.map(a=>a[fieldName(key)]).filter(Boolean))].sort().forEach(v=>el.add(new Option(v,v)))}["series","medium","year","availability","orientation"].forEach(fill);const strip=document.querySelector("[data-series-strip]");series.forEach(s=>{const b=document.createElement("button");b.className="chip";b.textContent=s.Series;b.onclick=()=>{document.querySelector('[data-filter="series"]').value=s.Series;render()};strip?.append(b)});function state(){const s=Object.fromEntries(controls.map(c=>[c.dataset.filter,c.value]));s.search=search.value;return s}function render(){grid.innerHTML="";const results=StudioFilters.sort(StudioFilters.apply(artworks,state()),sort.value);count.textContent=`${results.length} artwork${results.length===1?"":"s"}`;results.forEach(a=>grid.append(StudioUtils.card(a)))}document.addEventListener("input",e=>{if(e.target.matches("[data-filter],[data-search-input],[data-sort-select]"))render()});document.querySelector("[data-clear-filters]").onclick=()=>{controls.forEach(c=>c.value="");search.value="";render()};const initial=StudioUtils.params().get("series");if(initial)document.querySelector('[data-filter="series"]').value=initial;render();StudioUtils.reveal()});
'@

W "$root/js/artwork.js" @'
/*
==================================================
artwork.js
Purpose: Render the selected artwork, thumbnail gallery, lightbox, metadata, and related artworks.
==================================================
*/
StudioData.loadAll().then(({artworks})=>{const id=StudioUtils.params().get("id")||artworks[0].ID;const art=artworks.find(a=>a.ID===id)||artworks[0];document.title=`${art.Title} | Elena Marlow Studio`;const shell=document.querySelector("[data-artwork-detail]");const related=artworks.filter(a=>a.Series===art.Series&&a.ID!==art.ID).slice(0,4);shell.innerHTML=`<div class="artwork-detail"><div><figure class="main-art" data-main-art></figure><div class="thumbs" data-thumbs></div></div><article><p class="eyebrow">${art.Series}</p><h1>${art.Title}</h1><p>${art.Description}</p><div class="meta"><p><strong>Year</strong><br>${art.Year}</p><p><strong>Medium</strong><br>${art.Medium}</p><p><strong>Dimensions</strong><br>${art.Width} x ${art.Height} in</p><p><strong>Price</strong><br>${StudioUtils.money(art.Price)}</p><p><strong>Availability</strong><br>${art.Availability}</p><p><strong>Orientation</strong><br>${art.Orientation}</p></div><div>${art.Tags.split("|").map(t=>`<span class="tag">${t}</span>`).join("")}</div><p><a class="button dark" href="contact.html">Inquire</a><a class="button light" href="gallery.html?series=${encodeURIComponent(art.Series)}">Back to Series</a></p></article></div><section class="section"><h2>Related Artworks</h2><div class="artwork-grid" data-related></div></section>`;const main=shell.querySelector("[data-main-art]");function setImage(src){main.innerHTML="";main.append(StudioUtils.image(src,art.Title));main.onclick=()=>StudioLightbox.open(src,art.Title)}art.Images.forEach((src,i)=>{const b=document.createElement("button");b.type="button";b.append(StudioUtils.image(src,`${art.Title} thumbnail ${i+1}`));b.onclick=()=>setImage(src);shell.querySelector("[data-thumbs]").append(b)});setImage(art.Images[0]);related.forEach(a=>shell.querySelector("[data-related]").append(StudioUtils.card(a)))});
'@

Write-Host "Success: build-part2.ps1 created all JavaScript files."