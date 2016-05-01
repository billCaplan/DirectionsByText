Rails.application.routes.draw do
  get 'messages/reply'

  resource :messages do
    collection do
      post 'reply'
    end
  end
end
