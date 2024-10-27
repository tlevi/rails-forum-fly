# WARNING: Never do this for a REAL app!
DatabaseCleaner.allow_production = true
DatabaseCleaner.allow_remote_database_url = true

DatabaseCleaner.clean_with(:truncation)

guestpw = SecureRandom.alphanumeric(16)

User.create!({
  username:              'guest',
  password:              guestpw,
  password_confirmation: guestpw,
  email:                 '',
  preferredname:         'Guest',
  role:                  'guest',
})

admin = User.create!({
  username:              'admin',
  password:              'admin',
  password_confirmation: 'admin',
  email:                 'admin@example.com',
  preferredname:         'CoolAdminName',
  role:                  'admin',
})

User.create!({
  username:              'member',
  password:              'member',
  password_confirmation: 'member',
  email:                 'member@example.com',
  preferredname:         'CoolMemberName',
  role:                  'member',
})

User.create!({
  username:              'moderator',
  password:              'moderator',
  password_confirmation: 'moderator',
  email:                 'moderator@example.com',
  preferredname:         'CoolModeratorName',
  role:                  'moderator',
})

forum = Forum.create!({
  title: "Announcements",
  description: "Important announcements about the site",
# TODO: Add a "pin" option to forum?
#  pinned: true,
})

Forum.create!({
  title: "Welcome",
  description: "A place to greet new members",
#  pinned: true,
})

Forum.create!({
  title: "Welcome",
  description: "A place to greet new members",
#  pinned: true,
})

ActiveRecord::Base.transaction do
  post = Post.create({
    body:    "This is the first post, ever.",
    forum:   forum,
    author:  admin,
  })

  topic = Topic.create({
    title:      "First post!",
    forum:      forum,
    author:     post.author,
    first_post: post,
  })

  post.update(topic: topic)
end
