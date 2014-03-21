class User < ActiveRecord::Base
    has_many :posts, dependent: :destroy

    validates_presence_of :name, :email, :image, :gid, :admin, :approved, :blurb, :year

	def self.from_omniauth(auth, create)
        user = find_or_initialize_by(gid: auth.uid)

        user.name = auth.extra.raw_info.name
        user.email = auth.extra.raw_info.email
        if auth.extra.raw_info.picture
        	user.image = auth.extra.raw_info.picture
        else
            user.image = "assets/placeholder.png"
        end
        user.gid = auth.uid

        if create
            user.admin = false
            user.approved = false
            user.blurb = user.name + " has not written anything yet."
            user.year = "Unknown"
        end

        user.save

        return user
    end
end
