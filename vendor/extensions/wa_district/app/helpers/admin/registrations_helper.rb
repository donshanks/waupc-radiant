module Admin::RegistrationsHelper

  def format_for_col(column,value)
    ret_value = '';
    if value.blank? then
      ret_value = value
    elsif value.is_a? Time then
      ret_value = value.strftime("%b %e, %Y")
    elsif value.is_a? FalseClass then
      ret_value = 'No'
    elsif value.is_a? TrueClass then
      ret_value = 'Yes'
    elsif value.is_a? Float then
      ret_value = number_to_currency(value)
    elsif column == 'phone' then
      ret_value = number_to_phone(value,:area_code => true)
    elsif column == 'email' then
      ret_value = value
    elsif column == 'invoice' then
      ret_value = value.upcase
    else
      ret_value = value.titleize
    end
    return ret_value
  end

end
