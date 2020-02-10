module History
  def history
    object = controller_name.classify.constantize.find(params[:id])
    authorize object

    @history = PaperTrailScrapbook::LifeHistory.new(object).story
    object_name = controller_name.singularize.titleize

    if @history
      if @history.empty?
        render json: {
          message: "#{object_name} history not found."
          }, status: :not_found
      else
        render json: {
          message: "#{object_name} history found.",
          data: @history
        }, status: :ok
      end
    else
      render json: {
        message: "Something went wrong."
      }, status: :unprocessable_entity
    end
  end
end
