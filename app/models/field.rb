# frozen_string_literal: true

class Field < ApplicationRecord
  belongs_to :calculator
  before_create :set_selector
  validates :type, :label, :kind, presence: true
  enum kind: { form: 0, parameter: 1, result: 2 }

  private

  def set_selector
    return if selector.present?

    # selected_rows_count = Field.where(kind: kind).count
    # if selected_rows_count.positive?
    #   previous_number = Field.where(kind: kind).last.selector[1]
    #   self.selector = kind[0].upcase + previous_number.next.to_s
    # else
    self.selector = "#{kind[0].upcase}1"
    # end
  end
end