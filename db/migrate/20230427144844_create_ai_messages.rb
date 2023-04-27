class CreateAiMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :ai_messages do |t|
      t.integer :user_id
      t.string :content
      t.string :role

      t.timestamps
    end
  end
end
