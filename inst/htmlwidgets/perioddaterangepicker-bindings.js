var PeriodDateRangePickerBinding = new Shiny.InputBinding();
$.extend(PeriodDateRangePickerBinding, {
  find: function(scope) {
    return $(scope).find(".perioddaterangepickerclass");
  },
  initialize: function initialize(el) {
    // Parse options
    var options = JSON.parse(el.attributes.options.value);

    // Change Moment Locale globally
    if (options.language !== undefined && options.language !== null) {
      moment.locale(options.language);
    }

    // Adapt Ranges, so moment.js can read the Dates
    if (options.ranges !== undefined || options.ranges !== null) {
      for (var key in options.ranges) {
    		if (typeof options.ranges[key] === "string") {
    		  options.ranges[key] = [moment(options.ranges[key]), moment(options.ranges[key])];
    		} else {
    		  for (var i in [0,1]) {
    		    options.ranges[key].push(moment(options.ranges[key][0]));
    		    options.ranges[key].shift();
    		  }
    		}
      }
    }

    // Initialize daterangepicker
    var configs = {
      minDate: options.minDate ? moment(options.minDate) : false,
      maxDate: options.maxDate ? moment(options.maxDate) : false,
      startDate: options.start ? moment(options.start) : false,
      endDate: options.end ? moment(options.end) : false,

      ranges: options.ranges ? options.ranges : undefined,
      period: options.period ? options.period : 'week',
      periods: options.periods ? options.periods : undefined,
      firstDayOfWeek: options.firstDayOfWeek ? options.firstDayOfWeek : 0,
      single: options.single ? options.single : false,
      orientation: options.orientation ? options.orientation : 'left',
      opened: options.opened ? options.opened : false,
      expanded: options.expanded ? options.expanded : false,
      standalone: options.standalone ? options.standalone : false,
      hideWeekdays: options.hideWeekdays ? options.hideWeekdays : false,
      anchorElement: options.anchorElement ? options.anchorElement : false,
      parentElement: options.parentElement ? options.parentElement : 'body',
      forceUpdate: options.forceUpdate ? options.forceUpdate : true,
      timeZone: options.timeZone,
      locale: options.locale ? options.locale : {
        applyButtonTitle: "Apply",
        cancelButtonTitle: "Cancel",
        endLabel: "End",
        inputFormat: "L",
        startLabel: "Start"
      }
    }

    var callback = function(startDate, endDate, period, configs) {
      debugger;
      let format = JSON.parse(el.attributes.options.value).locale.inputFormat;
      $(this).val(startDate.format(format) + ' – ' + endDate.format(format))
      if ($(el).data("daterangepicker")) {
        $(el).data("daterangepicker")
          .endDate(endDate)
          .startDate(startDate)
        Shiny.setInputValue(this.id + '', {
          start: startDate.format("YYYY-MM-DD"),
          end: endDate.format("YYYY-MM-DD")
        }, {priority: "event"})
      }
    }
    $(el).daterangepicker(configs, callback);
  },
  getValue: function(el) {
    var ele, res, start, end, format;
    ele = $(el).data("daterangepicker");
    // Get start/end time
    if (ele) {
      start = ele.startDate();
      end = ele.endDate();
      res = {
        start: start.format("YYYY-MM-DD"),
        end: end.format("YYYY-MM-DD")
      };
      return res;
    }
  },
  getType: function(el) {
    return "PeriodDateRangePickerBinding";
  },
  subscribe: function(el, callback) {
    $(el).on("show.daterangepicker", function(event) {
      callback();
    });
    $(el).on("hide.daterangepicker", function(event) {
      callback();
    });
    $(el).on("apply.daterangepicker", function(event) {
      callback();
    });
    $(el).on("cancel.daterangepicker", function(event) {
      var opt = JSON.parse(this.attributes.options.nodeValue);
      if (opt.cancelIsClear !== undefined && opt.cancelIsClear) {
        $(this).val('');
      } else {
        callback();
      }
    });
    $(el).on("change.daterangepicker", function(event) {
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off(".PeriodDateRangePickerBinding");
  },
  receiveMessage: function(el, data) {
    // Get daterangepicker Data
    var pickerdata = $("#"+data.id).data('daterangepicker');

    // Update Start
    if (data.hasOwnProperty("start")) {
      pickerdata.setStartDate(moment(data.start));
    }
    // Update End
    if (data.hasOwnProperty("end")) {
      pickerdata.setEndDate(moment(data.end));
    }
    // Update Icon
    if (data.hasOwnProperty("icon")) {
      var ico = $(el).parent().find("i")[0];
      if (ico !== undefined) {
        // If there is an icon already, change the class
        ico.className = data.icon.attribs.class;
      } else {
        // If no icon was given, add it to the DOM. (Add the dependencie, if not loaded initially)
        Shiny.renderDependencies(data.icon.htmldeps);
        $(el).before(' <i class="'+data.icon.attribs.class+'"></i>');
      }
    }
    // Update Label
    if (data.hasOwnProperty("label")) {
      var lbl = $(el).parent().find('label[for="' + data.id + '"]');
      // Is a label already there? If yes, update it, otherwise create it
      if (lbl.length !== 0) {
        lbl.text(data.label);
      } else {
        $(el).before('<label class="control-label" for="'+el.id+'">'+data.label+'</label>');
      }
    }
    // Update minDate
    if (data.hasOwnProperty("minDate")) {
      pickerdata.minDate = moment(data.minDate);
    }
    // Update maxDate
    if (data.hasOwnProperty("maxDate")) {
      pickerdata.maxDate = moment(data.maxDate);
    }

    // Update style
    if (data.hasOwnProperty("style")) {
      $("#"+data.id).attr("style", data.style);
    }
    // Update ranges
    if (data.hasOwnProperty("ranges")) {
      if (data.ranges !== undefined || data.ranges !== null) {
        for (var key in data.ranges) {
      		if (typeof data.ranges[key] === "string") {
      		  data.ranges[key] = [moment(data.ranges[key]), moment(data.ranges[key])];
      		} else {
      		  for (var i in [0,1]) {
      		    data.ranges[key].push(moment(data.ranges[key][0]));
      		    data.ranges[key].shift();
      		  }
      		}
        }
      }
      var ranges = {}
      for (range in data.ranges) {
          if (typeof data.ranges[range][0] === 'string')
              start = moment(data.ranges[range][0]);
          else
              start = moment(data.ranges[range][0]);

          if (typeof data.ranges[range][1] === 'string')
              end = moment(data.ranges[range][1]);
          else
              end = moment(data.ranges[range][1]);

          // If the start or end date exceed those allowed by the minDate or maxSpan
          // options, shorten the range to the allowable period.
          if (pickerdata.minDate && start.isBefore(pickerdata.minDate))
              start = pickerdata.minDate.clone();

          var maxDate = pickerdata.maxDate;
          if (pickerdata.maxSpan && maxDate && start.clone().add(pickerdata.maxSpan).isAfter(maxDate))
              maxDate = start.clone().add(pickerdata.maxSpan);
          if (maxDate && end.isAfter(maxDate))
              end = maxDate.clone();

          // If the end of the range is before the minimum or the start of the range is
          // after the maximum, don't display pickerdata range option at all.
          if ((pickerdata.minDate && end.isBefore(pickerdata.minDate, pickerdata.timepicker ? 'minute' : 'day'))
            || (maxDate && start.isAfter(maxDate, pickerdata.timepicker ? 'minute' : 'day'))) {
              continue;
            }

          //Support unicode chars in the range names.
          var elem = document.createElement('textarea');
          elem.innerHTML = range;
          var rangeHtml = elem.value;

          ranges[rangeHtml] = [start, end];
      }
      pickerdata.ranges = ranges
      var list = '<ul>';
      for (range in pickerdata.ranges) {
          list += '<li data-range-key="' + range + '">' + range + '</li>';
      }
      if (pickerdata.showCustomRangeLabel) {
          list += '<li data-range-key="' + pickerdata.locale.customRangeLabel + '">' + pickerdata.locale.customRangeLabel + '</li>';
      }
      list += '</ul>';
      pickerdata.container.find('.ranges ul').remove()
      pickerdata.container.find('.ranges').prepend(list);
    }
    // Update class
    if (data.hasOwnProperty("class")) {
      $("#"+data.id).addClass(data.class);
    }

    // Update options
    if (data.hasOwnProperty("options")) {
      // Update minYear
      if (data.options.hasOwnProperty("minYear")) {
        pickerdata.minYear = data.options.minYear;
      }
      // Update maxYear
      if (data.options.hasOwnProperty("maxYear")) {
        pickerdata.maxYear = data.options.maxYear;
      }
      //$(el).trigger("apply");
      //$(el).trigger("change");
    }
  }
});
Shiny.inputBindings.register(PeriodDateRangePickerBinding);

