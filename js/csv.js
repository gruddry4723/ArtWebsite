/*
==================================================
csv.js
Purpose: Load CSV files and convert them into artwork, series, and featured objects.
==================================================
*/
const StudioData=(()=>{function parse(text){const rows=[];let row=[],cell="",q=false;for(let i=0;i<text.length;i++){const c=text[i],n=text[i+1];if(c=='"'&&q&&n=='"'){cell+='"';i++}else if(c=='"'){q=!q}else if(c==","&&!q){row.push(cell);cell=""}else if((c=="\n"||c=="\r")&&!q){if(cell||row.length){row.push(cell);rows.push(row);row=[];cell=""}if(c=="\r"&&n=="\n")i++}else cell+=c}if(cell||row.length){row.push(cell);rows.push(row)}const head=rows.shift().map(h=>h.trim());return rows.filter(r=>r.length).map(r=>Object.fromEntries(head.map((h,i)=>[h,(r[i]||"").trim()])))}
async function loadCsv(path){const r=await fetch(path);if(!r.ok)throw new Error(`Could not load ${path}`);return parse(await r.text())}
async function loadAll(){const [artworks,series,featured]=await Promise.all([loadCsv("data/artworks.csv"),loadCsv("data/series.csv"),loadCsv("data/featured.csv")]);artworks.forEach(a=>{a.Images=[a.CoverImage,a.Image2,a.Image3,a.Image4,a.Image5].filter(Boolean);a.PriceNumber=Number(a.Price||0);a.WidthNumber=Number(a.Width||0);a.HeightNumber=Number(a.Height||0)});return{artworks,series,featured}}return{loadAll}})();
