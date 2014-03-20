if Rails.env == "production"
  ENV['google_key'] = "965729483714-rrbfbejv31ln21i45o96jppqmvm80354" 
  ENV['google_secret'] = "rplgkgOa97xWawlPVZRw4FOw"
  ENV['google_redirect'] = "http://localflows.herokuapp.com"
else
  ENV['google_key'] = "298167526255-4fbbktm5c54v5781hmj9a6vlh1h7p17r" 
  ENV['google_secret'] = "PlW80p64KEJFBodvxh2JRrWr"
  ENV['google_redirect'] = "http://localhost:3000"
end

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