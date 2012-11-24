class OrganizationsController < InheritedResources::Base
  actions :index, :show, :new, :edit

protected
  def collection
    c = current_user.organizations
    puts "c = #{c.inspect}"
    c
  end

  def resource
    if params[:id] then
      current_user.organizations.find(params[:id])
    else
      organization = Organization.new
    end
  end
end
