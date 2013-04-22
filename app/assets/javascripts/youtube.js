
//Timer function 
// function Timer(callback, delay) {
//     var timerId, start, remaining = delay;

//     this.pause = function() {
//         window.clearTimeout(timerId);
//         remaining -= new Date() - start;
//     };

//     this.resume = function() {
//         start = new Date();
//         timerId = window.setTimeout(callback, remaining);
//     };

//     this.resume();
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


function Timer(callback, delay) {
    var timerId, start, remaining = delay;

    this.pause = function() {
        window.clearTimeout(timerId);
        remaining -= new Date() - start;
    };

    this.resume = function() {
        start = new Date();
        timerId = window.setTimeout(callback, remaining);
    };

    this.clear = function() {
        window.clearTimeout(timerId);
    };

    this.resume();
}
    

$(document).ready(function() {
//     var playlist = <%= raw @playlist %>;

//     var tag = document.createElement('script');
//     tag.src = "https://www.youtube.com/iframe_api";
//     var firstScriptTag = document.getElementsByTagName('script')[0];
//     firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

    

//     var player;
//     var timeouts = [];
//     var timer;
//     var played = 0;

//     function onYouTubeIframeAPIReady() {

//         // player = new YT.Player('player', {
//         //     height: '315',
//         //     width: '420',
//         //     videoId: '',
//         //     playerVars: { 'controls': 0 },
//         //     events: {
//         //         'onReady': onPlayerReady,
//         //         'onStateChange': onPlayerStateChange
//         //     }
//         // });
        
//     }

//     //prevent timeout stack from getting out of sync
//     function clearTimeouts() {
//         if (timeouts.length != null && timeouts.length > 0)
//             {   
//             for (var i = 0; i < timeouts.length; i++) {
//                 clearTimeout(timeouts[i]);
//             }
//             //quick reset of the timer array you just cleared
//             timeouts = [];
//         }
//     }

//     function onPlayerReady(event) {
//         //event.target.playVideo();
//         event.target.loadPlaylist(playlist, 0, 60, "default");
//         //player.pauseVideo();
//         player.setLoop(true);
//         player.addEventListener("onError", "onPlayerError");
//     }

//     function onPlayerError() {
//         alert('err');
//         if(played)
//             played = played - 1;
//     }

//     //play video for 60 seconds
//     var done = false, paused = false;
//     function onPlayerStateChange(event) {
//         setPlayerControls(event.data);

//         if (event.data == YT.PlayerState.PAUSED && !paused) {
//             timer.pause();
//             paused = true;
//             return;
//         }

//         done = false;
//         if (event.data == YT.PlayerState.PLAYING && !done) {
            
//             if (timer == null) {

//                 if (player.getPlaylistIndex() != 0)
//                     player.seekTo(91, true);    

//                 timer = new Timer(nextVideo, 6000);
//                 //timeouts.push( timer );
//             }
//             else if (paused) {
//                 timer.resume();
//                 paused = false;
//             }

//             done = true;
//         }       
//     }

//     function nextVideo() {
//         played = played + 1;
//         timer.clear();
//         timer = null;
        
//         if (played <= 60) {
//             player.nextVideo();
//         }
//         else {
//             player.stopVideo();
//             alert('Done! ' + played + ' videos played.');
//         }
//         setProgressBar( (played/60 * 100) );
//     }

//     function pauseVideo() {
//         //setPlayerControls(2);
//         //timer.pause();
//         player.pauseVideo();
//         //paused = true;
//         //clearTimeouts();
//     }

//     function resumeVideo() {
//         //setPlayerControls(1);
//         player.playVideo();
//     }


//     /**
//     * player control button states:
//     * 0 - init
//     * 1 - started/playing
//     * 2 - paused
//     */
//     function setPlayerControls(state) {

//         var playButton = $("#play"), pauseButton = $("#pause");

//         switch(state) {
//             case -2:
//                 playButton.html("<a href=\"javascript:startVideo()\" class=\"button radius\">Start</a>");
//                 pauseButton.html("<a href=\"javascript:void(0)\" class=\"button radius disabled\">Pause</a>");
//                 break;
//             case 1:
//                 playButton.html("<a href=\"javascript:void(0)\" class=\"button radius disabled\">Resume</a>");
//                 pauseButton.html("<a href=\"javascript:pauseVideo()\" class=\"button radius\">Pause</a>");
//                 break;
//             case 2:
//                 playButton.html("<a href=\"javascript:resumeVideo()\" class=\"button radius\">Resume</a>");
//                 pauseButton.html("<a href=\"javascript:void(0)\" class=\"button radius disabled\">Pause</a>");
//                 break;
//         }

//     }

//     function setProgressBar(width) {
//         $(".meter").css("width", width); 
//         $("#progress-tip").attr("title", "" + (60 - played) + " minutes remaining");
//         $("#progress-text").html("" + (60 - played) + " minutes remaining");
//     }

//     function initPlayer() {
//         player = new YT.Player('player', {
//             height: '315',
//             width: '420',
//             videoId: '',
//             playerVars: { 'controls': 0 },
//             events: {
//                 'onReady': onPlayerReady,
//                 'onStateChange': onPlayerStateChange
//             }
//         });
//     }

//     function startVideo() {
//         setPlayerControls(1);
//         initPlayer();
//         player.playVideo();
//     }
});