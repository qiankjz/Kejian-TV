/*--------------------------------------------------------------------------/
功能：实现弹出层功能
参数：opts
示例：$.popupDiv({title:"错误提示", html:"您输入的密码不正确！", buttons:{"确定": function(){$.popupClose();}}});
制作：lesanc.li by 2011-10-28
修改：lesanc.li by 2011-2-27
/---------------------------------------------------------------------------*/
; (function($){
    $.extend({
      popupDiv: function(opts){
        var defaults = {
          title: "\u63d0\u793a",
          html: "",
          url: "",
          msg: "",
          data: null,
          buttons: "",
          drappable: false,
          maskable: true,
          posx: "center",
          posy: "center",
          width: 420,
          height: "auto",
          success: null,
          error: null,
          frmObj: null,
          frmAjax: true,
          action: "",
          mothed: "",
          subForm: function(){
            var frmObj = defaults.frmObj || $("#divPopup form");
            var action = defaults.action || frmObj.attr("action");
            var mothed = defaults.mothed || frmObj.attr("mothed");
            frmObj.submit(function(){
              $.ajax({
                url: action,
                data: frmObj.serialize(),
                dataType: "html",
                success: function(data){
                  defaults.html = _getBody(data);
                  $.popupDiv(defaults);
                },
                error: function(){
                  defaults.html = "<div class=\"ajaxError\">\u63d0\u4ea4\u5931\u8d25\uff0c\u8bf7\u8fd4\u56de\uff01</div>";
                  $.popupDiv(defaults);
                }
              });
              return false;
            });
          }
        };

        $.extend(defaults, opts);

        var divPopup = $("#divPopup");
        var ajaxLoadingTimeId = null;
        _initDiv();
        //加载内容
        if (defaults.url != ""){
          _loading(true);
          try {
            $.ajax({
              url: defaults.url, 
              data: defaults.data,
              success: function(data){               
                defaults.html = _getBody(data);
                _updateDiv();
                _loading(false);
                _showDiv();
                _callback(defaults.success);
              },
              error: function(){               
                defaults.html = "<div class=\"ajaxError\">\u52a0\u8f7d\u5931\u8d25\uff0c\u8bf7\u91cd\u8bd5\uff01</div>";
                _loading(false);
                _showError();
                _callback(defaults.error);
              },
              dataType: "html",
              cacha: false
            });
          } catch(ex){}
        } else {
          _updateDiv();
          _showDiv();
          _callback(defaults.success);
        }
        //加载状态提示
        function _loading(isShow){          
          if (isShow){
            $("#ajaxLoading").css({"position":"absolute","z-index":"9999","left":$(window).width()/2-16+"px","top":$(window).height()/2-16+"px"}).html('<img src="http://myimg.zhaopin.com/images/new_v3/ani_ajaxload.gif" \/>').show();
            ajaxLoadingTimeId = setTimeout(function(){
              clearTimeout(ajaxLoadingTimeId);
              $("#ajaxLoading").hide();
              _showError();
            }, 60000);
          } else {            
            clearTimeout(ajaxLoadingTimeId);
            $("#ajaxLoading").hide();
          }
        }
        //初始化
        function _initDiv(){
          //初始化蒙版并显示
          if (defaults.maskable){
            var divMask = $("#divMask");
            if (!divMask.length){
              divMask = $("<div id=\"divMask\" style=\"display:none;\"></div>");
              divMask.appendTo($("body"));
            }
            divMask.css({
              "position": "absolute",
              "top":  "0px",
              "left": "0px",
              "width": ($(window).width()>$(document).width())?$(window).width():(($.browser.msie)?$(document).width()-21:$(document).width()) + "px",
              "height": ($(window).height()>$(document).height())?$(window).height():(($.browser.msie)?$(document).height()-21:$(document).height()) + "px",
              "background": "#000",
              "opacity": 0.3,
              "z-index": "8000"
            }).show();
          }
          //初始化弹出层
          if (!divPopup.length){
            divPopup = $("<div id=\"divPopup\" style=\"display:none;\"></div>");
            var sHtml = "<div id=\"popupTit\"><div id=\"popupClose\">close</div><div id=\"popupTitle\"> </div></div>";
            sHtml += "<div id=\"popupCon\"><div id=\"popupInnerCon\"></div></div>";
            divPopup.append(sHtml); 
            divPopup.appendTo($("body"));
          } else {
            $("#popupTitle").html("");
            $("#popupInnerCon").html("");
          }
          //初始化加载状态
          if(!$("#ajaxLoading").length){
            $("body").append('<div id="ajaxLoading" style="display:none;"><img src="http://myimg.zhaopin.com/images/new_v3/ani_ajaxload.gif" \/></div>');
          }
        }
        //加载失败提示
        function _showError(){
          $("#popupInnerCon").html("<div class=\"ajaxError\">\u52a0\u8f7d\u5931\u8d25\uff0c\u8bf7\u91cd\u8bd5\uff01</div>");
          _showDiv();
        }
        //更新弹窗内容
        function _updateDiv(){
          $("#popupTitle").html(defaults.title);
          $("#popupInnerCon").html(defaults.html);
          if (defaults.msg){
            $("#popupInnerCon").append("<div class=\"msg\">"+defaults.msg+"</div>");
            defaults.msg = "";
          }
          //初始化按钮
          if (defaults.buttons){
            var buttons = document.createElement("div");
            buttons.className = "buttons";
            if (typeof defaults.buttons == "string"){
              var button = null;
              if(defaults.buttons.indexOf("yes") > -1){
                button = document.createElement("span");
                button.className = "popupConfirmBtn";
                $(button).html("\u786e\u0020\u5b9a").click(function(){
                  $.popupClose();
                  if ($("#divPopup form").length && defaults.frmAjax){
                    defaults.subForm();
                  }
                });
                $(button).hover(function(){$(this).attr("class","popupConfirmBtnHover")},function(){$(this).attr("class","popupConfirmBtn");});
                buttons.appendChild(button);
              }            
              if(defaults.buttons.indexOf("submit") > -1){
                button = document.createElement("span");
                button.className = "popupConfirmBtn";
                $(button).html("\u63d0\u0020\u4ea4").click(function(){
                  if ($("#divPopup form").length && defaults.frmAjax){
                    defaults.subForm();
                  } else if ($("#divPopup form").length){
                    $("#divPopup form")[0].submit();
                  } else {
                    $.popupClose();
                  }
                });
                $(button).hover(function(){$(this).attr("class","popupConfirmBtnHover")},function(){$(this).attr("class","popupConfirmBtn");});
                buttons.appendChild(button);
              }
              if(defaults.buttons.indexOf("save") > -1){
                button = document.createElement("span");
                button.className = "popupConfirmBtn";
                $(button).html("\u4fdd\u0020\u5b58").click(function(){
                  if ($("#divPopup form").length && defaults.frmAjax){
                    defaults.subForm();
                  } else if ($("#divPopup form").length){
                    $("#divPopup form")[0].submit();
                  } else {
                    $.popupClose();
                  }
                });
                $(button).hover(function(){$(this).attr("class","popupConfirmBtnHover")},function(){$(this).attr("class","popupConfirmBtn");});
                buttons.appendChild(button);
              }
              if(defaults.buttons.indexOf("no") > -1){
                button = document.createElement("span");
                button.className = "popupCancelBtn";
                $(button).html("\u53d6\u0020\u6d88").click(function(){
                  $.popupClose();
                });
                $(button).hover(function(){$(this).attr("class","popupCancelBtnHover")},function(){$(this).attr("class","popupCancelBtn");});
                buttons.appendChild(button);
              }
            } else {
              $.each(defaults.buttons, function(key, value){
                var button = document.createElement("span");
                if (key.replace(/\s+/g, "") == "\u53d6\u6d88"){
                  button.className = "popupCancelBtn";
                  $(button).hover(function(){$(this).attr("class","popupCancelBtnHover")},function(){$(this).attr("class","popupCancelBtn");});
                } else {
                  button.className = "popupConfirmBtn";
                  $(button).hover(function(){$(this).attr("class","popupConfirmBtnHover")},function(){$(this).attr("class","popupConfirmBtn");});
                }
                $(button).html(key).click(defaults.buttons[key]);
                buttons.appendChild(button);
              });
            }
            $("#popupInnerCon").append($(buttons));
            defaults.buttons = "";
          }
        } // end _initDiv()
        //显示弹出层
        function _showDiv(){
          divPopup.css({        
            "width": defaults.width + ((defaults.width > 0)?"px":""),
            "height": defaults.height + ((defaults.height > 0)?"px":"")
          });
          //计算位置
          var pTop = (defaults.posy == "center" || typeof defaults.posy != "number" || defaults.posy < 0 || defaults.posy > $(window).height())?$(document).scrollTop() + $(window).height()/2 - divPopup.height()/2:defaults.posy;
          pTop = (pTop > 0)?pTop:0;
          var pLeft = (defaults.posx == "center" || typeof defaults.posx != "number" || defaults.posx < 0 || defaults.posx > $(window).width())?$(document).scrollLeft() + $(window).width()/2 - divPopup.width()/2:defaults.posx;
          pLeft = (pLeft > 0)?pLeft:0;
          divPopup.css({
            "position": "absolute",
            "top":  pTop + "px",
            "left": pLeft + "px",
            "z-index": "9000"
          }).show();
          //设置拖拽
          if (defaults.drappable){
            $("#popupTit").css({"cursor":"move"});
            _divMove();
          } else {
            $("#popupTit").css({"cursor":"auto"});
          }
          //层内表单提交
          if ($("#popupInnerCon form").length && defaults.frmAjax){
            defaults.subForm();
          }
          //关闭层
          $("#popupClose,.popupClose").bind("click", function(){
            $.popupClose();
          });
        } // end _showDiv()
        //拖动层实现
        var diffPosx = 0;
        var diffPosy = 0;        
        function _divMove(){
          var movable = false;
          var timeId2 = null;
          var popupTit = $("#popupTit");
          popupTit.mousedown(function(e){
            movable = true;
            $(document).bind("selectstart", function(){return false;});
            $("body").css({"-moz-user-select":"none"});
            if($.browser.msie){
              popupTit[0].setCapture();
            }
            diffPosx = e.clientX - parseInt(divPopup.css("left"));
            diffPosy = e.clientY - parseInt(divPopup.css("top"));
            $(document).mousemove(function(e){
              if(movable){
                  _divUpdatePos(e, e.clientX - diffPosx, e.clientY - diffPosy);
              }
            }).mouseup(function(){
              $(document).unbind("mousemove");
              movable = false;
              $(document).unbind("selectstart");
              $("body").css({"-moz-user-select":""});
              if($.browser.msie){
                popupTit[0].releaseCapture();
              }
            });
          });
        } //end _divMove()
        //处理异步加载的文件内容
        function _getBody(data){
          if (data == "") return;
          var posBodyStart = data.indexOf("<body");
          if (posBodyStart>0){posBodyStart += data.match(/<body[^>]*>/gi)[0].length;}
          else {posBodyStart = 0}
          var posBodyStartEnd = data.indexOf("</body");
          if (posBodyStartEnd<1){posBodyStartEnd = data.length}
          var dataBody = data.substring(posBodyStart, posBodyStartEnd);
          var css = data.match(/<link[^>]*href=[\"\' ][^\"\' ]*/gi);      
          var js = data.match(/<scrip[^>]*src=[\"\' ][^\"\' ]*/gi);
          dataBody = dataBody.replace(/<link[^>]*href=[\"\' ][^>]*>/gi, "");
          dataBody = dataBody.replace(/<scrip[^>]*src=[\"\' ][^>]*><\/script>/gi, "");
          var link = "";
          var script = "";
          $("link").each(function(){
            link += $(this).attr("href") + ";";
          });
          $("script").each(function(){
            script += $(this).attr("src") + ";";
          });
          while(css && css.length){
            var css1 = css.shift().replace(/<link.*?href=[\"\' ]/i, "");
            if (link.indexOf(css1) == -1) {
              $("head").append('<link href="'+css1+'" type="text/css" rel="stylesheet" />');
            }
          }
          setTimeout(function(){
            while(js && js.length){
              var js1 = js.shift().replace(/<scrip.*?src=[\"\' ]/i, "");
              if (script.indexOf(js1) == -1) {
                $("head").append('<scr'+'ipt src="'+js1+'" type="text/javascript" /></scr'+'ipt>');
              }
            }
          }, 200);
          return $.trim(dataBody);
        } // end __getBody()
        //调整层的位置
        function _divUpdatePos(e, left, top){
          if (left < 0) left = 0;
          if (left > $(window).width() - divPopup.width()) left = $(window).width() - divPopup.width();
          if (top < 0) top = 0;
          if (top > $(window).height() - divPopup.height()) top = $(window).height() - divPopup.height();     
          divPopup.css({"left": left + "px","top": top + "px"});
        } // end _divUpdatePos()
        //执行函数
        function _callback(fn){
          if (fn instanceof Function){
            fn();
          }
        } // end _callback()
      }, // end popupDiv()
      //关闭弹出层
      popupClose: function(){
        var divPopup = $("#divPopup");
        if (divPopup.length && divPopup.css("display") != "none"){
            divPopup.hide();
            if ($("#divMask").length){
              $("#divMask").hide();
            }
            $("#popupInnerCon").html("<div class=\"ajaxLoading\"><img src=\"http://myimg.zhaopin.com/images/new_v3/ani_ajaxload.gif\" \/></div>");
            if ($("#divPopup form").length){
              $("#divPopup form").unbind("submit");
            }
            $("#popupClose,.popupClose").unbind("click");
        }
      } //end popupClose()
    });
})(jQuery);