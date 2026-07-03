StudioData.loadAll().then(({artworks,series})=>{
  const grid=document.querySelector("[data-gallery-grid]");
  const count=document.querySelector("[data-result-count]");
  const sort=document.querySelector("[data-sort-select]");
  const search=document.querySelector("[data-search-input]");
  const controls=[...document.querySelectorAll("[data-filter]")];
  function fieldName(key){return{series:"Series",medium:"Medium",year:"Year",availability:"Availability",orientation:"Orientation"}[key]}
  function fill(key){
    const el=document.querySelector(`[data-filter="${key}"]`);
    if(!el||el.tagName!=="SELECT")return;
    [...new Set(artworks.map(a=>a[fieldName(key)]).filter(Boolean))].sort().forEach(v=>el.add(new Option(v,v)));
  }
  ["medium","year","availability","orientation"].forEach(fill);

  const strip=document.querySelector("[data-series-strip]");
  if(strip)series.forEach(s=>{
    const b=document.createElement("button");
    b.type="button";
    b.className="chip";
    b.textContent=s.Series;
    b.onclick=()=>{
      document.querySelector('[data-filter="series"]').value=s.Series;
      render();
    };
    strip.append(b);
  });

  function state(){
    const s=Object.fromEntries(controls.map(c=>[c.dataset.filter,c.value]));
    s.search=search.value;
    return s;
  }
  function markActive(current){
    document.querySelectorAll(".chip").forEach(chip=>chip.classList.toggle("active",chip.textContent===current.series));
  }
  function render(){
    const current=state();
    grid.innerHTML="";
    const results=StudioFilters.sort(StudioFilters.apply(artworks,current),sort.value);
    count.textContent=`${results.length} artwork${results.length===1?"":"s"}`;
    results.forEach(a=>grid.append(StudioUtils.card(a)));
    markActive(current);
    StudioUtils.reveal();
  }
  document.addEventListener("input",e=>{
    if(e.target.matches("[data-filter],[data-search-input],[data-sort-select]"))render();
  });
  document.querySelector("[data-clear-filters]").onclick=()=>{
    controls.forEach(c=>c.value="");
    search.value="";
    render();
  };
  render();
});
