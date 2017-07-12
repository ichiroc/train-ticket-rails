class Ticket < ApplicationRecord
  belongs_to :entered_gate, class_name: 'Gate', foreign_key: 'entered_gate_id'
  belongs_to :exited_gate, class_name: 'Gate', foreign_key: 'exited_gate_id', required: false
  validates :fare, presence: true, inclusion: Gate::FARES
  validates :entered_gate_id, presence: true

  validate :validate_exited_gate, if: -> { exited_gate.present? }

  def used?
    exited_gate.present?
  end

  private

  def exitable?
    exited_gate.exit?(self)
  end

  def validate_exited_gate
    errors.add(:exited_gate_id, 'では降車できません。') unless exitable?
  end
end
