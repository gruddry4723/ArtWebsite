/*
==================================================
search.js
Purpose: Instant search across title, description, tags, medium, series, year, and price.
==================================================
*/
const StudioSearch={matches(art,term){if(!term)return true;const text=[art.Title,art.Description,art.Tags,art.Medium,art.Series,art.Year,art.Price].join(" ").toLowerCase();return text.includes(term.toLowerCase())}};
