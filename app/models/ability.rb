class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.new_record?
      guest
    else
      signed_in_user
      project_owner
    end
  end

  def guest
    can [:index,
         :blob,
         :branches,
         :show,
         :network,
         :commits,
         :commit,
         :tree,
         :file_history
        ], Project
  end

  def signed_in_user
    guest # Inherits abilities of guest
    can [:new,
         :create,
         :followed_index,
         :follow,
         :unfollow,
         :fork,
         :open
        ], Project
  end

  def project_owner
    can [:update_image,
         :file_upload,
         :file_delete,
         :settings,
         :newfile,
         :create_directory,
         :create_branch,
         :destory,
         :update,
         :file_update,
         ], Project do |project|
      project.try(:user_id) == user.id
    end
  end
end
