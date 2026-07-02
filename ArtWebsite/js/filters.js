/*
==================================================
filters.js
Purpose: Multi-filter and sorting logic for gallery results.
==================================================
*/
const StudioFilters={apply(items,state){return items.filter(a=>(!state.series||a.Series===state.series)&&(!state.medium||a.Medium===state.medium)&&(!state.year||a.Year===state.year)&&(!state.availability||a.Availability===state.availability)&&(!state.orientation||a.Orientation===state.orientation)&&(!state.tag||a.Tags.toLowerCase().includes(state.tag.toLowerCase()))&&(!state.minWidth||a.WidthNumber>=Number(state.minWidth))&&(!state.minHeight||a.HeightNumber>=Number(state.minHeight))&&(!state.minPrice||a.PriceNumber>=Number(state.minPrice))&&(!state.maxPrice||a.PriceNumber<=Number(state.maxPrice))).filter(a=>StudioSearch.matches(a,state.search))},sort(items,mode){const a=[...items];if(mode==="oldest")return a.sort((x,y)=>x.Year-y.Year);if(mode==="alphabetical")return a.sort((x,y)=>x.Title.localeCompare(y.Title));if(mode==="priceLow")return a.sort((x,y)=>x.PriceNumber-y.PriceNumber);if(mode==="priceHigh")return a.sort((x,y)=>y.PriceNumber-x.PriceNumber);if(mode==="random")return a.sort(()=>Math.random()-.5);return a.sort((x,y)=>y.Year-x.Year)}};
