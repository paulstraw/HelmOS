WebsocketRails::EventMap.describe do
  # set up private channels for each star system and faction
  StarSystem.all.each do |star_system|
    star_system.channel_names.each do |channel_name|
      private_channel channel_name
    end
  end

  Faction.all.each do |faction|
    private_channel faction.channel_name
  end

  namespace :websocket_rails do
    subscribe :subscribe_private, to: Socket::ConnectionsController, with_method: :authorize_private_channel
  end

  subscribe :client_connected, to: Socket::ConnectionsController, with_method: :connected
  subscribe :client_disconnected, to: Socket::ConnectionsController, with_method: :disconnected

  subscribe :thing, to: ThingController, with_method: :thingy

  namespace :bootstrap do
    subscribe :data, to: Socket::BootstrapController, with_method: :data
  end

  namespace :ships do
    subscribe :begin_travel, to: Socket::ShipsController, with_method: :begin_travel
  end

  namespace :planets do
    subscribe :info, to: Socket::PlanetsController, with_method: :info
  end

  namespace :satellites do
    subscribe :info, to: Socket::SatellitesController, with_method: :info
  end

  namespace :messages do
    subscribe :create, to: Socket::MessagesController, with_method: :create
  end

  # You can use this file to map incoming events to controller actions.
  # One event can be mapped to any number of controller actions. The
  # actions will be executed in the order they were subscribed.
  #
  # Uncomment and edit the next line to handle the client connected event:
  #   subscribe :client_connected, :to => Controller, :with_method => :method_name
  #
  # Here is an example of mapping namespaced events:
  #   namespace :product do
  #     subscribe :new, :to => ProductController, :with_method => :new_product
  #   end
  # The above will handle an event triggered on the client like `product.new`.
end
