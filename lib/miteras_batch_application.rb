require 'selenium-webdriver'
require_relative './user'

class Attendance
  def initialize(argv, params)
    @username = argv[0]
    @password = argv[1]
    @reason = argv[2] || 'slack確認のため'
    @params = params
  end

  def input
    @index = 0
    @session = Selenium::WebDriver.for :chrome
    @session.manage.timeouts.implicit_wait = 10
    User.new(@username, @password, @session).login
    move_work_condition_page
    make_batch_application
    @session.quit
  end

  private

  def move_work_condition_page
    @session.find_element(:id, 'work-condition-page').click
    sleep(1)
  end

  def make_batch_application
    @table01_row = @session.find_elements(:class, "table01__row")
    while @index < @table01_row.length
      @row = @table01_row[@index]
      check_on_holidays if @params[:c]
      enter_reason_discrepancy if @params[:e]
      @index += 1
    end
    @session.find_element(:id, 'batch-request').click
    @session.find_element(:id, 'save-batch-request').click
  end

  def enter_reason_discrepancy
    if @row.find_elements(:class, 'alert-tooltip').first
      @row.find_element(:class, 'divergence').click
      sleep(1)
      @session.find_element(:id, 'reason').send_keys(@reason)
      @session.find_element(:id, 'regist').click
      divergence_close = @session.find_element(:class, 'modalConfirm__btnBox').find_element(:class, 'divergence-close')
      divergence_close.click
      sleep(1)
      @table01_row = @session.find_elements(:class, "table01__row")
    end
  end

  def check_on_holidays
    wday = @row.text.match(/\(.\)/)[0]
    @row.find_element(:class, 'monthly-checkbox').click if wday == '(土)' || wday == '(日)'
  end
end
