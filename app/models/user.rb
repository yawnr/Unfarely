class User < ActiveRecord::Base

    validates :email, :password_digest, :session_token, presence: true
    validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
    message: "address invalid." }, uniqueness: true
    validates :password, length: { minimum: 6, allow_nil: true }

    after_initialize :ensure_session_token

    has_many :alerts
    has_many :airports
    has_many :cities, through: :airports

    attr_reader :password

    def self.find_by_credentials (email, password)
      user = User.where('lower(email) = ?', email.downcase).first

      if user
        return user if user.is_password?(password)
      else
        nil
      end

      nil
    end

    def password=(password)
      @password = password;
      self.password_digest = BCrypt::Password.create(password)
    end

    def is_password?(password)
      BCrypt::Password.new(self.password_digest).is_password?(password)
    end

    def generate_token
      SecureRandom.urlsafe_base64(16);
    end

    def reset_token!
      self.session_token = generate_token
      self.save!
      self.session_token
    end

    def ensure_session_token
      self.session_token ||= generate_token
    end

end
