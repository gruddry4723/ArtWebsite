if(typeof StudioData!=="undefined"){
  StudioData.loadAll().then(({artworks,series,featured})=>{
    const wall=document.querySelector("[data-hero-wall]");
    if(wall){
      artworks.slice(0,18).forEach((a,i)=>{
        const tile=document.createElement("div");
        tile.className="wall-tile";
        tile.style.animationDelay=`${i*.14}s`;
        tile.append(StudioUtils.image(a.CoverImage,a.Title));
        wall.append(tile);
      });
    }

    const heroImage=document.querySelector("[data-about-image]");
    if(heroImage&&artworks[0]) heroImage.append(StudioUtils.image(artworks[0].CoverImage,artworks[0].Title));

    const featuredId=featured.find(f=>artworks.some(a=>a.ID===f.ArtworkID))?.ArtworkID;
    const pick=artworks.find(a=>a.ID===featuredId)||artworks[0];
    const featuredBox=document.querySelector("[data-featured-artwork]");
    if(featuredBox&&pick){
      featuredBox.className="featured-card reveal";
      const fig=document.createElement("figure");
      fig.append(StudioUtils.image(pick.CoverImage,pick.Title));
      const copy=document.createElement("div");
      copy.innerHTML=`<p class="eyebrow">Featured Artwork</p><h2>${StudioUtils.text(pick.Title,"Untitled")}</h2><p>${pick.Description}</p><p>${pick.Medium}, ${pick.Year}</p><a class="button dark" href="artwork.html?id=${pick.ID}">View Artwork</a>`;
      featuredBox.append(fig,copy);
    }

    const seriesGrid=document.querySelector("[data-featured-series]");
    series.slice(0,5).forEach(s=>{
      const card=document.createElement("a");
      card.className="card reveal";
      card.href=`gallery.html?series=${encodeURIComponent(s.Series)}`;
      card.innerHTML=`<div class="card-body"><p class="eyebrow">Draft</p><h3>${s.Series}</h3><p>${s.Description}</p></div>`;
      seriesGrid?.append(card);
    });

    const latest=document.querySelector("[data-latest-artworks]");
    artworks.slice().sort((a,b)=>b.SortIndex-a.SortIndex).slice(0,8).forEach(a=>latest?.append(StudioUtils.card(a)));
  }).finally(()=>StudioUtils?.reveal?.());
}else{
  if(typeof StudioUtils!=="undefined")StudioUtils.reveal();
}
