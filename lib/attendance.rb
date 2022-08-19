require 'selenium-webdriver'
require_relative './user'
require_relative './acknowledgement_of_application'

class Attendance
  def initialize(argv, params)
    @session = Selenium::WebDriver.for :chrome
    @session.manage.timeouts.implicit_wait = 10
    @user = User.new(argv[0], argv[1], @session)
    @reason = argv[2] || 'slack確認のため'
    @is_c = params[:c]
    @is_e = params[:e]
  end

  def input
    @user.login
    move_work_condition_page
    enter_discrepancy_reasons if @is_e
    check_on_holidays if @is_c
  end

  private

  def move_work_condition_page
    @session.find_element(:id, 'work-condition-page').click
    sleep(1)
  end

  def enter_discrepancy_reasons 
    find_table_row.length.times { |index| enter_discrepancy_reason(index) }
  end

  def find_table_row
    @session.find_elements(:class, "table01__row")
  end

  def enter_discrepancy_reason(index)
    if find_alert_tooltip(index)
      find_table_row[index].find_element(:class, 'divergence').click
      sleep(1)
      @session.find_element(:id, 'reason').send_keys(@reason)
      @session.find_element(:id, 'regist').click
      @session.find_element(:class, 'modalConfirm__btnBox').find_element(:class, 'divergence-close').click
      sleep(1)
    end
  end

  def find_alert_tooltip(index)
    find_table_row[index].find_elements(:class, 'alert-tooltip').first
  end

  def check_on_holidays
    find_table_row.map do |table_row|
      AcknowledgementOfApplication.new(table_row).check_on_holidays
    end
    @session.find_element(:id, 'batch-request').click
    @session.find_element(:id, 'save-batch-request').click
    sleep(4)
  end
end






# require 'miteras_batch_application'
require 'optparse'

opt = OptionParser.new
params = {}
opt.on('-c') {|v| params[:c] = v }
opt.on('-e') {|v| params[:e] = v }
opt.parse!(ARGV)
attendance = Attendance.new(ARGV, params)
attendance.input
