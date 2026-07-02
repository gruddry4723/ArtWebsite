/*
==================================================
menu.js
Purpose: Mobile navigation toggle behavior.
==================================================
*/
document.addEventListener("click",event=>{const button=event.target.closest("[data-nav-toggle]");if(!button)return;const links=document.querySelector("[data-nav-links]");links.classList.toggle("open");button.setAttribute("aria-expanded",links.classList.contains("open"))});
