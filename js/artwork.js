StudioData.loadAll().then(({artworks})=>{
  const id=StudioUtils.params().get("id")||artworks[0].ID;
  const index=Math.max(0,artworks.findIndex(a=>a.ID===id));
  const art=artworks[index]||artworks[0];
  const prev=artworks[(index-1+artworks.length)%artworks.length];
  const next=artworks[(index+1)%artworks.length];
  const baseUrl="https://gruddry4723.github.io/ArtWebsite/";
  const artworkUrl=`${baseUrl}artwork.html?id=${encodeURIComponent(art.ID)}`;
  const artworkImageUrl=new URL(art.CoverImage,baseUrl).href;
  const artworkAlt=StudioUtils.artworkAlt(art);
  const seoDescription=`${art.Title}, an original handmade abstract monotype print. ${art.Description}`.trim().slice(0,160);
  const setMeta=(selector,value)=>{
    const node=document.querySelector(selector);
    if(node)node.content=value;
  };
  document.title=`${art.Title} | Original Abstract Monotype Print`;
  const meta=document.querySelector('meta[name="description"]');
  if(meta)meta.content=seoDescription;
  const canonical=document.querySelector('link[rel="canonical"]');
  if(canonical)canonical.href=artworkUrl;
  setMeta('meta[property="og:title"]',`${art.Title} | Original Abstract Monotype Print`);
  setMeta('meta[property="og:description"]',seoDescription);
  setMeta('meta[property="og:url"]',artworkUrl);
  setMeta('meta[property="og:image"]',artworkImageUrl);
  setMeta('meta[property="og:image:alt"]',artworkAlt);
  setMeta('meta[name="twitter:title"]',`${art.Title} | Original Abstract Monotype Print`);
  setMeta('meta[name="twitter:description"]',seoDescription);
  setMeta('meta[name="twitter:image"]',artworkImageUrl);
  setMeta('meta[name="twitter:image:alt"]',artworkAlt);

  const artworkSchema={
    "@context":"https://schema.org",
    "@type":["VisualArtwork","Product"],
    "@id":`${artworkUrl}#artwork`,
    name:art.Title,
    description:art.Description,
    url:artworkUrl,
    image:art.Images.filter(Boolean).map(src=>new URL(src,baseUrl).href),
    category:"Original abstract monotype print",
    creator:{"@type":"Organization",name:"brpartsandcraftscoza",url:baseUrl}
  };
  if(art.Medium)artworkSchema.artMedium=art.Medium;
  if(art.Width)artworkSchema.width={"@type":"QuantitativeValue",value:Number(art.Width),unitCode:"MMT"};
  if(art.Height)artworkSchema.height={"@type":"QuantitativeValue",value:Number(art.Height),unitCode:"MMT"};
  if(Number(art.Price))artworkSchema.offers={
    "@type":"Offer",
    url:artworkUrl,
    price:Number(art.Price).toFixed(2),
    priceCurrency:"USD",
    availability:art.Availability.toLowerCase()==="available"?"https://schema.org/InStock":"https://schema.org/OutOfStock"
  };
  const schema=document.createElement("script");
  schema.type="application/ld+json";
  schema.dataset.artworkSchema="";
  schema.textContent=JSON.stringify(artworkSchema);
  document.head.append(schema);
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
    main.append(StudioUtils.image(src,artworkAlt));
    main.onclick=()=>StudioLightbox.open(src,artworkAlt);
  }
  art.Images.forEach((src,i)=>{
    const b=document.createElement("button");
    b.type="button";
    b.setAttribute("aria-label",`View image ${i+1} for ${art.Title}`);
    b.append(StudioUtils.image(src,`${artworkAlt}, image ${i+1}`));
    b.onclick=()=>setImage(src);
    shell.querySelector("[data-thumbs]").append(b);
  });
  setImage(art.Images[0]);
  const relatedGrid=shell.querySelector("[data-related]");
  const relatedItems=related.length?related:artworks.filter(a=>a.ID!==art.ID).slice(0,4);
  relatedItems.forEach(a=>relatedGrid.append(StudioUtils.card(a)));
  StudioUtils.reveal();
});
