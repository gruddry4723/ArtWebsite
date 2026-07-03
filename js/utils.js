const StudioUtils=(()=>{
  function money(v){
    const n=Number(v||0);
    return n?`${new Intl.NumberFormat("en-US",{maximumFractionDigits:0}).format(n)} $ USD`:"Price on request";
  }
  function params(){return new URLSearchParams(location.search)}
  function text(v,fallback="Unspecified"){return v&&String(v).trim()?v:fallback}
  function fallback(title){
    const d=document.createElement("div");
    d.className="placeholder-image";
    d.textContent=title||"Artwork image";
    return d;
  }
  function image(src,alt){
    const img=document.createElement("img");
    img.loading="lazy";
    img.decoding="async";
    img.src=src;
    img.alt=alt||"Artwork image";
    img.onerror=()=>img.replaceWith(fallback(alt));
    return img;
  }
  function card(a){
    const link=document.createElement("a");
    link.className="card reveal";
    link.href=`artwork.html?id=${encodeURIComponent(a.ID)}`;
    const fig=document.createElement("figure");
    fig.append(image(a.CoverImage,a.Title));
    const body=document.createElement("div");
    body.className="card-body";
    body.innerHTML=`<h3>${text(a.Title,"Untitled")}</h3><p class="muted">${money(a.Price)}</p><p>${text(a.Availability,"Available")}</p>`;
    link.append(fig,body);
    return link;
  }
  function reveal(){
    const items=document.querySelectorAll(".reveal:not(.visible)");
    if(!("IntersectionObserver" in window)){
      items.forEach(el=>el.classList.add("visible"));
      return;
    }
    const obs=new IntersectionObserver(entries=>{
      entries.forEach(entry=>{
        if(entry.isIntersecting){
          entry.target.classList.add("visible");
          obs.unobserve(entry.target);
        }
      });
    },{threshold:.14,rootMargin:"0px 0px -60px"});
    items.forEach((el,i)=>{
      el.style.transitionDelay=el.classList.contains("card")?`${Math.min(i%8,6)*45}ms`:"";
      obs.observe(el);
    });
  }
  window.addEventListener("load",()=>document.body.classList.add("loaded"));
  return{money,params,image,card,reveal,text};
})();
