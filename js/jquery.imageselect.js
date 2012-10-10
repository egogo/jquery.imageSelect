// Generated by CoffeeScript 1.3.3
(function() {
  var $;

  $ = jQuery;

  $.fn.extend({
    imageSelect: function(options) {
      var handleImageSelect, init, log, render, selectByDataAttr, setDataAttr, settings;
      settings = {
        dataUrl: null,
        data: [],
        debug: false,
        elemDataAttr: 'img-sel-elem-id',
        containerDataAttr: 'img-sel-cont-id',
        containerTemplate: '<div class="image-selector"></div>',
        previewTemplate: '<div class="image-selector-preview"><img></div>',
        gridTemplate: '<div class="image-selector-grid"><ul></ul></div>',
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
      init = function(idx, el$) {
        var container$, grid$, initial_value, preview$;
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
        return preview$.bind('click', function() {
          render(idx);
          return grid$.show();
        });
      };
      render = function(idx) {
        var container$, grid$, grid_pos, grid_ul$, preview$, preview_img_src;
        container$ = selectByDataAttr(settings.containerDataAttr, idx);
        preview$ = container$.find('.image-selector-preview');
        grid$ = container$.find('.image-selector-grid');
        grid_ul$ = grid$.find('ul');
        preview_img_src = preview$.find('img').attr('src');
        grid_pos = preview$.position();
        grid_pos.left += preview$.width();
        grid$.position(grid_pos);
        grid_ul$.find('li').remove();
        return settings.data.forEach(function(itm) {
          var el$;
          el$ = $(settings.gridElTemplate.replace('{{itm}}', itm)).bind('click', handleImageSelect);
          grid_ul$.append(el$);
          if ((preview_img_src != null) && preview_img_src === itm) {
            return el$.addClass('selected');
          }
        });
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
