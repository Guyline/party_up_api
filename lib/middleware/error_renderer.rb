module Middleware
  class ErrorRenderer < ActionDispatch::ShowExceptions
    def call(env)
      @app.call(env)
    rescue exception
      request = ActionDispatch::Request.new env
      backtrace_cleaner = request.get_header("action_dispatch.backtrace_cleaner")
      wrapper = ExceptionWrapper.new(backtrace_cleaner, exception)
      request.set_header "action_dispatch.exception", wrapper.unwrapped_exception
      request.set_header "action_dispatch.report_exception", !wrapper.rescue_response?

      unless wrapper.show?(request)
        raise exception
      end

      status = wrapper.status_code
      body = {
        error: Rack::Utils::HTTP_STATUS_CODES.fetch(status, Rack::Utils::HTTP_STATUS_CODES[500]),
        title: exception.message
      }

      unless Rails.env.production?
        body[:detail] = {
          backtrace: exception.backtrace
        }
      end

      render status:,
        json: body
    end
  end
end
