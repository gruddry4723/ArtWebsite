$root="ArtWebsite"
function W($p,$c){Set-Content -Path $p -Value $c -Encoding UTF8}

$series=@(
@("Threshold Light","Paintings about windows, doorways, and the soft edges between inside and outside.","Yes"),
@("Weather Rooms","Interior works shaped by rain, haze, and changing atmospheric pressure.","Yes"),
@("Quiet Streets","Urban fragments, pavements, facades, and late afternoon shadows.","Yes"),
@("Paper Architecture","Works on paper that compress buildings into gesture and line.","Yes"),
@("Night Garden","Darker mixed media works where botanical forms meet architectural memory.","Yes")
)
$csv="Series,Description,Featured`n"
foreach($s in $series){$csv += '"' + ($s -join '","') + '"' + "`n"}
W "$root/data/series.csv" $csv

W "$root/data/featured.csv" "ArtworkID,Placement`nA001,Homepage Hero`nA012,Featured Series`nA025,Collector Highlight`nA041,Latest Feature`nA058,Archive Feature`n"

$headers="ID,Title,Series,Year,Medium,Width,Height,Orientation,Price,Availability,Tags,Description,CoverImage,Image2,Image3,Image4,Image5"
$titles=@("After the Rain","North Window","Blue Landing","Room with Two Chairs","Pale Stair","Late Facade","Borrowed Light","Quiet Corner","Small Weather","Open Threshold","Soft Map","Garden Wall")
$mediums=@("Oil on linen","Acrylic and graphite on panel","Watercolor on cotton paper","Mixed media on canvas","Ink and gouache on paper")
$rows=@($headers)
for($i=1;$i -le 60;$i++){
  $sid=($i-1)%5
  $ser=$series[$sid][0]
  $title=$titles[($i-1)%$titles.Count]+" "+[math]::Ceiling($i/5)
  $year=2021+(($i-1)%6)
  $medium=$mediums[($i-1)%$mediums.Count]
  $w=18+(($i*3)%42)
  $h=20+(($i*5)%48)
  $orient= if($w -gt $h){"Landscape"}elseif($w -lt $h){"Portrait"}else{"Square"}
  $price=850+($i*135)
  $avail= if($i%7 -eq 0){"Sold"}elseif($i%5 -eq 0){"Reserved"}else{"Available"}
  $tags=("architecture|memory|light|studio|"+$ser.ToLower().Replace(" ","-"))
  $folder="images/series/$ser/$title"
  $desc="A layered contemporary artwork from the $ser series, balancing observed structure with atmosphere, erasure, and quiet spatial tension."
  $id="A{0:D3}" -f $i
  $row=@($id,$title,$ser,$year,$medium,$w,$h,$orient,$price,$avail,$tags,$desc,"$folder/main.jpg","$folder/detail1.jpg","$folder/detail2.jpg","$folder/detail3.jpg","$folder/detail4.jpg")
  $rows += '"' + ($row -join '","') + '"'
}
W "$root/data/artworks.csv" ($rows -join "`n")

W "$root/README.md" @'
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
'@

W "$root/PROJECT_SETUP.md" @'
==================================================
PROJECT_SETUP.md
Purpose: Beginner-friendly setup, editing, publishing, and maintenance guide.
==================================================

# Complete Beginner Setup Guide

## 1. Install VS Code

Go to https://code.visualstudio.com and download Visual Studio Code. Install it using the default options. Open VS Code after installation.

## 2. Install Git

Go to https://git-scm.com/downloads and download Git for your computer. Install it using the default options.

## 3. Create a GitHub account

Go to https://github.com and create a free account. Confirm your email address.

## 4. Create a repository

On GitHub, click the plus button, choose New repository, name it something like `artist-portfolio`, keep it public, and create it.

## 5. Open the website folder

In VS Code, choose File, then Open Folder. Select the `ArtWebsite` folder generated by these scripts.

## 6. Preview locally

Because this website reads CSV files, use a local preview server instead of double-clicking the HTML file. In VS Code, install the Live Server extension. Right-click `index.html` and choose Open with Live Server.

## 7. Edit artist information

Edit `about.html` for biography and statement text. Edit `contact.html` to replace the email address with the real studio email.

## 8. Add artwork images

Create folders inside `images/series`. The recommended structure is:

`images/series/Series Name/Artwork Title/main.jpg`

Add detail images in the same folder.

## 9. Update CSV files

Open `data/artworks.csv`. Add or edit rows. Do not delete the header row. The image paths in the CSV must match the image files you copied.

## 10. Publish with GitHub Pages

Upload all files inside `ArtWebsite` to your GitHub repository. In GitHub, open Settings, then Pages. Choose Deploy from a branch, select `main`, select root, and save. GitHub will give you a public website link.

## 11. Update later

To add new art later, copy image folders, update the CSV files, and upload the changed files to GitHub.

## 12. Custom domain later

Buy a domain from a domain provider. In GitHub Pages settings, enter the custom domain. At your domain provider, add the DNS records GitHub recommends.
'@

Write-Host "Success: build-part3.ps1 created CSV data, README, and setup documentation."
Write-Host "All parts complete. Open the ArtWebsite folder in VS Code."