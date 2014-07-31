$('#areaModal').on('shown.bs.modal', function (e) {
    var $container = $('#photos-masonry');

    $container.imagesLoaded(function() {
      $container.isotope({
        layoutMode: 'masonry',
        itemSelector: '.item ',
        masonry: {
          columnWidth: $container.find('.grid-sizer')[0]
        },
        getSortData: {
          priority: '.priority'
        },
        sortBy: ['priority', 'original-order']
      });
    });

    // Close expanded cards
    $('.photo-card').on( 'click', function() {
      $(this).siblings('.game-card').find('.game-divider').empty();
      $(this).siblings('.video-card').find('.game-divider').empty();
      $(this).siblings('.photo-card').find('.game-divider').empty();
      $(this).siblings('.photo-card-expanded').removeClass('photo-card-expanded')
        .find('.fun-fact').hide().end()
        .find('.game-thumbnail').show();
      $(this).siblings('.game-card-expanded').removeClass('game-card-expanded')
        .find('.game-thumbnail').show().end()
        .find('.fun-fact').hide();
      $container.imagesLoaded(function() {
        $container.isotope({ layoutMode : 'masonry' });
      });
    });

    // Expand Game Card
    $('.game-card').on( 'click', function() {
      var gameURL = $(this).find('.game-data').data('url');
      var content = '<iframe class="game-frame" src="' + gameURL + '" ></iframe>';
      var divider = $(this).find('.game-divider');
      //expand clicked game card
      $(this).find('.game-thumbnail').hide();
      $(this).addClass('game-card-expanded');
      $(this).find('.fun-fact').show();
      $(divider).empty();
      $(divider).append(content);
      $container.imagesLoaded(function() {
        $container.isotope({ layoutMode : 'masonry' });
      });
    });

    // Expand Video Card
    $('.video-card').on( 'click', function() {

      var vimeoId = $(this).find('.video-data').data('video-id');
      var content = '<iframe class="vimeo-frame" src=\"//player.vimeo.com/video/' + vimeoId + '\" frameborder=\"0\" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>';
      var divider = $(this).find('.game-divider');
      //expand clicked game card
      $(this).find('.game-thumbnail').hide();
      $(this).addClass('game-card-expanded');
      $(divider).empty();
      $(divider).append(content);
      $container.imagesLoaded(function() {
        $container.isotope({ layoutMode : 'masonry' });
      });
    });

    // Expand Photo Card
    $('.photo-thumb').on('click', function(e) {
      var photoUrl = $(this).find('.photo-data').data('photo-url');
      var divider = $(this).find('.game-divider');
      // remove photo thumbnail and populate expanded divider with large image
      $(this).find('.game-thumbnail').hide();
      $(this).addClass('photo-card-expanded');
      $(this).find('.fun-fact').show();
      $(divider).empty();

			//Dummy image, medium
		  var content2 = $('<img src=' +
			'"data:image/gif;base64,R0lGODlhyACmAPf/APnCE/vppO3t6/vkl/vUO//saO+HMf3dTl5eXe97hf/tdvzeVPnCAv3gWO3r4/e2EPCZpvjNzfi6BPi9Cc/n8v7niOM2WedOaP/zmH62zf378vTsxOM2WvvKJPnFGIa7z+ErXv/96/vNKw0OC/reiurjxf/93Pr10vzp6fzYROTk4vn5+PvRNP//5OpnQ/vUZvrIOPnADvKWTbKxsfDw8PWqGv7dSfLx6v39/epkdve5Af/gTPzdd/i+Avf13LLY6f3fVo+Ojtva1vi6Afi4Af70tuPi3fHr0uhaSPT09PrIHudIVv/xh/3cW+xzQY/D2fSlL/zWQP7zqPe6BPbxzvCGavnMRvzaSf/xev351fvtvP3wyHe00/3gV+XDtv3qscjGxf30xOviuerYatne4fPx5DAvLunl1Pi6AOM7XJa+vu7r2//iUeTg0ujcre52jO3o0PnRWvTrvfz34/3eUO1zgf/qX+55ievZevzcT+IwXqXCr/nFLfe3AP/kUPf113Wyy//lVP712///9sjKj/i2AKGOWuIxVvnBIPi7DPLlueIyW/nQVXm1z/OcH/i4A+dTTlBPTv/TLfPlr9nWyf/5wsyzVf/oVPzbTNfSgPf28P/mXuIzWP29AuEuX+fm3vn58eM0Wvjqtf7YO/fz0qmnpe9/iP/8y/ayFHq0y/3dUff39vrOUPq5AP/XUM+4ecjc5P/nWOI1XfPz89/l6ODp7fu6AP3ABXt6eP7eUvf26+js7/i8A3plK8/OzpmYmOEqUMjL0/f003eyytSmJf7XW+fn4/v7+/b4/v/SRHBwcP/FEufCW769vOW9Sv+7AUlAJjo6OiUlIu/x+IODg/fz0fPPavPz8fDDQvv8/6OELfzeU/3eUyIlKqGhoUVEQxcXFvbz0fbz0Pfz0P3eUvzeUvzfVP/fT/7fUvjyz+VCXP/bU3CvyfPbYuxqg+tzk9rDWf7gZf/dVfi9BPzfUvPSTaPQ5Hi0zOZOU+np6B4eHP3eVPi8Bfi7Bf///////yH/C05FVFNDQVBFMi4wAwEAAAAh/wtYTVAgRGF0YVhNUDw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNS1jMDIxIDc5LjE1NDkxMSwgMjAxMy8xMC8yOS0xMTo0NzoxNiAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDozYjQ3YzlhYS0zYTVmLTQ0NzEtYWMwMS1iN2RjMjA5MGViNGEiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6NUI3Mjg1RTAwRkNBMTFFNDk3M0M5QjUzOTNGMDM3REQiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6NUI3Mjg1REYwRkNBMTFFNDk3M0M5QjUzOTNGMDM3REQiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENDIE1hY2ludG9zaCI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjk3ZjI2ODVmLTcwODYtNGZjMi1hM2FhLThkYzU0M2U1ZjIwNSIgc3RSZWY6ZG9jdW1lbnRJRD0ieG1wLmRpZDozYjQ3YzlhYS0zYTVmLTQ0NzEtYWMwMS1iN2RjMjA5MGViNGEiLz4gPC9yZGY6RGVzY3JpcHRpb24+IDwvcmRmOlJERj4gPC94OnhtcG1ldGE+IDw/eHBhY2tldCBlbmQ9InIiPz4B//79/Pv6+fj39vX08/Lx8O/u7ezr6uno5+bl5OPi4eDf3t3c29rZ2NfW1dTT0tHQz87NzMvKycjHxsXEw8LBwL++vby7urm4t7a1tLOysbCvrq2sq6qpqKempaSjoqGgn56dnJuamZiXlpWUk5KRkI+OjYyLiomIh4aFhIOCgYB/fn18e3p5eHd2dXRzcnFwb25tbGtqaWhnZmVkY2JhYF9eXVxbWllYV1ZVVFNSUVBPTk1MS0pJSEdGRURDQkFAPz49PDs6OTg3NjU0MzIxMC8uLSwrKikoJyYlJCMiISAfHh0cGxoZGBcWFRQTEhEQDw4NDAsKCQgHBgUEAwIBAAAh+QQFBwD/ACwAAAAAyACmAAAI/wD/CRxIsKDBgwgTKlzIsOFBUEccSpxIsaLFixgzamz4adLGjyBDihxJMmEbKSVTqlzJUiUcDKBaypxJs+ZBN1iE2NzJsydIHBjstPFJtKhRhfmY2NB1tKlTokIK7NjwtKpVmT5ssAlwtatXkaJs2MCw6qvZsxSzVbBxAIsKtHDjIhRQIA+dWGvk6tXbxo85c35K7B2MVowNc6p2cCXM+Go2Hjv2XTnAJF/jy05V2FGVJwqdAjoxiyZawkaDKyKA7BA2ujXPL6MapFCierHr2y1XxDvQgACAfZRn4R6u8pMNdA1YxMBUzs4n4tBHKhoFpIGIISkaBI7OfSMOHim6NP9QQiRKA8WDuqu3aGQHnX1AABBh0cCG2/X4JW6QBAQIphg6KNEAN2yUkd+BCh1TAXVdRDGEDh4AsY8NRSDo0zHCHeWADXkskJwOEsRwBRCU0dDUMdElAcogGRZVgiQN7NNABzrww0t49GziwFE0DKILirjNMsgJWZhY1Hej7LOPOQBIwI8O9C2wgxxHCWBCFrqscJuQJ4jTgpFE5TPKAfBdEQMv/QQY41hJGCVAC1RkMYiWo60wpDjjhNBmUVt00MU2DTjYT5oALLAPHc4ZRUMI44yTBSg4iIaDLlngOU56Ra3AAwESAsFCjfz0M8GIE2Zh1DGDiFONOFncIJoDJqj/Wk0WOxbVhiSHbQOEB4/w4+sQBDSwzVhg+jRIOuKEM44JAly2iglUVFPNOC1QYpQoAnKDWAxODqqDCF3sQ44dRhj1SRbSVpOOCZowpkIL4qiKZwvlEkWDK5xyEyiag/YzRIT7bLPDFkYJYUK61VDRgjGDvTlOuo1+WRQcHbwH36eh+sqLiEAsMFaLPRlhwsPSNhpCs3KtMgjJELcAMk8D+GkOfB5I0G+owMZIxyZ52dsCy9WEc8IgQMIlALoIT6snUUaMEkWneXDbT8ZpdtCAoTZUUtQ1jCa9bK1o0QBt0tWc4MPLNimyzMz6CtrvoEP8FjBlDPskwBwnJC0OFcyi/5XPz2SPc0IZe/I0SzEiDCijCDq8rfEEKUhITixnEDUL3tKGA3GexV416QmaBy162bpE2tMay2AiIXwADHFzxkPQp6QNUhS90+dAp4ulWTeMLK2s6Z7AlE8BeKA4EClM8PagoQYYLnAKWOaTBnmTvaoJnT+1KJ6jyyrOCTH1pIIkBHTBjb4sDBHq6/1MEUMeQGwzrKk+3VBpOPj/HrQ4IZR1lS7VSxr+SAE+n4giBnRYXReU0DjmrQ9uweLGhDCQPZp84mAC1B3KqvIm7oWue63qCQ3WYTUlmSNq6pvaA6emgw6sDlFD6ckFxxEvsoWDCiGoYFE00KiHfRBhJqjXTv9KsAxS6YsAQ7DZ1JjXr7ipwlATKoLpdjJD/XmtgE8RGfCAB7Eg8kRTANsHN4DQASJMzUnreyAvzKOkA0SvJ8YYWTi4iDAvSa8pZQig9aZlgrfsxAhKCJaSgKAKbmWMalNY4rdiJEY/RIQnccyc9ZJ1Alc15W/JWtUPu1i3muBgALeAT8B6o8TlMZEfceMGFIkFSd8JkGVe0uFO8mjF3EmrjzvJRwcStw1DdYFGr/OVCpfIj/AoaWfP2Ukk95guVlmyKPlgFMt+KC9xmKCTNBFFJ1S3jSVFrVvsW6K3eNlNCtluJnHk4hYhdjKjOABpdNQbLmuSj2QICIq9QdMKHTj/KJulMmD7UEUBNkgTFWDQhpIURhawyRMcMIqL1EzXPGmSjk6ER377+KXrlOirB3aUeebZxvnYQBWbGJRkP9yk8IpiJVtab1l+nAkNmhCD1S2pkLxIIzFPObUh8HIfHmMCQWVyjSy4dFWwbMFQbfJOZpJtojKBwy1kp6TeuM6jVAvmFABgMXGxwQc2od44NrlHEySzJz6oXjwRpiwvzmQWPLiFKuLXzfGk0HH9VKEaQzo7DBROJmJda/40JzgDwTEE3HOqRM/akjMsI3Hngw8mlMdEJoJzmE+yWjcPpaOaUA9hsAxcO3lytMAxE4stWUUF0KA6btQ1fQ70qClthsr3/wFBgrk4QO1mggNQVC9/GeyiEG3i29ytVVqoZUkZliEgJQ2SV1ndaUd16i+qLuAABWCoSlaBN7Ketl23w1zm4snFleZmAEQgVcCQR1nHTfejryMCbYAaMBuEQabiVWzwDGuTFcBLbwBeVdl88NeUOIC5z6sq46jLUWGe0ldTGFX8XOvGO65EAD4Qhn4lSa1zyuRvYw1dSq3XggKT5BgBIIIxN0uHJu0ztqYUp0+vpiRu7CAdMqEB4EomSWYqdScGTdcmNbdJL6FtJMZQwtoW0M0j9oNfw4Sxe9cnAQBI0LltsXBKZrHjOsrLelCdSWk33LLhnjgArTCPawfJwOXJtv+yspXAGhnp1T+0pKXB1ZyqPkgKWtmkt3rUJMke9jBSCIMUpDCBlkfigA7EAB0TluwEaIvXvGKWugGSkAQXgAkKssSgiD40KaZ1VGn9YXgFNcEG/vAHH2Q4HKw2tKtZTQUtCEMcAajEM0fyyVZEsMYfKuWDKxvjUElAws61MVhVcoNKBCAcwtBCOljt6kOzehyt9gGrtdCCmKY2AEBowgBEQYIBUOEPohDFH4QxABJsYABNaAAPeCCWAvRsJJ8QQQzIUWP4cKN14kzjISvNzyclzrkTlKVG1lAAscy7AU0IgBzKzep0+4AKJCCBHAbgoQD4ryWTcA859N2HPlghDon/iEEcGEGEPiACACkwxw7IBBwMTBEkKJ4PI0VKyinrVOA6pXSVyQHFfZSDciU5BgZsoC06HMAcUQAAIvowBUagHABxsEIhHhEDFpjjHH4Qg0wEgIUD6KsDveoHEUAkgbX3dM7O3cbOlqqRRscgF+bYLHzaTDUHOzjKPBWmBATpXDaRxAGxoIPeAzUENIRq7Q/qQwOJAK4FsAEPMqFEAd4zI9cxj9JLjJ2wnAsEP8BBJNnAgM5dK0EgXGHSN4vtIQU+bG/N17l3qdxINrCDogMKtrGH7yL3cY4KZP4S5NhGFxgHY4EPX+/2FQkgEZh3JQHqOu91804DjtklQm708vvY/0iKwHTX1lUEZvyoMNfn0/jRQQHZaAkl7FCOjAJf/f2SwL8khNEFvF/hE7EKGFAIsrNZQBA1vXJItAVfgCdO7jV8V5Z7IiEACmAxGMUNHqADiSRwpQQljKQAHkYSlHAJeZccwkZd/BAi8KMkC+B/nfURBzYBcyU/r5VExUZwMcZ97rOCqyQFH7cRaxAIdGB+ujJZl/ViEiA75ACCjWUHnEcADWRZDsgLEXRl3JA1H7ECFUCAowdQu6I+fgdffgd466dTHqh3MBQS5NdNNGhVoFdw/hIF5iMPTMgSDlAAybcvDhhjLZRg3eRG2lURjhUDc7Vm3NAg/GRKL5aDWOUvHv9wZYWHAUdWEfmweUW3AAsUhdrXTyFVDvDXErqgAOQwRq8XTis0BLYlRkBlY1SSEavAA4VQhUy2dzXSfXpFe3uIVQ4mAWyEe4FwbxnhBn5gfYNkhMSGV/MQOUqCBTeXEiuABaowRuQAcGKYVR7oXIaCXYs2EVIFAPUnUvLjeln1d24WXXCWi0NAGy1ofZ1mYhTxCQVAcxj1IbF3WWeUiudAAjKhIOfwXHeFV+wHAKpgDlfWgrRDJxVBA/EQi8ISWTICTLPFRFNQhmPIU5aWjIoTMOYQCLp3EbOwdAEjP2OEU+t3i00EMJaHeS1xDHjABuWgK9fBPuSYJlTlXOWwHRb/UQKdAADmsDrd5B8xcFXHSEyzN13BVGktNCCQ2I4XcQxaEBkhKUb0mH3Elo6MdHkzQQJsUFVIBJD90GAqaFNtFAunRxECsA59ECybtQDoo4mVBU59l4g/1z4OFmEjcj7dRA47sGxpsQGBoArWJ1JA+Qiyx4cs8CfVoY8yIQps8JOv12CDMpGvMwRWU3RtZAePJBFa0AoeMDOqCB+F5HnB54D4h4uxh1fDR4w2wAQAaBArkAUNQAeGQoMeUkaFWZRPxkYE0ootUQLI95MZyIjLM3g7h2WxsAE/qBDGQADlISyLB1vUlVPkSGU5KJxpEgNPp3f7gJMOIQBhgA40R4zJ/wFllbaLy0GQ3HAJMdRYl3Bl1iGUHKV9qHgF4HdlB7ADUrCNBjEAj6AEfggf29A67EcERPAIj+B2H4VGjoNGvqIDfVCgjyB54uSBeGkomIAF+mkQxiAFNtBV1ncaEyCdC2iUHaUmhpKeHckSoZh8MhIF5LmJ66MDAJAHdOZc5mADCgAHdDcQRtABaGBMIXlEicRCifACX3CkAcAKj4AGQ8mAaocIPHCkojAAMNAHnuc+CaSdOxAGzWgQAlACDddv1tcFKFSSgLeAomcoSwheLYEDFRAZC0CQArpC+yRMMsobCIdlO4AF6eAAHnYMJFAIJQRQqmQOwdkPfcAHW+APjP/aqAGACEQghsdIBHEwB43KqINAAonApKhUgPJzXQOFEDiQD1TABDPnmarEZA2ACQDQQD+Hf4MiYRK0A8ZHEwGADmxoHY3zd75CaQ4WNzRKX3l6nwowCWeQD1PkWLygXgHTNsxDBDBgqZfaqCfAB6DSiKFSCDwwrZf6BYngOnGzWbRJIcVyDMbQBgGgADMHiZC4qq2qiIoYKmhwe4dSITQxgugwSI+5h2TYT0QAcw1QfSH5qfd5CQoQAGKgCw5QDIUAWeezabtSIzqACNLKrYy6BZvagIPSB3GAAxbbqAPQB4NChaM3i6qwCWVgDCpQBoqQrrGwA3mgndZnDrIBILf/WJoBByzPww0cWRN3+B6tx0DTCa8jOw8s0B9ihFG9pErlQAdasQmjQATL0TGBGSgjKwFf8LGXSgJ9YJTMgwYUq7WNynJfCQC9lGzyEw8KYAeBwAYi95mEmlGe8iTB14g3EyID+YdYADZZ2ZhSGQWXZovupX9KQJ+aRozieoAxoHPYyGaNw7Fi26gaYK10KgGFQAKRe7Hf6i9qOax0QA7lIEFrFpiDdBoeMAQTKVt0ujwz5lw7MABD5AeQ+IVfeZr8+kA6MAEiQKNiKVIStHx9YGW3hXBdkAKhgiZakLmMOgCFwKtEwAcaoLz+8AIiCyE2ZZmkK6ytt6oiMAFRyKth/1iXsipGgSAYTFUA+TpKLlqdC6h9vKADMSACVyAePjlGyYMGv0aMmZgmVuCx04oD/nupc4AITKpXfbCt0qsFjyABNiOHbEiMA9usutIAXYAai6tX59h3Rvkt4dJN77drNIEB/aiKQNBm/HqbHiUBuRtINNoAQNCTStAHYYRRGWW8E3m5/yu2cWBGbyMBySu9g8AHjme91hdZEuS7/dEADXAABKAE3iuZDBxwTrqgU8uCtNMTcBAIrKd8V5CCEqmgY/heMdoPMdABLKA6XZkdRKgk+zsEibCojRrAHxsAhFmifDAI0suoPNC1iZS/CKcvDUAOV8ACjqZ/DCq45ci6sv8jQeVwCcBYE7PABGQSWbp6mi82cDGmwsfmAYtbQps2SCnAC06CBtAbuXKcDps7NUTACHm8vCL7JABDw5tFyACQgiASTAxobESbglYmsMWHkLFLkGIEBC2WQr1Kmhl8yWkyBBOgOlHJxiZMBFbQyv4wuXdFBJjbylsgZ8Ymh3CbUSIgeQqayedYzrWrZmKUnmUpQhVYxLIRokNLojcLh1OwSL3EZGyJPId0wJcqx/18qTBQi2mSta08wI7niPwnrogBcMQmeKc5ouqHSgcHUJSRnDsBB7Krir+XRNRlktsHh4QyVzW2WQtEBErUB9nsDyswA9TgDQKQw43KCpHaTz//7A8C8AvUMAMroLUhgAgC3Q9ySIQ815UYrFe+apGYZb0zk5eBkJk+kQQVMMKqOCNuOc5yGU4QpJQIp4fCVAgDwKirgAAjMNbRYARaK9P9ogNwLARmMNYjgACr8LGTu6uo9Igdo50lDIa3y6tk+CsA0FryI3MDEII7EYRWCB/0EJxzCdIRzUIe8Dx4faiq/NX+oAxuPdbfcAwfK9NUtqjH8A2XPQK4INfW+jY5k7RNVrztVZ2FuaDfV2PcgCiMVRRPuYqudYDvSpRu1r71CDnDm6rKB7jLg83+IAShPdalEMeXitZPJgGL6g3HDQ5CYLFz/UBVdsR/XMk3SJ2mSbJ6/ydzJdUUNKAAB4DPPPcfdF2nwyQBQ9pEEw1URXe6y4PS/oALbg0Obh0Jyh3TAu3D/gDaY43fY00NFtvTjveri5y08BE17e21WL1EckYf4Dg7TOCORFEG8Zinp5HbXnxGl1VKvZqKLCiVBNAtGdN2L/DfAX7Z0kADFhvQ/dIHXzAN+rDi+W2xcwAAB90v7lOI2U3UJnnUKcwPNSlGbRGIRlECfpC+NUamuU1wM8m5zmmFBHm6DfYkVnANbb3iAu4L/iDHPS2aBxwMNi7gZrDT06oF6eeAopenvRSxUvyGOTsBgqR3qnAJ5nsVT1l/RdwFdMBA9hi+MRpGn/l7P90vrf/QAW1Q4wIu4CPQDNy6zfyCSk0wA/c9AgKuDyrArcyrQkIn4slWvFkF4itkMzKaHUUsLn7Am1exClKwA/03zEAgArzgeSB+u6gOwSQiNUvU3rfgBjWO6cI+1mDA6YVwM2jAApY+7Jm+6dP6AjxsSq1LgyGpq7lckRCSB+ZzZdtQDjtQBITtFDSAATtAdOlcVwQAIDnVPrw9TjHChu75KfnnUURgDdFQ5mPt5dNqBenXUbfwCo7u6NGg2Zdq4DOZghImUv2muE4Cxg74CPOQGmIpLufgg2hxDSLMb3G7qkowBKJJmiFyADaFl0BpzKSJBjAQCZdt5tcwrScgH0TZCc7/0A3MPtb6Pa0BcOy6DTslxJZb3ZXtrVfvCwDmsTqRRQd+8AUW7RVJUAR+AJj9dohdoBxrHmWnDdvyo91vs4H9MA/L0As2bvPcCov7xAsdAA1hPwJBwK2sILKj2fDFZD60eWXk0dHMLALk4JzWtwB3Lgrh3hU4IAaXUN7iWlWY0AHeG3vpyH956nohmojLcwvEEOz4jd/JfamCAKlh2A+3oA2XPtbT3a3c7NDWSK/cfhr7pD6F68LseiiB4AaMcQTxOLrpXB2zkSZnhGwjXVWADofr1wNfH9o3f6nUyzw9cPxTMw+JgPaXTeCXqgEwUPWS2i9sBEUKb+0q3A8eEDnD/6vgNoYFKToYn0DusqngP9kgSjAP/vLe6dw2otykTNQJMaDyZJ0P08qf/cIAqOAIDwAQPfr1u0Us2giECFb5Y8jwBRF+/AZGlNhPYkUdHoDs27bPI7dtQLgBIDJPSRQgDTxy7LiADhsM+f7NpFnT5k2cOXXu5IlzlRw7O8hxXMltX4MDMXQA2Gau4z6jHs150EFxoISBEy1KvLWsFLVSsxoyDJAITUQGBiAtgVSDwcBOfLxRa4ZjrD8efSZerMj36iMWDZ4u2LdgQZcoHVKkNOdxW8dt5c7Z2bCi52XMmTXfNIIhEJ1yj1t26aCDV5QGRrctWH2UwJCssWXLtqUEw//dEDweVe3XAxW+JUvUubA4cAiBMHcFxSmE9WLxiNCjD4mhqjHUlftSbnz8EeqBQBiMbSZf3rzNFUcUBDoA0nU/HR0EQ2YJhA4A2LL5Pt/aT0IhPngYYIAXEClEKwYcCS44SFARyCIi+oGBhAFIYCQRiLJ6LjqJJIgOKx1EEGwl1qDixihuCNuGHDr8YOKIVc6TcUbNZimBCT9sMCePGIiIIY+NouKImwZEGIIfrLTSqi8NB0Kjj0IK6eNIreZ5AAl1hHOik4qKI4KIPr6coq8u+euwuH6mmOCKjRyjj6h96ACPiRJooPFOPHmiAQ4mSCPiOJW6cw+IK2Jwbqvo0Gz/UsMNyxzoFkdcQMIFBxFFEk2KplCUokT3k2gIJVRKMbunDtjBDgzgsDNPVlu1KYlJOiFCiS5WeiyqBkqjiAEGeEF0tkb3UjJRBhJBpZMHZ0sS2C4V7U+2KLp4ytY44wmgjWNc1VZbGoppZc02syMyCv8s6sGRGhLhlYEeeEm0SQ71I7MfXnqYZ79FOWU0Nn56WHcC2abIaJ/GIFvNHBuKmGVbhlsNwJYhAsNuYu2oqogBJPTAxwUDHEFlgnXZvfeqfTftdKtl/Utyw4F4mSdkBh6owQAnkKg0tikCi0pIOmJZo2GgaTxjGSI0us5NIl+LDWMQFtFDD1nUgYRjdD+G/7kHrH2djRet+dNvHqxhZmACmR2hGQl8LNADBHXcIpO6A4AQdCUbmBAgaLzJE6ABIiZIYT7WWgOCR9iiY8AFPSywgAMOFlnEE09A4IAtF5wwoOMaUHlA3XV16CPML8EM/cs+/OU1kQdQqcERs52QVLin9fBkEcYXWaLSDUOUdlrsbDgFh7yD7wmHL1oZQkTvODKsSB0YZcAJTxZfnPHpQ3HaEz0ctyANdfCBBIlJnSBh/PFfMP8FHsgfQAZJkYAEOHU4wN7p7EPhQHHFa8fngXmc5cXv3blpG3TYhAOEd8CcrGEZffCAdhwDEsIAIQVMksjzEkc9/OXvftNbnPXot/+2C6DgLiNkyDuAgb3sLcJ+jLtfC10ovUXsrwfvssgQNAKn7NgAA3dDYA//kY919MFvqbHVU4CgBN4szQB6YGH+pLdBDD4Rf4cIIQlH+AZguLCFGWwiBxUXw0SMjEm8ANSJ3GOUcuwgDMDzofCOEYBWhKgBhPHIAkCyjQYQQAIps0hamIg/LTYxkICkogitOBYsbjCDGlSkBhenByQAbDbG+dF1uuORA9jBgG0MHhyI1sA2oUgqecBPsyroiD86MoqM5OD9CnlIRGaxkYKkHgu3CMle0fAixxPVAz2iQx5yEmgqOEAhhuiewmzjRMxbVB9rkIZFSG+RrHQiB18JS4b/JLKaXcSgFi3gCRe8RV/Q6YffwlXHx/iOjcLc1gpIYDzkYecp2+hCCiYwpmbOAxVLoB0UWWlLQLLwmthM5CAZCUVF6sEJb9FPbDKyETp6h4CbZKe2PFk07SAzokCgyrNiM49EQCJxXJyeP52oSE6ow5DYrIMsqclFRbJQDwZggCl/tUedZYduO6yoq4wxCiGmoAtCIlEDWJAfR+3KBdGjJSClKcj8AcMLd4lABO6CAnUcoppObWVA5eeImpLJTBL4UZtu5RF6qDFbPcVTEnTDS4pFZXCGMmWn0sLUknJ1m049hDqsyhAU5CANf/VHYIGRBpJ2UZUlDQVYGWVT+Mgn/6LZOUAB2sBWPG3gFkUzh0geYxii5Kp5wppXgqKp1xeWlJYcOEQa7gABU1wAGIfgQB1gK1uEPjGK3FRcKNThIBqW6138+JsyebePugUTs+YxggiCSkTIqKYBUeiakpTkG352VZov7SYHOAEM8PYzFOCdrS0b6UXd1lIPkJiA1oCFKRtywxwngsolbVCJtS6XPDSIRyHQoDNl3tEjGynlkq7yLoyN9Lzb1W4tUxtTB2s3r4u8Hzhruql8RUQHAK7jSjL5Cf2WRxTP6IMS5Cuu7hQpPxg+1EDuOs2ubpGkEt6tN2Eq46eqjaaTtG5WJAAux8hzG8kNsWbWQBVwXRK0If+5wgQ89CtdnlIWUJ0whRcb0JNyFaDozev9ZOHY4fIrZTpQAhDsyLumJCxGRe5JPvgGKBP5smJJ/BW/tgJSkTK4lU315oJXe9BVIrR2S+CfR/eFlTF9igAqQfE+VBELOLCZJ2/sA5nNOqTQHnVePPZQBQ0QPafa2LwO3uKWQ61nK2PQwu91jlX2QlYgTZaONlDADSStkxIsoxVlJZXgMBGDFevysS6uAQdCsVfVvtC8Wj4pjrcKaPzNlKGbtrOw4lOr+mrUBlJY2K1tIgAWQGTROp1YA5DIIa+VSzoSmcBSsdzdCHcX0Oddtp4RuojfJutkS2qxylBD1KfkgQ1/8Hb/TWbxVvmQmzBJS9nJIHsxR3iC1DENtYzpLeguK1aVFQ5nsOLVKQ5JYAgAUMU5KVuA8RT8H4q4xVK4IbchCWmuo+13uk+G55Hq9qmllmK9HxzIWW5TD2BdllU0tW+SSUSO5I4KMAt+BiV8628oUmaHcwWRZvEL5NLpR1qiKe/cblne0wy0lUO93kT4amUNrSuUUcM71XBjB+nwtgCaQIQNMxrT2Jmuuofl0U1LxF4Zw/jOd9tsaJsaps32xI4xnG7SamXk5Tga0jJJ0RDj4GEPNfmQgKCKUjKJx818ToJksUKew5i3gwx0qUmNvxg+YIbwcrW+RI8REZUITkZxepFz/42GNaXmKUS9ekPfW23nQe/GWx31BjnBiUNEX/qcOHaWvepgWTj+UsIi55Oz7mPiEjHIJ6LDfdeJ2U8QYEoSm9jO+m7dh1tF9MXpwQOWoODUr9IC0F+cOtRxAQAMwAtQB8SCPk7YuEXyBCRggP6ZlzLJujOxiKPjh6VwINGgLJ/RrySoALyjFVJBJiA4APzYC04RK02pMyjjB9M7rdWTnuhLAwDMgTpIABo0BRs0BRpMgDrIgRy4gDQIBa3yog1ahDRwC8DTuu9bEldbup2xlTzAAuWqKJbTgeATjaqruuKzPa8JLpbRl7SQHHpzQQu4ABlMgBvMQTREQxvUwR5MA/+tCiRp474UZJa/45epYwkcShjL6CkHQKKIET6kKYw8Ei5nyQp8cpZx+hVeiAEXkBwra60LmEEcTENKrEQzNIU68ME3ZBxPWCgxgqxCHL2JABEAeLkgs5VyGLiemoV4IIJWKDMhy47PG8H+CDw55I+VeY4eaDeJ4yBOgME6WENLHEZKtMFMzB9wmoBkMRkeCzyxqiHkiQreqSxbY6cvsIUfYxO46wgi0ZX5E8VQ9BA+6o1EWKoNoqJgJEZ1tEQbFCwQcAFlbCbkcxTaQ7rwawkcGjIpSIJWoYE9xAwFMo1FO6PCWIlBxDBysoh+G8XR08VEgB4izIF1nMhhNAV3cIL/RNA3EjSwW5RHV+uHkVuAcJmnFfGDcdgMHPhHmmCjWaAAWMgMGmiAQoiPkTzFmWOWiug0TJGXhOwUCZiHeTAAdXCHSaRIo6TBO3gDGYjHj0tECtrJRHkyKEMDEQE4+qosEMsMWqAAFbCJG1gBHKAAQHiCKMwJzYsjXqMvXxItZmxIEnzGj9QKXmAAKDCFNzhKo0zKBIACe+lJUPzIuByIE4Ssf+swPNShVekJFbAHdqCAdVIBJqCCWviAVLgHezCCnhgagdS7nVGmQXSXnOTJvmg1M4HLSYoZGUiAN7gDvBxGvZSBjJQXyNtIS4kX42u1pbCOE4koozCHHdiCy8iH/x8AhEb4ADKYiXxgAhuIBzVohAzIgHv4gbKsCQGQh0pLOGoxESD4tSPRQgk4wYTUirVrRq0bCKypARlIyrtsTaR8g7uUAVRgl2dxtVwswUTMl+OroYQjSey4PJ5IAlgAhOe0TBUQAAw4hwXYA+d8zgwABArgR5xIggFoBTQgOe7QqY4wNzrDyWe0FHgpmQfMCqBEBRmoAvVkzXU80QSoAih4AHbZuh6rR3KiRwi0zYEYSDNSywVATJ0IywV9zmH4AQzYAaP4UQZtBMe8CRqYAwBoBX74NyskCjxSmtrkwkaJiMGEvFYDR3/pB/Qs0aS8A/V0T/fUyyqoAhmAAgfBmv+kM7465Isp6DSQqz0brSEAOICCuUDH2AH8ygkKyIBUYNDnbIRM2AHWEFQGvYcPeEmaoAEygIUPsIRnqEpx8bxfA81aTEIzgT9ENLAukUoRZReyyRwokAFTNdVSrQFVlT2saRdhE7MQ3cmOjNESdCjsrLqi2IFMoAAykImamMxARVRFHYMd2AdEZdBUeAJa+KFa+IEPAAQuyAB4KFaWUJE6OqLRMr6nzM/vu71921I0AZuwYVOX8ZdWDZYmabFLiVWH275JCq6dlIBxcxOP0NUGfQJ74FUBEIBaeIJhONbn5II9QAd0AFggfQJYsIdGuIcF5YIPINaiyI48WjGe9Mv/QnxKv/gQ/CStJDS0dyU9eRTMUPSxd/3GrCOrktuZBdiBMfiAaG2EyvyAH6AAfzXYgCWEHbBZQL2Hf0VUh4XYOmKNuaISj6W2PTI0autJ8OtW8hwuJjla+8wwkuW6dSXE+Uyq7xsC7CwMlv2Ae0DUVAAEQAhWm3XOMdBZneUCNQDa7iCNbKW2utpCOQRZK0VCt0S3j61DtsMUluFQWn3Xf1vZMVCDaEVbnW0ENTBcm1VbiH2MPALXdeMH8JxRvkXEWu2PLU00pvXLjyw6joRKj3TAYZFb0c2K3ASCHWgHwlVc1m1dQW0EtW0HQ91OYAvPUPQLWf3bhty32Xy4TLXYQrglz33p2Fqd00TRWjZQ3cJ1XeZl3dg9hyOKkIudWvnT3W0lPRgNWdy1M7y9z2Er2WETq/nT3A9tmXrYg+Vt3mMNCAAh+QQFBwD/ACxMAF4AJwAUAAAI/wD/CRSIY6DBgwgTKjyIA4e/FQUXSvTnD8eqiAgpGkFg5t8viQopgvlm5tuMhP5UdBQ4AhfIgxSbGRxx0iBFBAdHgHk50B+NlSyl5bPpi+U/cP9GROIp0J83oyyD/OvTVOoIpCz1DZVYKADFpQKxjvgmEMZNluBGsGzm76W/WWbUDkwrTcAQRBr8RZMbNulTiX1Y+TOClG9ScEL+SdCSLdphtYU/guQzqOjVw0lHyCzEA4djhCP+LuRFJAwtpGlRXy2q498gnDk1v+zzYlpctEnr/uOlIww1zIX1GeOJaA7YoyzJCiTiqmjSgUqZ9qkg+XLa3wL5ERmAUyxNpkNiuEzphvwwGYNoPIxnOUIZ0+XJamaWPJBfIT6EIoGThuvYe4F9JFNKNOCYIdpBrXQwgBDT/GcQESyIIgQyEj1iCwwOIjhBMky1QlWGCwUEACH5BAUHAP8ALEwAXwAoABMAAAj/AP8JHCjQnz+CCBMqNHhQ4UCDxmbMEOCw4j8cBoWUapbEocFm+gRKA2Nxob8gA7+pWOgLob6VJR/680ZwRCQcCA1GEjiCp7J/DUv6oyEN4QiaBP0J+TcC3D+nI/QZi1nQW8+mPL/lRNrTKdNmVA3+ZDqwqYpH/0IAHWuUWthj0RCCGzGCZEF/CMgOnMu24hx/s6R1xcq0lMxIPY3iiqllqOC5ZY8K5KPB31isUBfH9AdXLl2w/R59OZmQ7oySQwAARTzXa1MyA634s0t27oilMXmQ1ss0GqiBhYBG68pzJ9VEW8hAhjrCLcEYJ8BGlk6VzyDNT6NOJUgEESlqdOn+PaI6kIiVG4jpgqNOUAeAAM0QKAtGnmAfGP+8IaAG26GEQixUEEAA9SHEjysDBDBASa0UElyBCOnQChEEBQQAIfkEBQcA/wAsTgBgACkAEgAACP8A/wkc6K+gv4EIEyokaHAhwoIzIkUKcsyhxX/+VgSRWMohDhz+qA0cgQDkxYT+cEQaKXKhv2YJRwQ5+dDfTIQjYKL0F2kEuBECR0gTQFOgPwH6Yq5ESQZcUKf/RswoinHq06jgyKCE6dNnUFxFCyqL+u9nUKsEb2LtuvRkwZVdy0b9hRLsQKgj2l4sGA3oT7xjH7YEOlKvxbdB745o2cfoL8ICnY4I7BANIkEYEXTFO6LjwEH+fCmWrNYt3asjRoAZ+IjEvyRmsAYdIfqiDqOr70Y1s2oQwi02deel+i8Ez6epWz76jSzaSH1kvhQt9E+DEM7RVln81HNENDAViAwzoconTLO+4CJRKvavX8LbMEhYsmStA3GErPDMj+OhsUMdrXTSDxH3IUSELfx08sh4AwUEACH5BAUHAP8ALFIAYAAnABIAAAj/AP8JFEjD2LGBCBMqHIhDQD4cCwXioCZNXzQwETP+8ycAgT59kVQs9Kds4AhwvjQq9Lfqm8loNBDi8Ncs4QiXKhH6C2KzpE4EJ/+B+zdiRM2cG5NIG4FwhLR8AznqE8iUqs+c/jAiBFe0VFRKRAcOHREJ6UaeYqlSi+qVKleiZlYhJRn2LVcEUb0lHBt3Ll63VMsK9DdDIVczyLJgxWXzrsBH/lIGNfkXaxCmTIcSRbtxlrSwArniCvEPjcqsoTMTnRFmMN3JRIPxmLvCTFWq3W7oTFl3BN4hQ1TO2fgL8AhqPIK75jzCTKZlOYn8m+PPn2CiZW0hHKDBX6loZhBYPFr2yOw/Lf6QBTFjRhk2W1MGlufD48sAZv86lTerox8MEgGQgM0ytvSjEBpE9NGKLdqZh1CCQ6DBi0IBAQAh+QQFBwD/ACxSAF8AJwATAAAI/wD/CRS4wpcvAf4GKlzIUCANML5WNRSYL9KIEWaaTdwoEIyZi9+ENFz17aJJXxwbCtFnEiMNhkEUXoyUcqE/BDJHUFu4ItpAcP8ugqk5UKRAoEGlvfyH4x+loAtHxCTqz9s/pEAvahTob8bPq0FpUlUmcAQ4s0F/DfS386zMb0T/+RMbFOkIXGunKjwL91+flP76ojU7AifXIIRl0mRV8+Zgu0EGcR1at+5dE/90AN5ZmfAMLZr9qXCLNmipClS9lrUrxBXXmzL/6WsT1x+Nj1dHCIykRaE/lKX/6W3sL2bpETOS+fanFqrAKbxqw9Y9EI3NrpG+BZkEIO7aVb++RTPy2qqhv/MaKkgo713ueX9z4vXp13DAvxeI5rcfaJ9RjD78NNRHIYX0IcF+CxFBxBQMBQQAIfkEBQcA/wAsVABeACYAFAAACP8A/wn8l69UKSMDEypcONCXtxkCGP5rJm3ECHAzJGoU+MviCDO+FgoBJ9BjyI0LS40o+ZFGQn8IEoIbEQmlwhVmElqkllAFyX8/LQqxOTCjwKDRVgz658/oQJIjvBFliqskyZkjfC31FwToyoEjlE319+3iP7NnZ2wVe3YmVARLbeKIZtXsiCCnmCqzGxRBln5yzaAFG0QKVattwwYgYtNfzbZgZ/Do408l1KDemhD1t9crWDAdmA6FXLLZMjSNS5X0bMbNM6aOF37jwbhxPn0Lqw70B+Ys0LShN/v75ZukPkIxAMP29vXfr3i1Nx9D8BVcs399XvrzpUwZmAASlI8rxTEDATUy/6Lv9sf+S6Kp2tn7w64xBI9HQ+AvFBTHZiH9DCWiHkP5AThVQAAh+QQFBwD/ACxTAFwAKAAUAAAI/wD/CRz4zx/BgwgTKlQIhho1Xwsj/jtWClcQFRGpjdgIrpTEhEkQbBwhDWLCGSMEjjT5cSCugRvNJNHwD83AY9EOjkDQcqAQcAQ3/jJIEAzCEeBUFOvz0V+QgUD/jcj5b4hApyqjSm1WrKW/SP/ApQSKtA2Mgf6UZUUqlVoTIh9XmVmrEkwHW1cjsdU6glqylgL0jR0rtVQHtGCliiWrTJIOif5oSFtL1tAyXjgKisyq0nLTFdGQEg77qpNAHP5+6RRr6XFTnorZdnNm+iqYwVG7EasN+enof98Q4b36VSpBBEp4R/RnTGvYEYZu8SLozyjbf92YKV+ONaXAb1aGoz71V0rsP33NeqLFoTZlNC8MEvrzJySIt13/mKqfX53aDE0ELMSfPwOoR92A/xTyUQAGJpSZeo80iFAhEhwUEAAh+QQFBwD/ACxWAFsAJQAVAAAI/wD/Cfw3S8DAgwgTHsRBg4bCfzioSdMXScjDiwLzIdAnDYFBhMpGiByhj8wgjAlnRRs54lu2f/0EzhgxUCQClAlx0RQoMkiIgZEOgvs3wlcxnAIFSBs4dISZMgJVDBU4dUSQJkj/zaRasxkLoUxH3GyFlBpVmk2DEGj16+E3VraQ3kS7cwQuFmja/gO3U+A3K3FR+gsK9h/htiP4Tv33DUZgjP5u8t27E5fAZjUV/0MgAg1Of2YPJhZ465+xqZOzDvQ3Q+EIS6UjE91LFNyrTlmVJjRjrc8/f5gT70TgSkdWf5ZnCwwiwvjv5DTNUPr3WPCKb7NHRApgK+bvY0HM6EJDQKtCIdW/jSmTJg3XLEa+V/ublc+fIABE0Pvb39Cflke8ILTffi+ch55AA2oAQ34XPXJgQi8w+CBS/iDl3IQXBQQAIfkEBQcA/wAsVgBaACUAEwAACP8A//1b8StSpFICEypcyFCAskgIwDDEgWCExRG4GGpcmC/axREIFQb5aLGZiY0bK37UVyuAwFlmRigc8e0fDDQoFfqymBDcCGpZBM6Q+Q9cTyHJcirERdSowGg+BI4U6FQgQh1KBUaSWbUopQ6tKnYVSC2rwCRmqHJdGEngCJ8JcTUhkjWfPrdFiXpj8a+t0bcJqc3NOkua2qoz/ulQ5vavwF/FsCrFEU1tT4kMAf8Dk0yyWa5EpR3x8E/I2BHd1vAx+y9kzxEIthT65w8BQ6C8WNOQBphoswCz/5G5+0+mGWQD+rD2l7h4cQT+XrQS6M9XzH/fVPizQnf5r7vgEKw1CoEIJ/VVzXwd83cCQHez/vwJaCYk/r9HCuPr98eDdf79/rCikX3/IOLfQvZ9IYFSyh2oVEAAIfkEBQcA/wAsVgBYACUAEgAACP8A/wkEEySIEIEIEypciGMGtV/5Fvr7NaLiiBkh/g1ZyFHgMQQWpZH51w/hDIsVwZEp1rEjLpQjomlKGG0EQnAjEGjZ2DKhEZwJR/yqMNDmP3AI9blZ1jNhkBFIkf4b8W1Aq38UBUadOiOZjqYCEdxM6ibRP7FIjU4NAlbgKjMIoQocAabDv0gu2/4ToI/jCG//bOHV21GAtI6lCPxT1jEIS7AromlVCEYgW7kJmz1u6m8wVKP6Pon4VzlhVBWuiID1x3bqUZvfQiBq5e9b0LP+YOj9+Rrhr0EA/vlrplDlIERT2rKeizMasn9ESvoDbFNfM39bJOj199GoGSH+BiAq9OdPCLUgRsj/K0SYPBhc3mj4E6j6Hw4c5PMTTphfv0T/+42nnkDs/RMQACH5BAUHAP8ALFUAVgAmABIAAAj/AP8J/GekGaWBCBMqHIjDVzMy/+IsDAJuxAhlAmCgWcjx3yoEFkcEETQh4a+QFpUF6NNxIUiU3uIhzKdvBMIRzTpsbDmwmcWBI/S5ifFIYBCb/8AJHIGgiQ6eA0EqVfpvxC8WUZFS/WfGzTOo/5KY0Zr0X6R/hf6tiFZ2BFVwhMD+o2TTLdJ/bG39o5kQaTO5PttW/NdtIF+BUwX+BTvj7uB/+igp+UdDWl+BYP4RgQrGZsXPXMsgEvhtIGhpu1yBVaFvqVKb3wbxEYgLaNIR0fyxAuuvNFClyvzxeZq56uMguuVSWwhGuEB/CFyPkCZA91OoNMwkjORP4M58YxE3NJf7/C9SM8b8zUHojwa1b8p8+fMX4t8Quf6EKPtGLd98LQnNJ2B35D034HwcDVhggAImFBAAIfkEBQcA/wAsUwBUACgAEgAACP8A/wkcKNAEwYMIEwrU8g+Nwn8zECAolQ5Aq4cKVwWJhABMgIsJqY0YOQLXAJAYCa6KRHJEqSYJZ5AUOMIbASIpCYocMRCcFw8OCUbjKZQEypQqwBEdqAyhr5H/wB0UkVOgN6JSBXb7N0GCQH+lRmQl+CsezpwIlhIEM9DfP1xYxfJEUORR1W9xlULk4VWgsqV6/yHIkijnCjNR/4kdGERKH6ZxEyPwx2dIShzRaEpdHCTLhIEiAyt+6w9G1UiJDzYLgWhgs8hSS/ljVZWaZp5iheBoKDCfvtGahcyuKnOswGjZHkpVOrnqwMwERwTxp+FgPmk0/+kz4tb5v2YDeX4tW0EdoRDoZsD46+4cLPZ/kbgr9JekWbNZ6723FTADzLH8860HoH5fCcieQAEBACH5BAUHAP8ALFQAUwAnABMAAAj/AP8JHFhkoMGDCA/6GzAhoUBfuHDNcEjR4AxluIIVTDgD3IiPyk7EqJiQ2seP3v49OijEo8GUfUgaLPVxIDhfxQ4qG3GwWxkYaGT+OxaNp0Bw/xD8STREYD59RpEKnBGgkNBmNaX+A0fGIBieSI3+wzUIkdAgYi2G6SfQm1iX/yL5iyMUAdgRcH/54yMQ7VG8PL/5CyA0UlSxCPz9i2kyLFzBJwoD3moU10KBNP9SlqtB6E7NHoP428LWF8+7fRWfnQy3mb85ApOYAT1ihmqZpjX/02fMX4h/Ov6Z3PqPZzQct2V+Kx72nzJ//joLpDG7eHHXQgfmtq6PTPKH1cF5JoOefWApqdLAkEc4q9QvIevLC1ThzZuA+Aih45f/T//3hDjwV15AACH5BAUHAP8ALFIAUQAoABMAAAj/AP8JFChhoMGDCBMSSXgwTJEvxfoxZNhHoBaHAZItZIjDWyQE3r780zGR4TRqH5sJHJJQ2YiXI3AJKpmQRjSYI0qtPOgN5sBSWRKxpCnQ5YiB4Mj82yjwmJmXBqP5I0FUoBBwRw0q88fIIBio4AwGG8SHJM0gYP9hlTbthMFfL8NiFfjL34CqCEbIzfrPl78XA10K1Kv239Y5RHHcFBh24Ax/Wh4JzKtWb9atVZNII2xZYBB/gwZSrizaX1WnWedirWuQWue5/z7/S0f02+usYEw7Tp11xOOq/3DxHqhCtwR/KvQVnquvOPAZt/9986c7MN+i1IEfi4bQW3aDxqQNN/5nJt/3qs16/4t03qAQ7v+iCWlftZT4fwjMVz+4CgyYFf7gANxBNDRDCXX7IYRggAMetCBCAQEAIfkEBQcA/wAsUgBQACUAEwAACP8A/wkcSLCgwYP/eCEUeGvZslu2Fkok0vDhQR6vevUyxGiCRIOF/lUwFKmXJYNZSo1YOQLXx4MhcLEc8SsAP4Ehgq0kWMrES4K/dg4UQhDBiILdkG356S+JmaP/wAlE4G/APxXgRkiVKrDZT4EzhA4Ep6Ir1IK4/Gn4SQ1q1qz/ZvjbEuTsP6hUv0bSynfgL3//2grkevcb4J/f3PZVBlim1L7/Ih1+mRgu3MCAgw4+mjXvT6Obo47wBhjMUc5Q/35taxkqGMA0pG3m+vqr6dD/pNE4LHPgUcOTKd99/C+tQH80zPj+V/sr87MjpOUL7kv5P31yg/8sxdWML+3/kswU8GbMH/if+UrN2H3evHnnBt0XDAgAIfkEBQcA/wAsTgBQACkAEwAACP8A/wkcSLCgwYMF+yE0SETCIyI6FkrsM+TRoz4LicT4p6VImACsHklkKNBjmAEwMBqEscVbJASl/PkL8I/ISIF9iq2h9hKMv0EkEqEZGHGOMoK4ZJ64+Q/jrmgEY/r7UjDErxEFZ8gUOHQkAqwCR4Az4g+nwn/IzGBd++/bVolD/oUQAhbp24HN6oIDS6nsyAH/qIHdu1faKr8Dg2AF969uzJsh/kUSS1kgOCGIBSobXFlZ5oUr1Fqu3Ozz5L3/UP9LypSGvsqqf33+OprxCM9Mk4hOvXjEY4KbB8b+vDAabLC+Ppca0Rt1aab/gvMWqE/AZyGoVVeH/s+b2IKRiPs627xYYFIc0FeJZizwd0Eyr8GaocH9n78ZzMEiID7Ql/ER3whR30DeSMMcAjet0gwYxwxIkADNCGhQQAAh+QQFBwD/ACxOAFEAJgATAAAI/wD/CRwo8BHBgwgT/iOi8J+ORC++SGxIUSAPiaIS8snir6O/igrjhPD4kSDDEMFwKWvWESTBQv/8zVCGy1fLg6UI4rrpUqAygjNa8vqnJdiIg0F7Cvx1EJyQkgIREDwa7RjUitOkDRwBboSyjhLC0DraFdxAMFcb4phxlOvRf9LyfZT5duu/IGkb4qor8ChagdTqdo2a96COLf++CX5bqqSyt4MFRiqcMBpksiN2+uQqMDICyggtD46MV2CQywO/9oyEWmBjgc1G8BXozR8Ol3vLEvQ1MJ8+sgTBKI0928wsgo/NDpysdIUZ4IAPqpAm2+wI3kr/EX8rTcBBf2CojxrQNyP7wF+yR5jB/l2At18qzBM08qsUDYIBAQAh+QQFBwD/ACxOAFMAJQASAAAI/wD/CRS4ZaDBgwgNEvk3J2E/HQL9SfSXsCLCiRQN8pnjDQGCGRItJixUbBq1SAh8hfw3pZMoZQaDrBQpkEiHM9EMNlsZ79eIgzsz0uwTQNnPgdLyUUykqJvAnz8jzbSoQwSYo/+OyvTnqhlWcD/BkREqsgK1o+Cy/jNzzF+As//Aqv0Hkua/If8ihR0hF5wRf1kQoOWblRrZijBumBmcdgQYiXr7HjU8tNgusJjnlqKoV2DmEbgOV5wmjbHAukbTxj36S/TBfv+yReOL9Sclij73DnxsV6Bgz2ql0aDoawRU1cJ7C/SpeiACoYIJ/wyt/B+N0nEH1hXoC+zRaNeqCyD0Ztz5YTCLR0QTIn5gEH3GEVSkMQPMivYGjc3whcNgQAAh+QQFBwD/ACxMAFQAJgATAAAI/wD/CfxH5N+cgQgTKlzIUKCIf/4i+mtIEaLEiQiH3HLzL9q3GRErJmwlAgyCaJF8hRzYyVk0hEFWivx3yxI4hGBkLoM2IqEQjCLnoZKW0EwSjLeI3RQIrqcymRRvaeuZ0FvIW71GLB0obRbQhvNi8NzaM1LIZZGo/tPaU6XITqjMqGVr1B8vRDwHNhVYaiIOigyUqh2oz4g/W9jk/rvJ9p9VkTVHaEXYMycva9HYMub7lWEnQnsn9wT3k0iFtExF54TsptvotTe7TpSCa/LinvrydV746N83zWt9YwzQTPJtgWZn/jNBzThCahMLDegoeStIkfxsnSCzdyk4IwnBNCqlimB3xV+Sqf7a3UwuOGXHlCM8FkTaCH3rGa7ypUL+QgG+0CCSef4tFBAAIfkEBQcA/wAsTABUACUAFAAACP8A/wnkJ7CgwYMIEyoUiGihQ4N94uBQyEvCF38Y/T1MiAbRnIwaIcYBiXHjwUIkSIYU2E+Lv3xghBwrafIfET4a/JEBQyajQB1W/M3Q928EAhr+Jprsw8MftYLUaBIZ0GxEUYEIaD7s9+gENatW/wUJGWNDNINWS610qIOFEHBo/wnxh4bFDIEjwIWNtHbhoya48OoVGFXHusBXB4MzZtIWiW9F4eb9F81fKxKRIluF+6/ZRgm3MnVLKI2GLTxn4/4rVZMQZ4GKhUggYaagXsmsN8YgBFZxUTCOUx8ckfthDC9EXwvUp4JIAASTYRcVspHXLTFmouM1s+JfhV8jNm9Sn1UzDHTpejP/40FGb9jwymr2KeItvOTwdwsqC583L/Wa/yATDX96RXONTXz8M82A/OVnEhECgeHeCPr4UtAQAs1CTTQIeAagQUIoE40y//0TEAAh+QQFBwD/ACxMAFgAJQATAAAI/wD/CRTor6C/gQgTKhxocCEOgwZxLJzIECLCQiQgNqSoUIIWjQUHJtri71gpZdSEhOSIkM8gfwKCKAsiYKXLbAj+jfinr9lBlgKJMPKnwozOf9FUHCRixR+1gTul5fvJksg/f5GO6ox08BGPWuC07qRGlWK/VmFmQB3osw+GXwvNrAD6T0KlnDrB7fyHwF8hKXjz7gQnhO6EDUYH6v1n5pjAbwrDqgV6y03YvQOlPiKRWLDAUkD5JSI0Qq9pgSN82cITLfIIb3Rvkf53eTE4X49efBuMcEQzus8ydUMY9p80AWiSKcNcurQKuq2s7U44ovU/Sd5K00YdTSLQR8WWa03XOUKZwFuTzIxYr3cEXLr/RIBZ33w9mIEkStFf/21FWYr8oCUefeYhNEgQ9CUFH0LIIEAfArMg9IhAQgQxQxILCsSLQMeAEQQY3v0TEAAh+QQFBwD/ACxMAFoAJQAVAAAI/wD/CRwoEAfBgwgTKhToryEOfwsj/mtI8aAGihglJsRYkaDDWSs6ahzY8BiNYw0F9pnoT0gkaWZ+pRyp40vDGdGkRZsxk0RLaf9GCMQ1U6MWfzMECv3HU+AAf9+WLgUDUeOQE7v0Bd0qTYA/IgGCDRwBLiiCqhIlmPiVUGahANSCll0qjYZGXrZORB0rMJK/PhUQIBQKZuQ/N922gqM7y5a1aP8WyxVY6u6tV2UlD9RHphMiMwPLKvU28palpaKVgtHxWS5ZpZU1PiOWWahofUJ4xYBme/KIwho71QCK0Mysfwx6oVbaFe3CHhN4R54+IpLAW8RG9F4s2PAt5b21B00RqIMf78XaRzQzjByVPrLp9eUbiF1a+hG42AtkoO3+iNgC9XBZJOBIM55+/wj4SzTg7JTQMv/schyCAqHBwj+0rKCQDhQi1Mo/IRwUEAA7"'
			+ ' class="photo-transparent-placeholder">');
			$(this).find('.game-divider').append(content2);

      var content = $('<img class="photo-frame">');
			$(this).find('.game-divider').append(content);
			content.hide();
			content.load(function(){
				content.show();
				content2.hide();
			});
			content.attr("src",photoUrl);

      $container.imagesLoaded(function() {
        $container.isotope({ layoutMode : 'masonry' });
      });
    });


    $('#menu').on( 'click', 'a', function() {
      var filterValue = $(this).attr('data-filter');
      $container.isotope({ filter: filterValue });
    });

    var hash = $('.title').text();
    window.location.hash = hash;
    // window.onhashchange = function() {
    //   if (!location.hash){
    //     $(modal).modal('hide');
    //   }
    // }

});

