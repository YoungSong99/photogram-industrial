task sample_data: :environment do

  p "Creating sample data"

  if Rails.env.development?
    FollowRequest.destroy_all
    Comment.destroy_all
    Like.destroy_all
    Photo.destroy_all
    User.destroy_all
  end


  users = []

  ['alice', 'bob'].each do |name|
    users << User.create!(
      email: "#{name}@example.com",
      password: "password",
      username: name.downcase,
      private: [true, false].sample,
      )
  end

  10.times do
    name = Faker::Name.first_name
    users << User.create!(
      email: "#{name}@example.com",
      password: "password",
      username: name.downcase,
      private: [true, false].sample,
    )
  end

  p "There are now #{User.count} users."

  # # Generate Photos

  photos = []

  50.times do
    photos << Photo.create!(
      caption: Faker::Lorem.sentence,
      image: "http://robohash.org/#{rand(9999)}",
      owner_id: users.sample.id
    )
  end

  # Generate Comments
  50.times do
    photo = photos.sample
    author = users.sample

    c = Comment.create!(
      author_id: author.id,
      body: Faker::Lorem.paragraph,
      photo_id: photo.id
    )
    photo.update(comments_count: photo.comments_count + 1)
    author.update(comments_count: author.comments_count + 1)

    p c.errors.full_messages

  end

  # Generate Likes
  100.times do
    photo = photos.sample
    fan = users.sample

    unless Like.exists?(fan_id: fan.id, photo_id: photo.id)
      l = Like.create!(
        fan_id: fan.id,
        photo_id: photo.id
      )
      photo.update(likes_count: photo.likes_count + 1)
      fan.update(likes_count: fan.likes_count + 1)
    end
  end

  # Generate FollowRequests
  30.times do
    sender = users.sample
    recipient = users.sample
    next if sender == recipient
    f = FollowRequest.create!(
      sender_id: sender.id,
      recipient_id: recipient.id,
      status: ["pending", "accepted", "rejected"].sample
    )

    p f.errors.full_messages
  end

  puts "Sample data generated successfully!"
end