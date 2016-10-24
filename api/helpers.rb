module HelpersApp
  # A protected page will only be available if you are authorized
  def protected!
    if authorized?
      true
    else
      halt 401
    end
   end

  # You are autorized if you have logged in
  def authorized?
    if session[:logged]
      true
    else
      false
    end
  end
end
