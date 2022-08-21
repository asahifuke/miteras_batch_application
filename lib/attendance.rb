# frozen_string_literal: true

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
    @session.find_elements(:class, 'table01__row')
  end

  def enter_discrepancy_reason(index)
    return unless find_alert_tooltip(index)

    find_table_row[index].find_element(:class, 'divergence').click
    sleep(1)
    @session.find_element(:id, 'reason').send_keys(@reason)
    @session.find_element(:id, 'regist').click
    @session.find_element(:class, 'modalConfirm__btnBox').find_element(:class, 'divergence-close').click
    sleep(1)
  end

  def find_alert_tooltip(index)
    find_table_row[index].find_elements(:class, 'alert-tooltip').first
  end

  def check_on_holidays
    check_table_row_holiday
    click_batch_approval_application_button
    sleep(4)
  end

  def check_table_row_holiday
    find_table_row.map { |table_row| AcknowledgementOfApplication.new(table_row).check_on_holidays }
  end

  def click_batch_approval_application_button
    return if @session.find_element(:class, 'u_relative')

    @session.find_element(:id, 'batch-request').click
    @session.find_element(:id, 'save-batch-request').click
  end
end
