class ApplicationController < ActionController::Base
  protect_from_forgery
  rescue_from HTTPStatus::NotFound, with: :render_404
  rescue_from HTTPStatus::BadRequest, with: :render_400
  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  before_filter TourFilter
  before_filter NewsFilter

  def append_info_to_payload(payload)
    super
    payload[:genes] = params[:gene_names] if params[:gene_names]
  end

  def not_found(msg = "Not Found")
    raise HTTPStatus::NotFound.new(msg)
  end

  def bad_request(msg = "Bad Request")
    raise HTTPStatus::BadRequest.new(msg)
  end

  [404,400].each do |status|
    define_method("render_#{status}") do |exception|
      flash.now[:error] = exception.message
      respond_to do |type|
        type.html { render template: "errors/#{status}", layout: 'application', status: status }
        type.json { render json: { error: exception.message }.to_json, status: status }
        type.xml  { render xml: { error: exception.message }.to_xml, status: status }
        type.all  { render nothing: true, status: status }
      end
    end
  end

  def combine_input_genes(params)
    bad_request("Please enter at least one gene category to search!") unless params[:genes]
    split_char = if params[:genes].include?(',')
      ','
    else
      "\n"
    end
    gene_names = params[:genes].split(split_char)
    gene_names.delete_if{ |gene| gene.strip.empty? }
    params[:gene_names] = gene_names.map{ |name| name.strip.upcase }.uniq
  end

  private
  def validate_interaction_request(params)
    bad_request('You must enter at least one gene name to search!') if params[:gene_names].size == 0
  end

end
