class Notifications < ActionMailer::Base

	def forgot_password(to,login,pass,send_at=Time.now)
		@subject         = "Password Notification ..."
		@body['login']   = login
		@body['pass']    = pass
		@recipients      = to
		@from            = 'webdirector@waupc.com'
		@sent_on         = sent_at
		@headers         = {}
	end

end
