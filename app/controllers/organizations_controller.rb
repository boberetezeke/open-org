class OrganizationsController < ApplicationController
  def index
    @organizations = current_user.organizations
  end

  def show
    @organization = current_user.organizations.find(params[:id])
  end
end
