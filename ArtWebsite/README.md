==================================================
README.md
Purpose: Explain the artist portfolio project, folders, files, editing, deployment, and maintenance.
==================================================

# Elena Marlow Studio Portfolio

This is a complete static artist portfolio website built with HTML, CSS, and vanilla JavaScript. It is designed for GitHub Pages and does not need a server, database, React, Node, PHP, Firebase, or any backend.

## How the site works

The website reads CSV files from the `data` folder:

- `artworks.csv` controls all artwork records.
- `series.csv` controls series cards.
- `featured.csv` controls highlighted artworks.

The owner updates the website by editing CSV files and copying artwork image folders into `images/series`.

## Folder guide

- `index.html`: homepage.
- `gallery.html`: searchable and filterable gallery.
- `artwork.html`: single artwork detail page.
- `about.html`: artist biography and statement.
- `contact.html`: inquiry page.
- `404.html`: GitHub Pages not-found page.
- `css`: visual styling.
- `js`: CSV loading, search, filters, gallery rendering, artwork rendering, menu, and lightbox.
- `data`: editable CSV files.
- `images`: logo, icons, and artwork images.

## Artwork images

Recommended structure:

`images/series/Series Name/Artwork Title/main.jpg`

Extra images can be added as:

`detail1.jpg`, `detail2.jpg`, `detail3.jpg`, and more.

The CSV can support more image columns later. The JavaScript already keeps artwork image handling modular.

## Editing artworks

Open `data/artworks.csv` in VS Code or a spreadsheet editor. Keep the first row exactly as it is. Add new artworks as new rows. Use consistent series names so filters work correctly.

## Deployment

Upload the full `ArtWebsite` folder contents to a GitHub repository. Enable GitHub Pages from repository settings and choose the main branch. The website will be published as a static site.
