class User
  
  attr_accessor :provider, :uid, :name, :email
  
  def initialize(auth)
    @provider = auth['provider']
    @uid = auth['uid']
    if auth['user_info']
      @name = auth['user_info']['name'] if auth['user_info']['name']
      @email = auth['user_info']['email'] if auth['user_info']['email']
    end
    if auth['extra']['user_hash']
      @name = auth['extra']['user_hash']['name'] if auth['extra']['user_hash']['name']
      @email = auth['extra']['user_hash']['email'] if auth['extra']['user_hash']['email']
    end
    
    @email = "matheustardivo@gmail.com" unless @email
  end
end
