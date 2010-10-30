require 'uri'

class BreadController < ApplicationController
  layout nil
  no_login_required

  @@books = []
  @@cache = {}

  def index
    t = Time.new
    params[:year]  = t.year
    params[:month] = t.month
    params[:day]   = t.day

    lookup_by_date
  end

  def lookup_by_date
    
    reading_date = Time.local(params[:year],params[:month],params[:day])
    lang = (params['l'] == 'es') ? 'es' : 'en'
    path = (params['a'] == 'youth') ? 'youth' : 'adult'

    if @@books.empty? then
      BibleBooks.find(:all).each do |book|
        @@books[ book.number ] = {
          :book_en => book.book_en,
          :abbr_en => book.abbr_en,
          :book_es => book.book_es,
          :abbr_es => book.abbr_es,
          :short   => book.short
        }
      end
    end

    formatted_date = reading_date.strftime("%Y-%m-%d")

    bread = @@cache[ "#{formatted_date} #{path}" ]
    
    if bread.blank? then
      bread = BreadReadings.find_all_by_reading_date_and_path formatted_date,path
      @@cache[ "#{formatted_date} #{path}" ] = bread
    end

    @tagall = ''
    
    bread.each do |slice|

      book_lang = "book_#{lang}".to_sym

      tag = "#{@@books[slice.book_start][book_lang]} "  

      if slice.chapter_start > 0 then
        if slice.verse_start > 0 then
          tag << "#{slice.chapter_start}:#{slice.verse_start}"
        else
          tag << slice.chapter_start.to_s
        end
      end

      if slice.book_start != slice.book_end then
        tag << "#{@@books[slice.book_start][book_lang]} "  
      end
     
      if slice.chapter_start == slice.chapter_end then
        if slice.verse_start != slice.verse_end then
          tag << "-#{slice.verse_end}"
        end
      elsif slice.chapter_end > 0 then
        tag << '-'
        if slice.verse_end > 0 then
          tag << "#{slice.chapter_end}:#{slice.verse_end}"
        else
          tag << slice.chapter_end.to_s
        end
      end

      passage = URI.escape(ERB::Util::html_escape(tag))

      link = <<-EOL
		  <a target="_blank" 
        href="http://www.biblegateway.com/bible?language=#{lang})&amp;version=9&amp;passage=#{passage}" 
        title="Read Now!"><img border="0" alt="Read Now!" src="http://www.waupci.com/images/bibleicon.gif"
        style="vertical-align:middle;" /></a>#{tag}<br />
      EOL

      @tagall << link

    end

	  @tagall << '<a href="http://www.waupci.com/sundayschool/bread" target="_blank" style="font-size:12px;">Read more about the B.R.E.A.D. daily bible reading program.</a>';

    if @@cache.length > 10 then
      
      cache_keys = @@cache.keys.sort.reverse[0..10]
      @@cache.each_key {|k| @@cache.delete(k) if cache_keys.include?(k) }

    end

    render :template => 'bread/index'

  end

end
