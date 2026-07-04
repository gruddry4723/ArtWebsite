const StudioData=(()=>{
  function parse(text){
    const rows=[];let row=[],cell="",q=false;
    for(let i=0;i<text.length;i++){
      const c=text[i],n=text[i+1];
      if(c=='"'&&q&&n=='"'){cell+='"';i++}
      else if(c=='"'){q=!q}
      else if(c===","&&!q){row.push(cell);cell=""}
      else if((c==="\n"||c==="\r")&&!q){
        if(cell||row.length){row.push(cell);rows.push(row);row=[];cell=""}
        if(c==="\r"&&n==="\n")i++;
      }else cell+=c;
    }
    if(cell||row.length){row.push(cell);rows.push(row)}
    const head=rows.shift().map(h=>h.trim());
    return rows.filter(r=>r.length).map(r=>Object.fromEntries(head.map((h,i)=>[h,(r[i]||"").trim()])));
  }
  async function loadCsv(path){
    const r=await fetch(path);
    if(!r.ok)throw new Error(`Could not load ${path}`);
    return parse(await r.text());
  }
  function numberFromText(value){
    const match=String(value||"").match(/\d+(\.\d+)?/);
    return match?Number(match[0]):0;
  }
  function normalizeArtwork(a,index){
    const desc=a.Description||"Original signed monotype print.";
    a.Series=a.Series||"Monotype Archive";
    a.Year=a.Year||"2026";
    a.Medium=a.Medium||"Monotype print";
    a.Orientation=a.Orientation||"Portrait";
    a.Tags=a.Tags||"monotype|signed print|paper";
    a.Width=a.Width||"610";
    a.Height=a.Height||"940";
    a.Description=desc;
    a.Images=[a.CoverImage,a.Image2,a.Image3,a.Image4,a.Image5].filter(Boolean);
    a.PriceNumber=Number(a.Price||0);
    a.WidthNumber=numberFromText(a.Width);
    a.HeightNumber=numberFromText(a.Height);
    a.SortIndex=index;
    return a;
  }
  async function loadAll(){
    const [artworks,series,featured]=await Promise.all([
      loadCsv("data/artworks.csv?v=20260704-local-images"),
      loadCsv("data/series.csv"),
      loadCsv("data/featured.csv")
    ]);
    artworks.forEach(normalizeArtwork);
    const hasArchive=series.some(s=>s.Series==="Monotype Archive");
    if(!hasArchive){
      series.unshift({Series:"Monotype Archive",Description:"Signed monotype prints gathered as a focused collector archive.",Featured:"Yes"});
    }
    return{artworks,series,featured};
  }
  return{loadAll};
})();
