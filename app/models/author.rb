# == Schema Information
#
# Table name: authors
#
#  id                     :integer          not null, primary key
#  name                   :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default("0"), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class Author < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, #:registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :posts
  
  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/assets/default-user.png"

  validates_attachment :image, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }
  validates_presence_of :name, on: :update
  
  def change_password(attrs)
    update(password: attrs[:new_password], password_confirmation:attrs[:new_password_confirmation])
  end
  
  def image_url
    return gravatar_img_url unless image_file_name
    image.url(:thumb)
  end
  
  def gravatar_img_url
    hash = Digest::MD5.hexdigest(email.downcase)
    "https://www.gravatar.com/avatar/#{hash}"
  end
  
  def display_name
    if name.present?
      name
    else
      "Author"
    end
  end
end
