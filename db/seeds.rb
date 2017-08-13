require 'random_data'

50.times do
   Post.create!(
       title: RandomData.random_sentence,
       body: RandomData.random_paragraph
       ) 
end

Post.find_or_create_by!(
    title: "Unique Post",
    body: "Unique post body"
    )
    
posts = Post.all

unique_post = posts.find_by(title: "Unique Post")

100.times do
   Comment.create!(
       post: posts.sample,
       body: RandomData.random_paragraph
       ) 
end
    
Comment.find_or_create_by!(
    post: unique_post,
    body: "Unique comment body"
    )

20.times do
   Question.create!(
       title: RandomData.random_sentence,
       body: RandomData.random_paragraph,
       resolved: false
       )  
end

puts "Seed finished"
puts "#{Post.count} posts created"
puts "#{Comment.count} comments created"
puts "#{Question.count} questions created"
