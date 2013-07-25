$ ->
  if $(".mindmap-container").length
    $(".mindmap-container").mindmap()

    root = $(".mindmap-container>ul>li").get(0).mynode = $('.mindmap-container').addRootNode $('.mindmap-container>ul>li>a').text(),
      href: "/"
      url: "/"
      onclick: (node) ->
        $(node.obj.activeNode.content).each -> @hide()

    $(".mindmap-container>ul>li").hide()

    addLI = ->
      parentnode = $(@).parents('li').get(0)
      parentnode = if typeof(parentnode) is 'undefined' then root else parentnode.mynode

      @mynode = $(".mindmap-container").addNode parentnode, $("a:eq(0)", @).text(),
        href: $('a:eq(0)',@).attr('href')
        onclick: (node) ->
          $(node.obj.activeNode.content).each ->
            @hide()
            $(node.content).each ->
              @show()
      $(@).hide()
      $('>ul>li', @).each addLI

    $(".mindmap-container>ul>li>ul").each ->
      $('>li', this).each(addLI)


  ## arbor.js here
  Nodes()

Nodes = ->
  sys = arbor.ParticleSystem(1000, 600, 0.5) # create the system with sensible repulsion/stiffness/friction
  sys.parameters({gravity:true}) # use center-gravity to make the graph settle nicely (ymmv)
  sys.renderer = Renderer("#viewport") # our newly created renderer will have its .init() method called shortly by sys...

  that =
    init: -> that.getNodes()

    getNodes: ->
      $.getJSON "nodes/arbor.json", (data) ->
        nodes = data.nodes
        $.each nodes, (name, info) ->
          info.label = name
        sys.merge({nodes: nodes, edges: data.edges})
  return that.init()

  # add some nodes to the graph and watch it go...
  # sys.addEdge('a','b')
  # sys.addEdge('a','c')
  # sys.addEdge('a','d')
  # sys.addEdge('a','e')
  # sys.addNode('f', {alone:true, mass:.25})

  # or, equivalently:
  #
  # sys.graft({
  #   nodes:{
  #     f:{alone:true, mass:.25}
  #   }, 
  #   edges:{
  #     a:{ b:{},
  #         c:{},
  #         d:{},
  #         e:{}
  #     }
  #   }
  # })
