class User < ActiveRecord::Base
    has_many :posts, dependent: :destroy

	def self.from_omniauth(auth)
        user = find_or_initialize_by(gid: auth.uid)

        user.name = auth.extra.raw_info.name
        user.email = auth.extra.raw_info.email
        if auth.extra.raw_info.picture
        	user.image = auth.extra.raw_info.picture
        else
            user.image = "assets/placeholder.png"
        end
        user.gid = auth.uid

        user.save

        return user
    end
end
