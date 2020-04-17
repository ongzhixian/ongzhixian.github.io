function toggleMenu() {
    var x = document.getElementById("myTopnav");
    if (x.className === "top") {
        x.className += " responsive";
    } else {
        x.className = "top";
    }
}