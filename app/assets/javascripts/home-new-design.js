$(document).ready(function() {
        var e = window.matchMedia("(max-width:767px)"),
            a = window.matchMedia("(max-width:991px)"),
            i = !1,
            o = !1,
            n = $(window);
        e.addListener(function(e) {
            !e.matches && i ? ($(".home-page .carousel").owlCarousel().trigger("destroy.owl.carousel"), i = !1) : e.matches && !i && t()
        }), a.addListener(function(e) {
            e.matches ? e.matches && (s(), o = !0) : ($(".home-page .activity-carousel").owlCarousel().trigger("destroy.owl.carousel"), o = !1)
        });
        var s = function() {
                $(".home-page .activity-carousel").owlCarousel({
                    loop: !1,
                    items: 2,
                    responsive: {
                        0: {
                            items: 1
                        },
                        768: {
                            items: 2
                        }
                    },
                    nav: !0,
                    navText: ["<div class='nav-prev'></div>", "<div class='nav-next'></div>"]
                })
            },
            t = function() {
                $(".home-page .carousel").owlCarousel({
                    loop: !1,
                    items: 1,
                    nav: !0,
                    navText: ["<div class='nav-prev'></div>", "<div class='nav-next'></div>"]
                }), i = !0
            };
        n.width() < 768 && t(), n.width() < 991 && s()
    }),
    function() {
        function e() {
            i.removeClass("hide")
        }

        function a() {
            i.addClass("hide")
        }
        var i = $(".banner-wrapper .search-results"),
            o = $(".banner-wrapper input.search");
        o.focus(function(a) {
            e()
        }), $(".brief-background").click(function(e) {
            a()
        })
    }();