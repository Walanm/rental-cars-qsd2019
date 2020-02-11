class AddCancellationReasonToRental < ActiveRecord::Migration[5.2]
  def change
    add_column :rentals, :cancellation_reason, :string
  end
end
