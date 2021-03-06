# Reference jQuery
$ = jQuery

# TODO: in msie image is shown as a broken in default state
# TODO: when there're multiple instances on page - close others on open

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
      gridTemplate: '<div class="image-selector-grid"><ul></ul><div class="controls"><a class="l">&larr;</a><a class="r">&rarr;</a></div></div>'
      gridElTemplate: "<li><img src='{{itm}}'></li>"

    # Merge default settings with options.
    settings = $.extend settings, options

    log = (msg) -> console?.log msg if settings.debug
    
    setDataAttr = (el$, key, val) -> el$.attr('data-'+key, val)
    
    selectByDataAttr = (key, value) -> $('[data-'+key+'='+value+']')
    
    fetchDataFromUrl = (idx, el$) -> init(idx,el$)
    
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
        
    currentPage = (idx) ->
      container$ = selectByDataAttr(settings.containerDataAttr,idx)
      container$.find('.image-selector-grid .controls').data('page') || 0
      
    setCurrentPage = (idx, page) ->
      container$ = selectByDataAttr(settings.containerDataAttr,idx)
      setDataAttr(container$.find('.image-selector-grid .controls'), 'data-page', page)
      
    totalPages = () ->
      total = Math.floor(settings.data.length / settings.perPage)
      total += 1 if settings.data.length % settings.perPage > 0
      total
    
    toggleControlsVisibility = (idx) ->
      total = totalPages()
      current = currentPage(idx)
      container$ = selectByDataAttr(settings.containerDataAttr,idx).find('.image-selector-grid .controls')
      
      if current == total-1
        container$.find('.r').hide()
      else
        container$.find('.r').show()
        
      if current == 0
        container$.find('.l').hide()
      else
        container$.find('.l').show()
          
    nextPage = (idx) ->
      page = currentPage(idx)
      render(idx, page+1) if page+1 < totalPages()
      
    prevPage = (idx) ->
      page = currentPage(idx)
      render(idx, page-1) if page-1 >= 0
    
    render = (idx, page = 0) ->
      setCurrentPage(idx, page)
      container$ = selectByDataAttr(settings.containerDataAttr,idx)
      preview$ = container$.find('.image-selector-preview')
      grid$ = container$.find('.image-selector-grid')
      grid_ul$ = grid$.find('ul')
      
      preview_img_src = preview$.find('img').attr('src')
      
      grid$.css('top',preview$.position().top);
      grid$.css('left', preview$.position().left+preview$.outerWidth()+5)
      
      grid_ul$.find('li').remove()
      
      for itm, i in settings.data
        if (page+1) * settings.perPage >= i >= page * settings.perPage
          el$ = $(settings.gridElTemplate.replace('{{itm}}', itm)).bind('click', handleImageSelect)
          grid_ul$.append(el$)
          el$.addClass('selected') if preview_img_src? && preview_img_src == itm
        
      grid$.find('.controls').data('page', page)
      toggleControlsVisibility(idx)
        
      
    handleImageSelect = (e) ->
      e.stopPropagation()
      container$ = $(e.target).parent().parent().parent().parent()
      id = container$.data(settings.containerDataAttr)
      elem$ = selectByDataAttr(settings.elemDataAttr,id)
      container$.find('.image-selector-preview img').attr('src', $(e.target).attr('src'))
      elem$.val($(e.target).attr('src'))
      container$.find('.image-selector-grid').hide()
    
    return @each (i, el) -> init(i,$(el))
