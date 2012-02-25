Factory.define :user do |user|
  user.name                   "Shane Etzenhouser"
  user.email                  "rortut_shane@etzenhouser.com"
  user.password               "foobar"
  user.password_confirmation  "foobar"
end

Factory.sequence :name do |n|
  "Person #{n}"
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end

Factory.define :topic do |topic|
  topic.title                 "Can I create a topic with Factory"
end

Factory.define :post do |post|
  post.content  "This is the theif that didn't think to wear a thimble this Thursday."
end