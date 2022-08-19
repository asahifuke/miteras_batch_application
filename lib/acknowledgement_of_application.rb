class AcknowledgementOfApplication
  def initialize(table_row)
    @table_row = table_row
  end

  def check_on_holidays
    puts 
    @table_row.find_element(:class, 'monthly-checkbox').click if past_day? && unapplied?
  end

  private

  def past_day?
    require_table_row_day <= Date.today.day
  end
  
  def require_table_row_day
    @table_row.text.match(/^[0-9]*/)[0].to_i
  end

  def unapplied?
    !@table_row.text.include?('申請済')
  end
end
