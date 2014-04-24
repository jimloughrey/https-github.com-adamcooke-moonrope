controller :users do

  action :list do
    
    #
    # Set a description for the action including what it does and how
    # it works.
    #
    description "Lists all users in the application"
    
    # 
    # Set any params which are supported by this action.
    #
    param :page, "The current page number for pagination.", :default => 1
    
    #
    # Set the access condition required to access this action.
    #
    access { auth.is_a?(User) }
    
    #
    # Define what actually happens when a user calls this action. It must
    # return a JSON-able object - a string, array or hash.
    #
    action do
      {
        :records => [],
        :pagination => {:page => params['page'], :total => 0}
      }
    end
    
  end
  
  action :info do
    description "Return all information about a given user"
    param :user, "The ID of the user you wish to view"
    access { auth.is_a?(User) }
    action { {:id => 1, :username => 'awesomeuser'} }
  end
  
end