# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


User.new({
  username:      'guest',
  password:      SecureRandom.alphanumeric(16),
  email:         '',
  preferredname: 'Guest',
  role:          'guest',
}).save!

User.new({
  username:      'admin',
  password:      'admin',
  email:         'admin@example.com',
  preferredname: 'CoolAdminName',
  role:          'admin',
}).save!

User.new({
  username:      'member',
  password:      'member',
  email:         'member@example.com',
  preferredname: 'CoolMemberName',
  role:          'member',
}).save!

User.new({
  username:      'moderator',
  password:      'moderator',
  email:         'moderator@example.com',
  preferredname: 'CoolModeratorName',
  role:          'moderator',
}).save!

Forum.new({
  title: "Announcements",
  description: "Important announcements about the site",
# TODO: Add a "pin" option to forum?
#  pinned: true,
}).save!

Forum.new({
  title: "Welcome",
  description: "A place to greet new members",
#  pinned: true,
}).save!
