class Event
  include Mongoid::Document
  include Mongoid::Timestamps

  field :topic, type: String
  field :resource_type, type: String
  field :resource_id, type: String
  
  index({ topic: 'text' })

  validates_presence_of :topic, :resource_type, :resource_id
  
  scope :topic, -> (topic) { where(topic: /^#{topic}/) }
end