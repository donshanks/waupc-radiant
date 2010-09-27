module ActionView::Helpers
  class DateTimeSelector
    def select_minute_with_simple_time_select
      return select_minute_without_simple_time_select unless @options[:simple_time_select].eql? true

      # Although this is a datetime select, we only care about the time.  Assume that the date will
      # be set by some other control, and the date represented here will be overriden

      val_minutes = @datetime.kind_of?(Time) ? @datetime.min + @datetime.hour*60 : @datetime

      if @options[:minute_interval] 
        minute_interval = @options[:minute_interval] 
      else
      # Default is 15 minute intervals
        minute_interval = 15
      end

      if @options[:upper_limit]
        upper_limit = @options[:upper_limit]
      else
        upper_limit = 1439
      end

      if @options[:lower_limit]
        lower_limit = @options[:lower_limit]
      else
        lower_limit = 0
      end

      if @options[:use_hidden] || @options[:discard_minute]
        build_hidden(:minute, val)
      else
        minute_options = []
        0.upto(1439) do |minute|
          if minute%minute_interval == 0 && minute >= lower_limit && minute <= upper_limit then
            ampm = minute < 720 ? ' AM' : ' PM'
            hour = minute/60
            minute_padded = zero_pad_num(minute%60)
            hour_padded = zero_pad_num(hour)
            ampm_hour = ampm_hour(hour)

            val = "#{hour_padded}:#{minute_padded}:00"
            minute_options << ((val_minutes == minute) ? 
              %(<option value="#{val}" selected="selected">#{ampm_hour}:#{minute_padded}#{ampm}</option>\n) :
              %(<option value="#{val}">#{ampm_hour}:#{minute_padded}#{ampm}</option>\n)
            )
          end
        end
        build_select(:minute, minute_options)
      end
    end
    alias_method_chain :select_minute, :simple_time_select

    def select_hour_with_simple_time_select
      return select_hour_without_simple_time_select unless @options[:simple_time_select].eql? true
    end
    alias_method_chain :select_hour, :simple_time_select

    def select_second_with_simple_time_select
      return select_second_without_simple_time_select unless @options[:simple_time_select].eql? true
    end
    alias_method_chain :select_second, :simple_time_select

    def select_year_with_simple_time_select
      return select_year_without_simple_time_select unless @options[:simple_time_select].eql? true
    end
    alias_method_chain :select_year, :simple_time_select

    def select_month_with_simple_time_select
      return select_month_without_simple_time_select unless @options[:simple_time_select].eql? true
    end
    alias_method_chain :select_month, :simple_time_select

    def select_day_with_simple_time_select
      return select_day_without_simple_time_select unless @options[:simple_time_select].eql? true
    end
    alias_method_chain :select_day, :simple_time_select

  end
end

def ampm_hour(hour)
  return hour == 12 ? 12 : (hour == 0 ? 12 : (hour / 12 == 1 ? hour % 12 : hour))
end

def zero_pad_num(num)
  return num < 10 ? '0' + num.to_s : num.to_s
end
