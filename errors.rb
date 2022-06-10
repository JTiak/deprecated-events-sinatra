class MyError
    attr_reader :code, :title, :details, :meta

    def initialize(code, title, details, meta={})
      @code = code
      @title = title
      @details = details
      @meta = meta
    end
  
    def to_json
      resp = {
        code: @code,
        title: @title,
        details: @details
      }
      resp[:meta] = @meta unless @meta.empty?
      resp.to_json
    end
end

class UnauthorizedError < MyError
  def initialize()
    super(1001, "Unauthorized", "You are not signed in")
  end
end

class ForbiddenError < MyError
  def initialize()
    super(1002, "Forbidden", "You are not authorized to perform this action")
  end
end

class InternalServerError < MyError
  def initialize()
    super(1003, "Internal Server Error", "Something went wrong")
  end
end

module EventsErrors
  class NotFoundError < MyError
    def initialize(id:)
      super(1101, "Not Found", "Event with id #{id} not found", {type: "Event", id: id})
    end
  end

  class InvalidEventError < MyError
    def initialize(errors:)
      super(1102, "Invalid Event", "Event is invalid", {
        errors: errors
      })
    end
  end
end