$('#areaModal').on('hide.bs.modal', function (e) {
  $('#photos-masonry').isotope({ filter: '' });
  var hash = this.id;
  history.pushState('', document.title, window.location.pathname);
});


$('.photo-caption').keyup(function(){
  var len = $(this).val().length;
  $(this).closest('.control-group').next('.charCount').text(140 - len);
});
// $('#showAreaModal').modal('show');
//
// $('#showAreaModal').on('shown.bs.modal', function (e) {
//   var $container = $('#photos-masonry');
//   // init
//   $container.imagesLoaded( function() {
//     $container.isotope({
//       layoutMode: 'masonry',
//       itemSelector: '.item ',
//       masonry: {
//         columnWidth: $container.find('.grid-sizer')[0]
//       }
//     });
//     $container.on( 'click', '.photo-card', function() {
//
//       $(this).find('.fun-fact').toggle();
//       $( this ).toggleClass('photo-card-expanded');
//       $container.isotope({ layoutMode : 'masonry' });
//     });
//
//     $container.on( 'click', '.game-card', function() {
//       //close expanded game card
//       $( this ).siblings('.game-card-expanded').toggleClass('game-card-expanded')
//       .find('.game-thumbnail').toggle();
//
//       $( this ).siblings('.game-card').find('.game-divider').empty();
//
//       //expand clicked game card
//       $(this).find('.game-thumbnail').toggle();
//       $( this ).toggleClass('game-card-expanded');
//       $(this).find('.game-divider').append('<iframe class="game-frame" src="http://"></iframe>');
//       $container.isotope({ layoutMode : 'masonry' });
//     });
//
//   });
//
//   $('#menu').on( 'click', 'a', function() {
//     var filterValue = $(this).attr('data-filter');
//     $container.isotope({ filter: filterValue });
//   });
// });
