$ ->
  $("body").mindmap()

  root = $("body>ul>li").get(0).mynode = $('body').addRootNode $('body>ul>li>a').text(),
    href: "/"
    url: "/"
    onclick: (node) ->
      $(node.obj.activeNode.content).each -> @hide()

  $("body>ul>li").hide()

  addLI = ->
    parentnode = $(@).parents('li').get(0)
    parentnode = if typeof(parentnode) is 'undefined' then root else parentnode.mynode

    @mynode = $("body").addNode parentnode, $("a:eq(0)", @).text(),
      href: $('a:eq(0)',@).attr('href')
      onclick: (node) ->
        $(node.obj.activeNode.content).each ->
          @hide()
          $(node.content).each ->
            @show()
    $(@).hide()
    $('>ul>li', @).each addLI

  $("body>ul>li>ul").each ->
    $('>li', this).each(addLI)
