Renderer = function(elt){
  var dom = $(elt)
  var canvas = dom.get(0)
  var ctx = canvas.getContext("2d");
  var gfx = arbor.Graphics(canvas)
  var particleSystem = null
  var _vignette = null
  var selected = null,
      nearest = null,
      _mouseP = null;

  var that = {
    init:function(system){
      //
      // the particle system will call the init function once, right before the
      // first frame is to be drawn. it's a good place to set up the canvas and
      // to pass the canvas size to the particle system
      //
      // save a reference to the particle system for use in the .redraw() loop
      particleSystem = system

      // inform the system of the screen dimensions so it can map coords for us.
      // if the canvas is ever resized, screenSize should be called again with
      // the new dimensions
      particleSystem.screenSize(canvas.width, canvas.height) 
      particleSystem.screenPadding(80) // leave an extra 80px of whitespace per side

      // set up some event handlers to allow for node-dragging
      that.initMouseHandling()
    },

    redraw:function(){
      ctx.fillStyle = "white"
      ctx.fillRect(0,0, canvas.width, canvas.height)
      gfx.clear()

      particleSystem.eachEdge(function(edge, pt1, pt2){
        if (edge.source.data.alpha * edge.target.data.alpha == 0) return
        gfx.line(pt1, pt2, {stroke: "#b2b19d", width: 2, alpha: edge.target.data.alpha})
      })

      particleSystem.eachNode(function(node, pt){
        var w = Math.max(20, 20 + gfx.textWidth(node.name))
        var label = node.data.label
        if (node.data.alpha === 0) return
        if (node.data.shape == 'dot')
        {
          gfx.oval(pt.x - w/2, pt.y - w/2, w, w, {fill: node.data.color, alpha: node.data.alpha})
          gfx.text(node.name, pt.x, pt.y + 7, {color: "white", align: "center", font: "Arial", size: 12})
        }
        else
        {
          gfx.rect(pt.x-w/2, pt.y-8, w, 20, 4, {fill:node.data.color, alpha:node.data.alpha})
          gfx.text(node.name, pt.x, pt.y+9, {color:"white", align:"center", font:"Arial", size:12})
        }
      })
    },

    switchSection:function(newSection){
        var parent = particleSystem.getEdgesFrom(newSection)[0].source
        var children = $.map(particleSystem.getEdgesFrom(newSection), function(edge){
          return edge.target
        })

        particleSystem.eachNode(function(node){
          if (node.data.shape=='dot') return // skip all but leafnodes

          var nowVisible = ($.inArray(node, children)>=0)
          var newAlpha = (nowVisible) ? 1 : 0
          var dt = (nowVisible) ? .5 : .5
          particleSystem.tweenNode(node, dt, {alpha:newAlpha})

          if (newAlpha==1){
            node.p.x = parent.p.x + .05*Math.random() - .025
            node.p.y = parent.p.y + .05*Math.random() - .025
            node.tempMass = .001
          }
        })
      },

    initMouseHandling:function(){
      // no-nonsense drag and drop (thanks springy.js)
      selected = null;
      //nearest = null;
      var dragged = null;

      // set up a handler object that will initially listen for mousedowns then
      // for moves and mouseups while dragging
      var handler = {
        //moved:function(e) {
          //var pos = $(canvas).offset();
          //_mouseP = arbor.Point(e.pageX-pos.left, e.pageY-pos.top)
          //nearest = particleSystem.nearest(_mouseP)
          //if (nearest.node.data.shape != 'dot'){
            //selected = (nearest.distance < 50) ? nearest : null
            //if (selected){
             ////dom.addClass('linkable')
             ////window.status = selected.node.data.link.replace(/^\//,"http://"+window.location.host+"/")
              ////.replace(/^#/,'')
            //}
            //else{
             ////dom.removeClass('linkable')
             ////window.status = ''
            //}
          //}else if ($.inArray(nearest.node.name, ['arbor.js','code','docs','demos']) >=0 ){
            //if (nearest.node.name!=_section){
              //_section = nearest.node.name
              //that.switchSection(_section)
            //}
            //dom.removeClass('linkable')
            //window.status = ''
          //}

          //return false
        //},
        clicked:function(e){
          var pos = $(canvas).offset();
          _mouseP = arbor.Point(e.pageX-pos.left, e.pageY-pos.top)
          nearest = dragged = particleSystem.nearest(_mouseP);
          console.log(nearest)

          if (nearest && selected && nearest.node === selected.node)
            {
              //var link = selected.node.data.link
              //if (link.match(/^#/))
                //{
                   //$(that).trigger({type:"navigate", path:link.substr(1)})
                //}
              //else
              //{
                 //window.location = link
              //}
            //return false
          }

          if (dragged && dragged.node !== null) dragged.node.fixed = true

          $(canvas).bind('mousemove', handler.dragged)
          $(window).bind('mouseup', handler.dropped)

          return false
        },
        dragged:function(e){
          var old_nearest = nearest && nearest.node._id
          var pos = $(canvas).offset();
          var s = arbor.Point(e.pageX-pos.left, e.pageY-pos.top)

          if (!nearest) return
          if (dragged !== null && dragged.node !== null){
            var p = particleSystem.fromScreen(s)
            dragged.node.p = p
          }

          return false
        },

        dropped:function(e){
          if (dragged===null || dragged.node===undefined) return
          if (dragged.node !== null) dragged.node.fixed = false
          dragged.node.tempMass = 1000
          dragged = null
          // selected = null
          $(canvas).unbind('mousemove', handler.dragged)
          $(window).unbind('mouseup', handler.dropped)
          _mouseP = null
          return false
        }
      }

      // start listening
      $(canvas).mousedown(handler.clicked);
      $(canvas).mousemove(handler.moved);

    },

  }
  return that
}
