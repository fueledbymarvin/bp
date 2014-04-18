Rails.application.config.middleware.use OmniAuth::Builder do
	provider :google_oauth2, ENV['google_key'], ENV['google_secret'],
	{
      name: "google",
      scope: "userinfo.email, userinfo.profile",
      prompt: "select_account consent",
      image_aspect_ratio: "square",
      image_size: 1500,
      redirect_uri:"#{ENV['google_redirect']}/auth/google/callback"
    }
	#client_options: { :ssl => { :ca_file => '/usr/lib/ssl/certs/ca-certificates.crt' } }
end