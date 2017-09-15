module UsersHelper
    def has_favorites?(user)
        user.favorites 
    end
    
    def has_comments?(user)
        user.comments
    end
    
    def has_posts?(user)
        user.posts
    end
end
