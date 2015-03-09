class RelationshipsController < ApplicationController
	before_filter :authenticate_user!

	def follow
		@user = User.find_by(username: params[:id])
		if @user.nil? or current_user == @user or @user.followers.include?(current_user)
			redirect_to user_path(@user)
		else
			@user.followers << current_user
			@user.save!
			@notification = Notification.new  actor: current_user,
                                        action: 3,
                                        object_type: 2,
                                        object_id: @user.id
      @notification.victims << @user
      @notification.save!

      #TODO: it might be better to show flash messages on successful and unsuccessful requests.
			respond_to do |format|
				format.js { render template: "relationships/update_social" }
				format.html { redirect_to user_path(@user) }
			end
		end
	end

	def unfollow
		@user = User.find_by(username: params[:id])
		relation = Relationship.find_by(follower_id: current_user.id, following_id: @user.id)
		relation.destroy if relation
		respond_to do |format|
			format.js { render template: "relationships/update_social" }
			format.html { redirect_to user_path(@user) }
		end
	end
end
