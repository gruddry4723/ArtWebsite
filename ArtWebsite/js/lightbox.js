/*
==================================================
lightbox.js
Purpose: Accessible lightweight image lightbox with click-to-close behavior.
==================================================
*/
const StudioLightbox={open(src,alt){const box=document.createElement("div");box.className="lightbox";box.innerHTML=`<button class="button light" type="button">Close</button><img src="${src}" alt="${alt}">`;box.addEventListener("click",e=>{if(e.target===box||e.target.tagName==="BUTTON")box.remove()});document.addEventListener("keydown",function esc(e){if(e.key==="Escape"){box.remove();document.removeEventListener("keydown",esc)}});document.body.append(box)}};
