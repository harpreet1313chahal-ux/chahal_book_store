class ProvincesController < ApplicationController
  def index
    @provinces = Province.all.order(:name)
  end

  def edit
    @province = Province.find(params[:id])
  end

  def update
    @province = Province.find(params[:id])

    if @province.update(province_params)
      redirect_to provinces_path, notice: "Tax rates updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def province_params
    params.require(:province).permit(:gst, :pst, :hst)
  end
end
