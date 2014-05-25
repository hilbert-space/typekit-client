module RESTHelper
  def restful_actions
    [ :index, :show, :create, :update, :delete ]
  end

  def restful_member_actions
    [ :show, :update, :delete ]
  end

  def restful_collection_actions
    [ :index, :create ]
  end

  def rest_http_dictionary
    {
      :index => :get,
      :show => :get,
      :create => :post,
      :update => :post,
      :delete => :delete
    }
  end
end
