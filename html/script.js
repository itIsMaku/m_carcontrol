$(function(){
    $(".seats").hide();
    window.addEventListener('message', function(event) {
        if(event.data.type=="toggle") {
            if(event.data.state)
                $(".seats").fadeIn();
            else
                $(".seats").fadeOut();
            if(event.data.switches!==undefined) {
                $("#bldoor,#brdoor,#blseat,#brseat").addClass("disabled");
                $(Object.keys(event.data.switches)).each(function(_,k){
                    var v = event.data.switches[k];
                    $("#"+k).removeClass((v ? "off" : "on")+" disabled");
                    $("#"+k).addClass(v ? "on" : "off");
                    if(k.includes("seat") && v) {
                        $("#"+k).addClass("disabled");
                    }
                });
            }
        }
    });
    $(document).keydown(function(ev){
        if(ev.originalEvent.keyCode==27) {
            $.post(`http://${GetParentResourceName()}/toggle`,JSON.stringify({state:false}));
            $(".seats").fadeOut();
        }
    });
    $(".btn").click(function(){
        if($(this).hasClass("disabled"))
            return;
        $.post(`http://${GetParentResourceName()}/btn`,JSON.stringify({btn:$(this).attr("id")}));
    });
});

$(function(){
    $(".doors").hide();
    window.addEventListener('message', function(event) {
        if(event.data.type=="toggle") {
            if(event.data.state)
                $(".doors").fadeIn();
            else
                $(".doors").fadeOut();
        }
    });
    $(document).keydown(function(ev){
        if(ev.originalEvent.keyCode==27) {
            $.post(`http://${GetParentResourceName()}/toggle`,JSON.stringify({state:false}));
            $(".doors").fadeOut();
        }
    });
    $(".btn").click(function(){
        if($(this).hasClass("disabled"))
            return;
        $.post(`http://${GetParentResourceName()}/btn`,JSON.stringify({btn:$(this).attr("id")}));
    });
});

$(function(){
    $(".other").hide();
    window.addEventListener('message', function(event) {
        if(event.data.type=="toggle") {
            if(event.data.state)
                $(".other").fadeIn();
            else
                $(".other").fadeOut();
        }
    });
    $(document).keydown(function(ev){
        if(ev.originalEvent.keyCode==27) {
            $.post(`http://${GetParentResourceName()}/toggle`,JSON.stringify({state:false}));
            $(".other").fadeOut();
        }
    });
    $(".btn").click(function(){
        if($(this).hasClass("disabled"))
            return;
        $.post(`http://${GetParentResourceName()}/btn`,JSON.stringify({btn:$(this).attr("id")}));
    });
});