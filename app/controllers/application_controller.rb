class ApplicationController < ActionController::Base

  protected

  def api_success(data = {}, options = {})
    render json: data, **options
  end

  def api_error(error, status = 400)
    if error.kind_of?(ActiveRecord::Base)
      error = error.errors.full_messages.first
    end
    render json: { error: error }, status: status
  end

  def json_for(target, options = {})
    return nil unless target
    serializer = options[:serializer] || ActiveModel::Serializer.serializer_for(target, options)
    options[:scope] ||= current_user
    options[:url_options] ||= url_options
    serializer.new(target, options).to_json
  end
  
end
