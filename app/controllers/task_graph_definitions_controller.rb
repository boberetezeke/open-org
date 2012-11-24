class TaskGraphDefinitionsController < InheritedResources::Base
  belongs_to :organization, :shallow => true
end
