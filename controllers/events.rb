before "/events/*" do
  require_authentication!
end

get '/events' do
  events = Event.all 
  [:topic].each do |filter|
      events = events.send(filter, params[filter]) if params[filter]
  end
  events.map { |event| EventSerializer.new(event) }.to_json
end

get '/events/:id' do |id|
  event = event = find_event(id)
  EventSerializer.new(event).to_json
end

post '/events' do
  payload = JSON.parse(request.body.read).symbolize_keys
  event = Event.create!(payload&.merge({created_at: Time.now.utc, updated_at: Time.now.utc}))
  EventSerializer.new(event).to_json
end

patch '/events/:id' do |id|
  event = find_event(id)
  payload = JSON.parse(request.body.read).symbolize_keys
  event.update_attributes(payload)
  unless event.errors.empty?
    errors = event.errors.messages.map { |k, v| {k => v} }
    halt(422, EventsErrors::InvalidEventError.new(errors: errors).to_json)
  end
  
  EventSerializer.new(event).to_json
end

delete '/events/:id' do |id|
  event = find_event(id)
  event.destroy
end

def find_event(id)
  event = Event.where(id: id).first
  halt(404, EventsErrors::NotFoundError.new(id: id).to_json) unless event
  event
end