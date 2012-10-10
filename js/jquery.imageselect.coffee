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
      elemDataAttr: 'img-sel-elem-id'
      containerDataAttr: 'img-sel-cont-id'
      containerTemplate: '<div class="image-selector"></div>'
      previewTemplate: '<div class="image-selector-preview"><img></div>'
      gridTemplate: '<div class="image-selector-grid"><ul></ul></div>'
      gridElTemplate: "<li><img src='{{itm}}'></li>"

    # Merge default settings with options.
    settings = $.extend settings, options

    log = (msg) -> console?.log msg if settings.debug
    
    setDataAttr = (el$, key, val) -> el$.attr('data-'+key, val)
    
    selectByDataAttr = (key, value) -> $('[data-'+key+'='+value+']')
    
    
    init = (idx,el$) ->
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
      
      preview$.bind 'click', ->
        render(idx)
        grid$.show()
    
    render = (idx) ->
      container$ = selectByDataAttr(settings.containerDataAttr,idx)
      preview$ = container$.find('.image-selector-preview')
      grid$ = container$.find('.image-selector-grid')
      grid_ul$ = grid$.find('ul')
      
      preview_img_src = preview$.find('img').attr('src')
      
      grid_pos = preview$.position()
      grid_pos.left += preview$.width()
      grid$.position(grid_pos)
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
