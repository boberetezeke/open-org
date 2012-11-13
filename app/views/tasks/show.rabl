object :@task
attributes :id, :name
child :owner do
  attributes :id, :email_address
end

