module LookupTags
  include Radiant::Taggable

  tag 'lookup' do |tag|

    html = ''

    if tag.attr['service'] == 'deputations' 

      limit = tag.attr['limit']
      limit ||= 3
      
      Deputation.find(:all, 
        :conditions => 'date_end >= CURRENT_DATE',
        :order      => 'date_start ASC',
        :limit      => limit
      ).each do |deputation|
        html << %(
          <div class="deputation">
            <div class="dates">#{deputation.date_range}</div>
            <a href="/missionaries/#{deputation.id}">#{deputation.missionary.name} - #{deputation.missionary.labor}</a>
          </div>
        )
      end

    end

    html

  end

end
