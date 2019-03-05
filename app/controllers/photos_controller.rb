class PhotosController < ApplicationController
  before_action :set_event, only: [:create, :destroy]
  before_action :set_photo, only: :destroy

  def create
    @new_photo = @event.photos.build(photo_params)
    @new_photo.user = current_user

    if @new_photo.save
      flash[:notice] = I18n.t('controllers.photos.created')
      redirect_to @event
    else
      flash.now[:alert] = I18n.t('controllers.photos.error')
      render 'events/show'
    end
  end

  def destroy
    type, message = :notice, I18n.t('controllers.photos.destroyed')

    if current_user_can_edit?(@photo)
      @photo.destroy
    else
      type, message = :alert, I18n.t('controllers.photos.error')
    end

    flash[type] = message
    redirect_to @event
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def set_photo
    @photo = @event.photos.find(params[:id])
  end

  def photo_params
    params.fetch(:photo, {}).permit(:photo)
  end
end