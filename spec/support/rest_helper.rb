module RESTHelper
  def restful_actions
    # TODO: keep in sync with Typekit.actions?
    [ :index, :show, :create, :update, :delete ]
  end

  def restful_collection_actions
    # TODO: keep in sync with Typekit.collection_actions?
    [ :index, :create ]
  end

  def restful_member_actions
    # TODO: keep in sync with Typekit.member_actions?
    [ :show, :update, :delete ]
  end

  def rest_http_dictionary
    # TODO: keep in sync with Typekit.action_dictionary?
    { :index => :get, :show => :get, :create => :post,
      :update => :post, :delete => :delete }
  end
end
