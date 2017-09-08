class FavoriteMailer < ApplicationMailer
    default from: "anders.kirsten@gmail.com"
    
    def new_comment(user, post, comment)
       headers["Message-ID"] = "<comments/#{comment.id}@gentle-river-71375.herokuapp.com>"
       headers["In-Reply-To"] = "<post/#{post.id}@gentle-river-71375.herokuapp.com>"
       headers["References"] = "<post/#{post.id}@gentle-river-71375.herokuapp.com>"
 
       @user = user
       @post = post
       @comment = comment
 
       mail(to: user.email, subject: "New comment on #{post.title}") 
    end
    
    def new_post(post)
       headers["Message-ID"] = "<post/#{post.id}@gentle-river-71375.herokuapp.com>"
       headers["In-Reply-To"] = "<post/#{post.id}@gentle-river-71375.herokuapp.com>"
       headers["References"] = "<post/#{post.id}@gentle-river-71375.herokuapp.com>"
 
       @post = post
 
       mail(to: post.user.email, subject: "You're following #{post.title}") 
    end
end
