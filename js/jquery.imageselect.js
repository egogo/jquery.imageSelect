// Generated by CoffeeScript 1.3.3
(function() {
  var $;

  $ = jQuery;

  $.fn.extend({
    imageSelect: function(options) {
      var fetchDataFromUrl, handleImageSelect, init, log, nextPage, prevPage, render, selectByDataAttr, setDataAttr, settings;
      settings = {
        dataUrl: null,
        data: [],
        debug: false,
        perPage: 9,
        elemDataAttr: 'img-sel-elem-id',
        containerDataAttr: 'img-sel-cont-id',
        containerTemplate: '<div class="image-selector"></div>',
        previewTemplate: '<div class="image-selector-preview"><img></div>',
        gridTemplate: '<div class="image-selector-grid"><ul></ul><div class="controls"><a class="l">&larr;</a><a class="r">&rarr;</a></div></div>',
        gridElTemplate: "<li><img src='{{itm}}'></li>"
      };
      settings = $.extend(settings, options);
      log = function(msg) {
        if (settings.debug) {
          return typeof console !== "undefined" && console !== null ? console.log(msg) : void 0;
        }
      };
      setDataAttr = function(el$, key, val) {
        return el$.attr('data-' + key, val);
      };
      selectByDataAttr = function(key, value) {
        return $('[data-' + key + '=' + value + ']');
      };
      fetchDataFromUrl = function(idx, el$) {
        return init(idx, el$);
      };
      init = function(idx, el$) {
        var container$, grid$, initial_value, preview$;
        if (settings.data.length > 0) {
          initial_value = el$.val();
          container$ = $(settings.containerTemplate);
          preview$ = $(settings.previewTemplate);
          grid$ = $(settings.gridTemplate);
          container$.append(preview$);
          container$.append(grid$);
          container$.insertAfter(el$);
          setDataAttr(el$, settings.elemDataAttr, idx);
          setDataAttr(container$, settings.containerDataAttr, idx);
          if (initial_value != null) {
            preview$.find('img').attr('src', initial_value);
          }
          grid$.hide();
          el$.hide();
          grid$.find('.l').bind('click', function() {
            return prevPage(idx);
          });
          grid$.find('.r').bind('click', function() {
            return nextPage(idx);
          });
          return preview$.bind('click', function() {
            render(idx);
            return grid$.show();
          });
        } else {
          return fetchDataFromUrl(idx, el$);
        }
      };
      nextPage = function(idx) {
        var container$, page;
        container$ = selectByDataAttr(settings.containerDataAttr, idx);
        page = container$.find('.image-selector-grid .controls').data('page') + 1;
        return render(idx, page);
      };
      prevPage = function(idx) {
        var container$, page;
        container$ = selectByDataAttr(settings.containerDataAttr, idx);
        page = container$.find('.image-selector-grid .controls').data('page') - 1;
        return render(idx, page);
      };
      render = function(idx, page) {
        var container$, el$, grid$, grid_ul$, i, itm, preview$, preview_img_src, _i, _len, _ref;
        if (page == null) {
          page = 0;
        }
        container$ = selectByDataAttr(settings.containerDataAttr, idx);
        preview$ = container$.find('.image-selector-preview');
        grid$ = container$.find('.image-selector-grid');
        grid_ul$ = grid$.find('ul');
        preview_img_src = preview$.find('img').attr('src');
        grid$.css('top', preview$.position().top);
        grid$.css('left', preview$.position().left + preview$.outerWidth() + 5);
        grid_ul$.find('li').remove();
        _ref = settings.data;
        for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
          itm = _ref[i];
          if (((page + 1) * settings.perPage >= i && i >= page * settings.perPage)) {
            log(i);
            el$ = $(settings.gridElTemplate.replace('{{itm}}', itm)).bind('click', handleImageSelect);
            grid_ul$.append(el$);
            if ((preview_img_src != null) && preview_img_src === itm) {
              el$.addClass('selected');
            }
          }
        }
        return grid$.find('.controls').data('page', page);
      };
      handleImageSelect = function(e) {
        var container$, elem$, id;
        e.stopPropagation();
        container$ = $(e.target).parent().parent().parent().parent();
        id = container$.data(settings.containerDataAttr);
        elem$ = selectByDataAttr(settings.elemDataAttr, id);
        container$.find('.image-selector-preview img').attr('src', $(e.target).attr('src'));
        elem$.val($(e.target).attr('src'));
        return container$.find('.image-selector-grid').hide();
      };
      return this.each(function(i, el) {
        return init(i, $(el));
      });
    }
  });

}).call(this);
