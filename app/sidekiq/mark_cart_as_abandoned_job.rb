# frozen_string_literal: true

class MarkCartAsAbandonedJob
  include Sidekiq::Job

  def perform(*args)
    # TODO Impletemente um Job para gerenciar, marcar como abandonado. E remover carrinhos sem interação. 
    abandon_threshold = 3.hours.ago
    Cart.where(status: 'active').where('last_interaction_at < ?', abandon_threshold).update_all(status: 'abandoned')

    delete_threshold = 7.days.ago
    Cart.where(status: 'abandoned').where('last_interaction_at < ?', delete_threshold).destroy_all
  end
end
