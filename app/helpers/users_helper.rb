module UsersHelper
    def user_has_favorites?
        current_user.favorites 
    end
    
    def user_has_comments?
        current_user.comments
    end
    
    def user_has_posts?
        current_user.posts
    end
end
