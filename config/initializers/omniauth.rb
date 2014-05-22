Rails.application.config.middleware.use OmniAuth::Builder do
	provider :google_oauth2, ENV['BP_GOOGLE_KEY'], ENV['BP_GOOGLE_SECRET'],
	{
      name: "google",
      scope: "userinfo.email, userinfo.profile",
      prompt: "select_account consent",
      image_aspect_ratio: "square",
      image_size: 1000,
      access_type: "online",
      redirect_uri:"#{ENV['BP_GOOGLE_REDIRECT']}/auth/google/callback"
    }
	#client_options: { :ssl => { :ca_file => '/usr/lib/ssl/certs/ca-certificates.crt' } }
end
