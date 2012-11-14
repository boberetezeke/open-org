class RolesController < ApplicationController
  def show
    @role = Role.find(params[:id])
  end
end
