collection :@tasks
attributes :id, :name, :description
node(:user, :if => lambda{|t| t.owner_id && t.owner_type == "User"}) do |task|
  {
    :id => task.owner_id,
    :email_address => task.owner.email_address
  }
end
node(:group, :if => lambda{|t| t.owner_id && t.owner_type == "Group"}) do |task|
  {
    :id => task.owner_id,
    :name => task.owner.name
  }
end

