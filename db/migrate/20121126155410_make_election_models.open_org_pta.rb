# This migration comes from open_org_pta (originally 20121125192140)
class MakeElectionModels < ActiveRecord::Migration
  def up
    create_table :elections do |t|
      t.string :name
    end

    # for NominatingCommitteeGroup, and OfficerElectionGroup
    add_column :groups, :pta_election_id, :integer

    # for OfficerElectionGroup
    add_column :groups, :pta_officer_role_id, :integer

    Role.create(:name => "pta_president")
    Role.create(:name => "pta_vice_president")
    Role.create(:name => "pta_secretary")
    Role.create(:name => "pta_treasurer")
    Role.create(:name => "pta_member")
    Role.create(:name => "pta_board")
  end

  def down
    drop_table :elections
    drop_table :officer_elections
    remove_column :groups, :pta_election_id
    
    Role.where(:name => "pta_president").first.destroy
    Role.where(:name => "pta_vice_president").first.destroy
    Role.where(:name => "pta_secretary").first.destroy
    Role.where(:name => "pta_treasurer").first.destroy
    Role.where(:name => "pta_board").first.destroy
  end
end
