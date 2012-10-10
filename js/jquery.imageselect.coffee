# Reference jQuery
$ = jQuery

# Adds plugin object to jQuery
$.fn.extend
  imageSelect: (options) ->
    # Default settings
    settings =
      dataUrl: null
      data: []
      debug: false
      perPage: 9
      elemDataAttr: 'img-sel-elem-id'
      containerDataAttr: 'img-sel-cont-id'
      containerTemplate: '<div class="image-selector"></div>'
      previewTemplate: '<div class="image-selector-preview"><img></div>'
      gridTemplate: '<div class="image-selector-grid"><ul></ul><div class="controls"><a class="l"><</a><a class="r">></a></div></div>'
      gridElTemplate: "<li><img src='{{itm}}'></li>"

    # Merge default settings with options.
    settings = $.extend settings, options

    log = (msg) -> console?.log msg if settings.debug
    
    setDataAttr = (el$, key, val) -> el$.attr('data-'+key, val)
    
    selectByDataAttr = (key, value) -> $('[data-'+key+'='+value+']')
    
    fetchDataFromUrl = (idx, el$) ->
      
      init(idx,el$)
      
    
    init = (idx,el$) ->
      if settings.data.length > 0
        initial_value = el$.val()
        
        container$ = $(settings.containerTemplate)
        preview$ = $(settings.previewTemplate)
        grid$ = $(settings.gridTemplate)
        
        container$.append(preview$)
        container$.append(grid$)
        container$.insertAfter(el$)
        
        setDataAttr(el$, settings.elemDataAttr, idx)
        setDataAttr(container$, settings.containerDataAttr, idx)
        
        preview$.find('img').attr('src', initial_value) if initial_value?
        
        grid$.hide()
        el$.hide()
        
        grid$.find('.l').bind 'click', -> prevPage(idx)
        grid$.find('.r').bind 'click', -> nextPage(idx)
        
        preview$.bind 'click', ->
          render(idx)
          grid$.show()
      else
        fetchDataFromUrl(idx, el$)
        
    nextPage = (idx) ->
      render(idx, 0)
      
    prevPage = (idx) ->
      render(idx, 1)
    
    render = (idx, page = 0) ->
      container$ = selectByDataAttr(settings.containerDataAttr,idx)
      preview$ = container$.find('.image-selector-preview')
      grid$ = container$.find('.image-selector-grid')
      grid_ul$ = grid$.find('ul')
      
      preview_img_src = preview$.find('img').attr('src')
      
      grid$.css('top',preview$.position().top);
      grid$.css('left', preview$.position().left+preview$.outerWidth()+5)
      
      grid_ul$.find('li').remove()
      
      settings.data.forEach (itm) ->
        el$ = $(settings.gridElTemplate.replace('{{itm}}', itm)).bind('click', handleImageSelect)
        grid_ul$.append(el$)
        el$.addClass('selected') if preview_img_src? && preview_img_src == itm
        
      
    handleImageSelect = (e) ->
      e.stopPropagation()
      container$ = $(e.target).parent().parent().parent().parent()
      id = container$.data(settings.containerDataAttr)
      elem$ = selectByDataAttr(settings.elemDataAttr,id)
      container$.find('.image-selector-preview img').attr('src', $(e.target).attr('src'))
      elem$.val($(e.target).attr('src'))
      container$.find('.image-selector-grid').hide()
    
    return @each (i, el) -> init(i,$(el))
