class PostsController < CrudController
  self.nesting = Topic

  self.action_access_by_role = {
    guest:  %i[ index show ],
    member: %i[ new create update ],
  }

end
