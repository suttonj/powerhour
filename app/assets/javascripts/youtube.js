

/**
 * Put your video IDs in this array
 */
// var videoIDs = [
//     '9bZkp7q19f0',
//     'QK8mJJJvaes',
//     'RnpyRe_7jZA'
// ];

// var tag = document.createElement('script');
// tag.src = "https://www.youtube.com/iframe_api";
// var firstScriptTag = document.getElementsByTagName('script')[0];
// firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

// var player;

// function onYouTubeIframeAPIReady() {

//     player = new YT.Player('player', {
//         height: '315',
//         width: '420',
//         videoId: 'OdT9z-JjtJk',
//         events: {
//             'onReady': onPlayerReady,
//                 'onStateChange': onPlayerStateChange
//         }
//     });

//     //player.loadPlaylist(['OdT9z-JjtJk','NlXTv5Ondgs'], 0, 60, "default");
    
// }

// function onPlayerReady(event) {
//     //event.target.playVideo();
//     event.target.loadPlaylist(videoIDs, 0, 60, "default");
// }

// //play video for 60 seconds
// var done = false;
// function onPlayerStateChange(event) {
//     if (event.data == YT.PlayerState.PLAYING && !done) {
//         setTimeout(stopVideo, 60000);
//         done = true;
//     }
// }

// function stopVideo() {
//     player.nextVideo();
// }

//Video fluid width resizing code?

// By Chris Coyier & tweaked by Mathias Bynens

$(function() {

    // Find all YouTube videos
    var $allVideos = $("iframe[src^='http://www.youtube.com']"),

        // The element that is fluid width
        $fluidEl = $("div");

    // Figure out and save aspect ratio for each video
    $allVideos.each(function() {

        $(this)
            .data('aspectRatio', this.height / this.width)
            
            // and remove the hard coded width/height
            .removeAttr('height')
            .removeAttr('width');

    });

    // When the window is resized
    // (You'll probably want to debounce this)
    $(window).resize(function() {

        var newWidth = $fluidEl.width();
        
        // Resize all videos according to their own aspect ratio
        $allVideos.each(function() {

            var $el = $(this);
            $el
                .width(newWidth)
                .height(newWidth * $el.data('aspectRatio'));

        });

    // Kick off one resize to fix all videos on page load
    }).resize();

});
