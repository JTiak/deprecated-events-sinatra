class EventSerializer
    def initialize(event)
      @event = event
    end
    
    def as_json(*)
        data = {
            id: @event._id.to_s,
            topic: @event.topic,
            resource_id: @event.resource_id,
            resource_type: @event.resource_type,
            created_at: @event.created_at.to_s,
            updated_at: @event.updated_at.to_s
        }
        data[:errors] = @event.errors if @event.errors.any?     
        data

    end
end
