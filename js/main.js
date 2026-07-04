if(typeof StudioData!=="undefined"){
  StudioData.loadAll().then(({artworks,series,featured})=>{
    const wall=document.querySelector("[data-hero-wall]");
    if(wall){
      artworks.slice(0,9).forEach((a,i)=>{
        const tile=document.createElement("div");
        tile.className="wall-tile";
        tile.style.animationDelay=`${i*.14}s`;
        tile.append(StudioUtils.image(a.CoverImage,StudioUtils.artworkAlt(a)));
        wall.append(tile);
      });

      if(window.matchMedia("(pointer: fine)").matches&&!window.matchMedia("(prefers-reduced-motion: reduce)").matches){
        wall.closest(".hero")?.addEventListener("pointermove",event=>{
          const x=(event.clientX/window.innerWidth-.5)*-28;
          const y=(event.clientY/window.innerHeight-.5)*-20;
          wall.style.setProperty("--pointer-x",`${x}px`);
          wall.style.setProperty("--pointer-y",`${y}px`);
        });
        wall.closest(".hero")?.addEventListener("pointerleave",()=>{
          wall.style.setProperty("--pointer-x","0px");
          wall.style.setProperty("--pointer-y","0px");
        });
      }
    }

    const heroImage=document.querySelector("[data-about-image]");
    if(heroImage&&artworks[0]) heroImage.append(StudioUtils.image(artworks[0].CoverImage,StudioUtils.artworkAlt(artworks[0])));

    const featuredId=featured.find(f=>artworks.some(a=>a.ID===f.ArtworkID))?.ArtworkID;
    const pick=artworks.find(a=>a.ID===featuredId)||artworks[0];
    const featuredBox=document.querySelector("[data-featured-artwork]");
    if(featuredBox&&pick){
      featuredBox.className="featured-card reveal";
      const fig=document.createElement("figure");
      fig.append(StudioUtils.image(pick.CoverImage,StudioUtils.artworkAlt(pick)));
      const copy=document.createElement("div");
      copy.innerHTML=`<p class="eyebrow">Featured Artwork</p><h2>${StudioUtils.text(pick.Title,"Untitled")}</h2><p>${pick.Description}</p><p>${pick.Medium}, ${pick.Year}</p><a class="button dark" href="artwork.html?id=${pick.ID}">View Artwork</a>`;
      featuredBox.append(fig,copy);
    }

    const seriesGrid=document.querySelector("[data-featured-series]");
    series.slice(0,5).forEach(s=>{
      const card=document.createElement("a");
      card.className="card reveal";
      card.href=`gallery.html?series=${encodeURIComponent(s.Series)}`;
      card.innerHTML=`<div class="card-body"><h3>${s.Series}</h3></div>`;
      seriesGrid?.append(card);
    });

    const latest=document.querySelector("[data-latest-artworks]");
    artworks.slice().sort((a,b)=>b.SortIndex-a.SortIndex).slice(0,8).forEach(a=>latest?.append(StudioUtils.card(a)));
  }).finally(()=>StudioUtils?.reveal?.());
}else{
  if(typeof StudioUtils!=="undefined")StudioUtils.reveal();
}
