class V1::ApplicationController < ApplicationController
  before_action :skip_session
  before_action :doorkeeper_authorize!
  before_action :set_includes,
    only: [
      :index
    ]
  before_action :set_pagination_params,
    only: [
      :index
    ]

  after_action :set_count_header,
    only: [
      :index
    ]

  def index
    @resources = index_query
      .page(@page)
      .per(@per_page)
      .order({@sort => @order})
      .includes(valid_includes.values)
  end

  protected

  def set_pagination_params
    @page = params.fetch(:page, 1)
    @per_page = params.fetch(:per_page, 20)
    @sort = params.fetch(:sort, :created_at)
    @order = params.fetch(:order, :asc)
  end

  def set_includes
    include_params = params[:include]
    unless include_params.is_a?(String) && !include_params.empty?
      @includes = []
      return
    end

    requested_includes = include_params.split(",")
    @includes = valid_includes.slice(*requested_includes).values
  end

  def set_count_header
    response.headers["X-Total-Count"] = @resources&.total_count || nil
  end

  def valid_includes
    raise NotImplementedError
  end

  def index_query
    raise NotImplementedError
  end

  private

  # def parse_includes
  #   # Example:
  #   #
  #   # Input:
  #   #   params = {
  #   #     :include => "a.b.c,a.b.d.e,a.f,g,h.i",
  #   #   }
  #   #
  #   # Output:
  #   #   @includes = [
  #   #     {
  #   #       :a => [
  #   #         {
  #   #           :b => [
  #   #             :c,
  #   #             {
  #   #               :d => :e
  #   #             }
  #   #           ]
  #   #         },
  #   #         :f
  #   #       ]
  #   #     },
  #   #     :g,
  #   #     {
  #   #       :h => :i
  #   #     }
  #   #   ]

  #   include = params[:include]
  #   unless include.is_a?(String)
  #     return []
  #   end

  #   parse_include_param = proc { |memo, element|
  #     raise "String parameter expected" unless element.is_a?(String) && !element.empty?

  #     key, values = element.split(".", 2)
  #     key = key.to_sym

  #     result = key
  #     # If there are no additional values, the parsed parameter is just a base symbol
  #     unless values.nil?
  #       # There are additional values, the parsed parameter is a hash merged with the existing
  #       #   values referenced by the key
  #       nested_memo = memo.is_a?(Hash) ?
  #         memo[key] :
  #         nil
  #       result = {
  #         key => parse_include_param.call(nested_memo, values)
  #       }
  #     end

  #     if memo.nil?
  #       result
  #     elsif memo.is_a?(Array)
  #       memo + [result]
  #     elsif memo.is_a?(Hash) && result.is_a?(Hash)
  #       memo.merge(result)
  #     else
  #       [
  #         memo,
  #         result
  #       ]
  #     end
  #   }

  #   include.split(",").reduce(nil, &parse_include_param)
  # end

  def skip_session
    request.session_options[:skip] = true
  end

  def current_user
    # @current_user ||= User.where(email: "guyline82@gmail.com").first
    @current_user ||= User.find_by(id: doorkeeper_token[:resource_owner_id])
  end
end
