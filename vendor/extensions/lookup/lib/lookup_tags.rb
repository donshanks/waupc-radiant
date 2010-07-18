module LookupTags
  include Radiant::Taggable
  include WillPaginate::ViewHelpers

  class RadiantLinkRenderer < WillPaginate::LinkRenderer
    include ActionView::Helpers::TagHelper

    def initialize(tag)
      @tag = tag
    end

    def page_link(page, text, attributes = {} )
      attributes = tag_options(attributes)
      %Q{<a href="?page=#{page}">#{text}</a>}
    end

    def gap_marker
      '<span class="gap">&#8230;</span>'
    end

    def page_span(page, text, attributes = {} )
      attributes = tag_options(attributes)
      "<span#{attributes}>#{text}</span>"
    end
  end

  # #########################
  #  Deputations Lookups
  # #########################

  tag 'deputations' do |tag|
    tag.expand
  end

  tag 'deputations:collection' do |tag|

    result = []

    limit = tag.attr['limit']
    limit ||= 3
      
    collection = Deputation.find(:all,
      :conditions => 'date_end >= CURRENT_DATE',
      :order      => 'date_start ASC',
      :limit      => limit
    )

    collection.each do |deputation|
      tag.locals.deputation = deputation
      result << tag.expand
    end

    result

  end

  tag 'deputations:collection:date_range' do |tag|
    deputation = tag.locals.deputation
    deputation.date_range
  end

  tag 'deputations:collection:reserve_link' do |tag|
    deputation = tag.locals.deputation
    %(<a href="/missionaries/#{deputation.id}">#{deputation.missionary.name} - #{deputation.missionary.labor}</a>)
  end

  # #########################
  #  Ministers Lookups
  # #########################

  tag 'ministers' do |tag|

    page = tag.globals.page.request.parameters['page'] unless tag.globals.page.request.nil? 
    page ||= 1

    per_page = tag.attr['per_page']
    per_page ||= 20

    collection = Minister.paginate_by_status('active',
      :page     => page,
      :per_page => per_page,
      :order    => 'lastname ASC'
    )

    tag.locals.collection = collection

    tag.expand 

  end

  tag 'ministers:each' do |tag|

    result = []

    tag.locals.collection.each_with_index do |item,index|
      tag.locals.minister = item
      tag.locals.index = index
      result << tag.expand
    end

    result

  end

  %w(
    id status full_name lastname firstname address city state 
    zip title phone_home phone_mobile phone_fax email notes
  ).each do |type|

    tag "ministers:each:#{type}" do |tag|

      minister = tag.locals.minister
      minister.send(type.to_sym)

    end

  end

  tag 'ministers:each:mail_to_link' do |tag|
    
    minister = tag.locals.minister
    if !minister.email.blank?
      %Q{<a href="mailto:#{minister.email}" class="minister-email">#{minister.email}</a>}
    else
      %Q{<span class="noemail">no e-mail available</span>}
    end

  end

  tag 'ministers:each:odd_or_even' do |tag|
    if tag.locals.index % 2 == 0
      " even"
    else
      " odd"
    end
  end

  tag 'ministers:pagination' do |tag|
    
    renderer = RadiantLinkRenderer.new(tag)

    will_paginate tag.locals.collection, { :renderer => renderer }
    
  end

  # #########################
  #  Churches Lookups
  # #########################

  tag 'churches' do |tag|

    unless tag.globals.page.request.nil? 
      page = tag.globals.page.request.parameters['page']
      page ||= 1

      sort = tag.globals.page.request.parameters['sort']
      sort ||= 'outreach_cities'
    end

    per_page = tag.attr['per_page']
    per_page ||= 20

    collection = Church.paginate_by_status('active',
      :page       => page,
      :per_page   => per_page,
      :order      => "#{sort} ASC"
    )

    tag.locals.collection = collection

    tag.expand 

  end

  tag 'churches:each' do |tag|

    result = []

    tag.locals.collection.each_with_index do |item,index|
      tag.locals.church = item
      tag.locals.index = index
      result << tag.expand
    end

    result

  end

  %w(
    id status church_name section outreach_cities lat lon physical_address
    physical_city physical_zip mailing_address mailing_city mailing_zip
    phone phone2 fax email web languages googlelink full_physical_address
    full_mailing_address lat1 lon1 distance
  ).each do |type|

    tag "churches:each:#{type}" do |tag|

      church = tag.locals.church
      church.send(type.to_sym)

    end

  end

  tag 'churches:each:pastor' do |tag|
    church = tag.locals.church
    church.minister.full_name_with_title
  end

  tag 'churches:each:email_link' do |tag|
    church = tag.locals.church
    link = ''
    unless church.email.blank?
      link = %Q{<a href="mailto:#{church.email}">#{church.email}</a>}
    end
    link
  end

  tag 'churches:each:website_link' do |tag|
    church = tag.locals.church
    link = ''
    unless church.web.blank?
      link = %Q{<a href="#{church.web}">#{church.web}</a>}
    end
    link
  end

  tag 'churches:each:physical_addr' do |tag|
    church = tag.locals.church
    addr = ''
    unless church.physical_address.blank? 
      addr += "#{church.physical_address}<br />"
    end
    unless church.physical_city.blank? 
      addr += "#{church.physical_city}, WA"
      unless church.physical_zip.blank?
        addr += " #{church.physical_zip}"
      end
      addr += "<br />"
    end
    unless addr.blank?
      addr = "<b>Physical Address:</b><br />#{addr}"
    end
    addr
  end

  tag 'churches:each:mailing_addr' do |tag|
    church = tag.locals.church
    addr = ''
    unless church.mailing_address.blank? 
      addr += "#{church.mailing_address}<br />"
    end
    unless church.mailing_city.blank? 
      addr += "#{church.mailing_city}, WA"
      unless church.mailing_zip.blank?
        addr += " #{church.mailing_zip}"
      end
      addr += "<br />"
    end
    unless addr.blank?
      addr = "<b>Mailing Address:</b><br />#{addr}"
    end
    addr
  end

  tag 'churches:each:odd_or_even' do |tag|
    if tag.locals.index % 2 == 0
      " even"
    else
      " odd"
    end
  end

  tag 'churches:pagination' do |tag|
    
    renderer = RadiantLinkRenderer.new(tag)

    will_paginate tag.locals.collection, { :renderer => renderer }
    
  end

end
