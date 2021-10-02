//If we're on the podcasts list page
if (window.location.href === 'https://overcast.fm/podcasts') {
    const list = document.getElementsByClassName('pure-u-sm-3-5')[0];
    const children = Array.prototype.slice.call(list.children);
    
    //count the h2 elements we've seen to determine which sections we're in
    let headerCount = 0;

    children.forEach(function(element) { 
        if (element.tagName === "H2") {
            headerCount += 1;
        }

        //if we're in the episodes section remove the element
        if (headerCount < 2) {
            element.remove();
        }
    });

}
