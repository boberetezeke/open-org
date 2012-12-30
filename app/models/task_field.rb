class TaskField < ActiveRecord::Base
  belongs_to :task
  has_many :task_field_values

  def display_name
    display_name = read_attribute(:display_name)
    display_name ? display_name : self.name.humanize
  end
end
