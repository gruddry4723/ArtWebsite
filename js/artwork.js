StudioData.loadAll().then(({artworks})=>{
  const id=StudioUtils.params().get("id")||artworks[0].ID;
  const index=Math.max(0,artworks.findIndex(a=>a.ID===id));
  const art=artworks[index]||artworks[0];
  const prev=artworks[(index-1+artworks.length)%artworks.length];
  const next=artworks[(index+1)%artworks.length];
  document.title=`${art.Title} | brpartsandcraftscoza`;
  const meta=document.querySelector('meta[name="description"]');
  if(meta)meta.content=art.Description;
  const shell=document.querySelector("[data-artwork-detail]");
  const related=artworks.filter(a=>a.Series===art.Series&&a.ID!==art.ID).slice(0,4);
  shell.innerHTML=`
    <div class="artwork-detail reveal">
      <div>
        <figure class="main-art" data-main-art aria-label="Open fullscreen image"></figure>
        <div class="thumbs" data-thumbs aria-label="Artwork image thumbnails"></div>
      </div>
      <article class="artwork-copy">
        <p class="eyebrow">Artwork</p>
        <h1>${art.Title}</h1>
        <p>${art.Description}</p>
        <div class="meta">
          <p><strong>Year</strong><br>${art.Year}</p>
          <p><strong>Medium</strong><br>${art.Medium}</p>
          <p><strong>Dimensions</strong><br>${art.Width} x ${art.Height} mm</p>
          <p><strong>Price</strong><br>${StudioUtils.money(art.Price)}</p>
          <p><strong>Availability</strong><br>${art.Availability}</p>
          <p><strong>Orientation</strong><br>${art.Orientation}</p>
        </div>
        <div>${art.Tags.split("|").filter(Boolean).map(t=>`<span class="tag">${t}</span>`).join("")}</div>
        <p><a class="button dark" href="contact.html">Inquire</a><a class="button light" href="gallery.html">Back to Gallery</a></p>
        <nav class="artwork-nav" aria-label="Artwork navigation">
          <a href="artwork.html?id=${encodeURIComponent(prev.ID)}"><span>Previous</span>${prev.Title}</a>
          <a href="artwork.html?id=${encodeURIComponent(next.ID)}"><span>Next</span>${next.Title}</a>
        </nav>
      </article>
    </div>
    <section class="section">
      <div class="section-heading reveal">
        <p class="eyebrow">Related</p>
        <h2>Related Artworks</h2>
      </div>
      <div class="artwork-grid" data-related></div>
    </section>`;
  const main=shell.querySelector("[data-main-art]");
  function setImage(src){
    main.innerHTML="";
    main.append(StudioUtils.image(src,art.Title));
    main.onclick=()=>StudioLightbox.open(src,art.Title);
  }
  art.Images.forEach((src,i)=>{
    const b=document.createElement("button");
    b.type="button";
    b.setAttribute("aria-label",`View image ${i+1} for ${art.Title}`);
    b.append(StudioUtils.image(src,`${art.Title} thumbnail ${i+1}`));
    b.onclick=()=>setImage(src);
    shell.querySelector("[data-thumbs]").append(b);
  });
  setImage(art.Images[0]);
  const relatedGrid=shell.querySelector("[data-related]");
  const relatedItems=related.length?related:artworks.filter(a=>a.ID!==art.ID).slice(0,4);
  relatedItems.forEach(a=>relatedGrid.append(StudioUtils.card(a)));
  StudioUtils.reveal();
});
